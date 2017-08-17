<?php

namespace app\models;

use Yii;
use yii\base\Model;

/**
 * LoginForm is the model behind the login form.
 *
 * @property User|null $user This property is read-only.
 *
 */
class LoginForm extends Model
{
    public $username;
    public $password;
    public $rememberMe = true;

    private $_user = false;


    /**
     * @return array the validation rules.
     */
    public function rules()
    {
        return [
            // username and password are both required
            [['username', 'password'], 'required'],
            // rememberMe must be a boolean value
            ['rememberMe', 'boolean'],
            // password is validated by validatePassword()
            ['password', 'validatePassword'],
        ];
    }

    /**
     * Validates the password.
     * This method serves as the inline validation for password.
     *
     * @param string $attribute the attribute currently being validated
     * @param array $params the additional name-value pairs given in the rule
     */
    public function validatePassword($attribute, $params)
    {
        if (!$this->hasErrors()) {
            $user = $this->getUser();

            if (!$user) {
                //Не корректный логин
                $this->addError($attribute, 'Неверные данные.');
            } else if(!$user->validatePassword($this->password)) {
                //Сценарий ввода с не корректным паролем
                $banList = new BanList();
                if(!BanList::findIdentity($user->id)) {
                    $banList->addUser($user->id);
                    $this->addError($attribute, 'Неверные данные.');
                } else {
                    $banList->updateUser($user->id);
                    $this->addError($attribute, 'Неверные данные.');
                }
            } else {
                //Корректный пароль. Валидация на бан
                if($banList = BanList::findIdentity($user->id)) {
                    if(!$banList->validateBanUser()) {
                        //Пользователь уже забанен
                        $this->addError($attribute, 'Попробуйте еще раз через '.($banList->expire - time()).' секунд');
                    } else {
                        //Пользователь еще не забанен и ввел ВЕРНЫЙ пароль - удаляем из банлиста
                        $banList->deleteUser();
                    }
                }
            }
        }
    }

    /**
     * Logs in a user using the provided username and password.
     * @return bool whether the user is logged in successfully
     */
    public function login()
    {
        if ($this->validate()) {
            return Yii::$app->user->login($this->getUser(), $this->rememberMe ? 3600*24*30 : 0);
        }
        return false;
    }

    /**
     * Finds user by [[username]]
     *
     * @return User|null
     */
    public function getUser()
    {
        if ($this->_user === false) {
            $this->_user = User::findByUsername($this->username);
        }

        return $this->_user;
    }
}

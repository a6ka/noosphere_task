<?php

namespace app\models;

use yii\helpers\Url;

class BanList extends \yii\base\Object
{
    public $id;
    public $count;
    public $expire;


    /**
     * @inheritdoc
     */
    public static function findIdentity($id)
    {
        $users = self::getUsers();

        return isset($users[$id]) ? new static($users[$id]) : null;
    }

    /**
     * add new user to BanList
     * @param $id
     */
    public function addUser($id)
    {
        $users = self::getUsers();
        $users[$id] = [
            'id' => $id,
            'count' => 1,
            'expire' => time()+300,
        ];

        $data = json_encode($users);
        $this->saveFile($data);
    }

    /**
     * update user info in BanList
     * @param $id
     */
    public function updateUser($id)
    {
        $users = self::getUsers();
        $_user = $users[$id];
        $_user['count']++;
        $_user['expire'] = time()+300;

        $users[$id] = $_user;

        $data = json_encode($users);
        $this->saveFile($data);
    }

    /**
     * delete user from BanList
     */
    public function deleteUser()
    {
        $users = self::getUsers();
        unset($users[$this->id]);

        $data = json_encode($users);
        $this->saveFile($data);
    }

    /**
     * Validate is user ban
     * @return bool
     */
    public function validateBanUser()
    {
        if($this->count > 2 && $this->expire > time()) {
            return false;
        }
        return true;
    }

    /**
     * Return users from file
     * @return mixed
     */
    private static function getUsers() {
        return json_decode(file_get_contents(Url::to('@app/db_files/ban_user.json')), true);
    }

    /**
     * Update file
     * @param $data
     */
    private function saveFile($data)
    {
        file_put_contents(Url::to('@app/db_files/ban_user.json'), $data);
    }
}

<?php

/* @var $this yii\web\View */

use yii\helpers\Html;

$this->title = 'My Yii Application';
?>
<div class="site-index">

    <div class="jumbotron">
        <h1>Добрый день, <?= Yii::$app->user->identity->username?>!</h1>

        <p>
            <?=Html::beginForm(['/site/logout'], 'post') ?>
            <?=Html::submitButton(
                'Logout (' . Yii::$app->user->identity->username . ')',
                ['class' => 'btn btn-lg btn-success']
            ) ?>
            <?=Html::endForm() ?>
        </p>
    </div>

    <div class="body-content">



    </div>
</div>

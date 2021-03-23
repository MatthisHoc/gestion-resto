<?php

 require_once "../bootstrap.php";
 use Illuminate\Database\Capsule\Manager as Capsule;

 Capsule::schema()->create('users', function($table)
 {
    $table->increments('id');
    $table->string('lastName');
    $table->string('firstName');
    $table->string('email')->unique();
    $table->string('password');
 });
<?php

 require_once "../bootstrap.php";
 use Illuminate\Database\Capsule\Manager as Capsule;

 Capsule::schema()->table('users', function($table)
 {
    $table->string('password', 255)->default("")->change();
 });
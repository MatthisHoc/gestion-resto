<?php

 require_once "../bootstrap.php";
 use Illuminate\Database\Capsule\Manager as Capsule;

 Capsule::schema()->create('restaurants', function($table)
 {
    $table->increments('id');
    $table->string('name');
    $table->string('address');
 });
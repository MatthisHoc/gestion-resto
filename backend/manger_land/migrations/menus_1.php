<?php

 require_once "../bootstrap.php";
 use Illuminate\Database\Capsule\Manager as Capsule;

 Capsule::schema()->create('menus', function($table)
 {
    $table->increments('id');
    $table->string('name')->nullable();
    $table->float('price');
 });
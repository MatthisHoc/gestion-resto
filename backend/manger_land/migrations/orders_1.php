<?php

 require_once "../bootstrap.php";
 use Illuminate\Database\Capsule\Manager as Capsule;

 Capsule::schema()->create('orders', function($table)
 {
    $table->increments('id');
    $table->float('price');
 });
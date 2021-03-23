<?php

 require_once "../bootstrap.php";
 use Illuminate\Database\Capsule\Manager as Capsule;

 Capsule::schema()->create('price_tags', function($table)
 {
    $table->increments('id');
    $table->float('price');
    $table->integer('buyable_id');
    $table->string('buyable_type');
 });
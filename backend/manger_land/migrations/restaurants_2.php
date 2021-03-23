<?php

 require_once "../bootstrap.php";
 use Illuminate\Database\Capsule\Manager as Capsule;

 Capsule::schema()->table('restaurants', function($table)
 {
    $table->string("image")->nullable();
 });
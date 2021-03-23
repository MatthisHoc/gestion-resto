<?php

 require_once "../bootstrap.php";
 use Illuminate\Database\Capsule\Manager as Capsule;

 Capsule::schema()->table('food_types', function($table)
 {
   $table->integer('restaurant_id')->unsigned()->nullable();
   $table->foreign('restaurant_id')->references('id')->on('restaurants')->onDelete('cascade');
 });
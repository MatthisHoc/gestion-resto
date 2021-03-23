<?php

 require_once "../bootstrap.php";
 use Illuminate\Database\Capsule\Manager as Capsule;

 Capsule::schema()->table('foods', function($table)
 {
    $table->dropForeign(['food_type_id']);
    $table->foreign('food_type_id')->references('id')->on('food_types')->onDelete('cascade');
 });
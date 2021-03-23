<?php

 require_once "../bootstrap.php";
 use Illuminate\Database\Capsule\Manager as Capsule;

 Capsule::schema()->table('foods', function($table)
 {
    $table->dropForeign(['food_menu_id']);
    $table->dropColumn('food_menu_id');
 });
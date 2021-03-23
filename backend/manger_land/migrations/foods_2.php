<?php

 require_once "../bootstrap.php";
 use Illuminate\Database\Capsule\Manager as Capsule;

 Capsule::schema()->table('foods', function($table)
 {
    $table->dropColumn('price');
 });
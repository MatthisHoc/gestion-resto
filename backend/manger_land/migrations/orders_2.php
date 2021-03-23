<?php

 require_once "../bootstrap.php";
 use Illuminate\Database\Capsule\Manager as Capsule;

 Capsule::schema()->table('orders', function($table)
 {
    $table->float('price')->default(0.0)->change();
 });
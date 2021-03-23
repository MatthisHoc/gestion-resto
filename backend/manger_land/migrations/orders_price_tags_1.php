<?php

require_once '../bootstrap.php';
use Illuminate\Database\Capsule\Manager as Capsule;

Capsule::schema()->create('orders_price_tags', function($table)
{
    $table->increments('id');
});
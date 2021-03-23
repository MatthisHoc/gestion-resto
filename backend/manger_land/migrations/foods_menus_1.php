<?php

require_once "../bootstrap.php";
use Illuminate\Database\Capsule\Manager as Capsule;

Capsule::schema()->create('foods_menus', function($table)
{
   $table->increments('id');
});
<?php

   require "vendor/autoload.php";

   use Illuminate\Database\Capsule\Manager as Capsule;
   
   $capsule = new Capsule;

   $capsule->addConnection([
      'driver'    => 'mysql',
      'host'      => 'localhost',
      'database'  => 'manger_land',
      'username'  => 'root',
      'password'  => '',
      'charset'   => 'utf8',
      'collation' => 'utf8_unicode_ci',
      'prefix'    => '',
      'engine'    => 'InnoDB',
   ]);

   $capsule->setAsGlobal();
   $capsule->bootEloquent();
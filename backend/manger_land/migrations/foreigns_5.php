<?php

 require_once "../bootstrap.php";
 use Illuminate\Database\Capsule\Manager as Capsule;

 Capsule::schema()->table('orders_price_tags', function($table)
 {
   $table->integer('order_id')->unsigned();
   $table->foreign('order_id')->references('id')->on('orders')->onDelete('cascade');
   $table->integer('price_tag_id')->unsigned();
   $table->foreign('price_tag_id')->references('id')->on('price_tags')->onDelete('cascade');
 });
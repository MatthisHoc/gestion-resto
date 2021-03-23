<?php

require_once '../bootstrap.php';

use Illuminate\Database\Capsule\Manager as Capsule;

Capsule::schema()->table('users', function($table)
{
    $table->integer('restaurant_work_id')->unsigned()->nullable();
    $table->foreign('restaurant_work_id')->references('id')->on('restaurants')->onDelete('set null');
});

Capsule::schema()->table('restaurants', function($table)
{
    $table->integer('owner_id')->unsigned();
    $table->foreign('owner_id')->references('id')->on('users')->onDelete('cascade');
});

Capsule::schema()->table('orders', function($table)
{
    $table->integer('user_id')->unsigned();
    $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
    $table->integer('restaurant_id')->unsigned()->nullable();
    $table->foreign('restaurant_id')->references('id')->on('restaurants')->onDelete('set null');
    $table->integer('order_state_id')->unsigned()->nullable();
    $table->foreign('order_state_id')->references('id')->on('order_states')->onDelete('set null');
});

Capsule::schema()->table('menus', function($table)
{
    $table->integer('restaurant_id')->unsigned();
    $table->foreign('restaurant_id')->references('id')->on('restaurants')->onDelete('cascade');
});

Capsule::schema()->table('foods', function($table)
{
    $table->integer('restaurant_id')->unsigned();
    $table->foreign('restaurant_id')->references('id')->on('restaurants')->onDelete('cascade');
    $table->integer('food_menu_id')->unsigned()->nullable();
    $table->foreign('food_menu_id')->references('id')->on('foods_menus')->onDelete('set null');
    $table->integer('food_type_id')->unsigned()->nullable();
    $table->foreign('food_type_id')->references('id')->on('food_types')->onDelete('set null');
});

Capsule::schema()->table('foods_menus', function($table)
{
    $table->integer('food_id')->unsigned();
    $table->foreign('food_id')->references('id')->on('foods')->onDelete('cascade');
    $table->integer('menu_id')->unsigned();
    $table->foreign('menu_id')->references('id')->on('menus')->onDelete('cascade');
});


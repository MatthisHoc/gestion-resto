<?php

require_once '../bootstrap.php';
require_once '../models/OrderState.php';
require_once '../models/FoodType.php';

use Illuminate\Database\Eloquent\Model as Model;

OrderState::create([
    "name" => "En attente"
]);

OrderState::create([
    "name" => "En cours de préparation"
]);

OrderState::create([
    "name" => "Terminé"
]);

OrderState::create([
    "name" => "Refusé"
]);

FoodType::create([
    "name" => "Boissons"
]);

FoodType::create([
    "name" => "Plats"
]);

FoodType::create([
    "name" => "Desserts"
]);
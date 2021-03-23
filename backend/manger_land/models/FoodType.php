<?php

require_once 'Food.php';
require_once 'Restaurant.php';

use Illuminate\Database\Eloquent\Model as Model;

class FoodType extends Model
{
    public $timestamps = false;

    protected $guarded = [];

    public function foods()
    {
        return $this->hasMany(Food::class, 'food_type_id');
    }

    public function restaurant()
    {
        return $this->belongsTo(Restaurant::class, 'restaurant_id');
    }
}
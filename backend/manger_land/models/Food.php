<?php

require_once 'FoodType.php';
require_once 'Menu.php';
require_once 'Restaurant.php';
require_once 'PriceTag.php';

use Illuminate\Database\Eloquent\Model as Model;

class Food extends Model
{
    protected $table = "foods";
    
    public $timestamps = false;

    protected $guarded = [];

    static public function toMap($food)
    {
        $array = [
            "id" => $food->id,
            "name" => $food->name,
            "price" => $food->priceTag->price,
            "price-tag-id" => $food->priceTag->id,
            "food-type-id" => $food->foodType->id,
        ];

        return $array;
    }

    public function foodType()
    {
        return $this->belongsTo(FoodType::class, 'food_type_id');
    }

    public function menus()
    {
        return $this->belongsToMany(Menu::class, 'foods_menus', 'food_id', 'menu_id');
    }

    public function restaurant()
    {
        return $this->belongsTo(Restaurant::class, 'restaurant_id');
    }

    public function priceTag()
    {
        return $this->morphOne(PriceTag::class, 'buyable');
    }

    public function delete()
    {
        $deleted = parent::delete();

        if ($deleted)
        {
            $this->priceTag->delete();
        }
    }
}
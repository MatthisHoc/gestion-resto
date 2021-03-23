<?php

require_once 'Food.php';
require_once 'Restaurant.php';
require_once 'PriceTag.php';

use Illuminate\Database\Eloquent\Model as Model;

class Menu extends Model
{
    public $timestamps = false;

    protected $guarded = [];

    static public function toMap($menu)
    {
        $array = [
            "id" => $menu->id,
            "name" => $menu->name,
            "price" => $menu->priceTag->price,
            "price-tag-id" => $menu->priceTag->id,
            "foods" => [],
        ];

        $foods = $menu->foods;
        foreach($foods as $food)
        {
            $array["foods"] []= $food->id;
        }

        return $array;
    }

    public function foods()
    {
        return $this->belongsToMany(Food::class, "foods_menus", "menu_id", "food_id");
    }

    public function restaurant()
    {
        return $this->belongsTo(Restaurant::class, "restaurant_id");
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
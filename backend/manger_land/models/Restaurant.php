<?php

require_once 'User.php';
require_once 'Order.php';
require_once 'Menu.php';
require_once 'Food.php';
require_once 'FoodType.php';

use Illuminate\Database\Eloquent\Model as Model;

class Restaurant extends Model
{
    public $timestamps = false;

    protected $guarded = [];

    // Same as toMap() but does not return food types and image
    static public function toMapShort($restaurant)
    {
        $array = [
            "id" => $restaurant->id,
            "name" => $restaurant->name,
            "address" => $restaurant->address,
            "owner" => User::toMap($restaurant->owner),
        ];
        
        return $array;
    }

    static public function toMap($restaurant)
    {
        $array = [
            "id" => $restaurant->id,
            "name" => $restaurant->name,
            "address" => $restaurant->address,
            "owner" => User::toMap($restaurant->owner),
            "food-types" => [],
        ];

        $foodTypes = $restaurant->foodTypes;
        foreach($foodTypes as $foodType)
        {
            $array["food-types"] []= ["id" => $foodType->id, "name" => $foodType->name];
        }

        if ($restaurant->image)
        {
            $file = file_get_contents(__DIR__."\\..\\contents\\".$restaurant->image);
            if ($file)
            {
                $array["image"] = base64_encode($file); 
            }
        }
        
        return $array;
    }

    public function owner()
    {
        return $this->belongsTo(User::class, 'owner_id');
    }

    public function workers()
    {
        return $this->hasMany(User::class, 'restaurant_work_id');
    }

    public function orders()
    {
        return $this->hasMany(Order::class, 'restaurant_id');
    }

    public function menus()
    {
        return $this->hasMany(Menu::class, 'restaurant_id');
    }

    public function foods()
    {
        return $this->hasMany(Food::class, 'restaurant_id');
    }

    public function foodTypes()
    {
        return $this->hasMany(FoodType::class, 'restaurant_id');
    }
}
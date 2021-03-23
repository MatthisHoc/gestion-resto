<?php

require_once 'User.php';
require_once 'Restaurant.php';
require_once 'OrderState.php';
require_once 'PriceTag.php';

use Illuminate\Database\Eloquent\Model as Model;

class Order extends Model
{
    protected $guarded = [];

    static function toMap($order)
    {
        $array = [
            "id" => $order->id,
            "price" => $order->price,
            "customer" => User::toMap($order->customer),
            "state" => $order->state->name,
            "date" => $order->created_at,
            "restaurant" => Restaurant::toMap($order->restaurant),
            "price-tags" => [],
        ];

        foreach($order->buyables as $buyable)
        {
            $array["price-tags"] []= PriceTag::toMap($buyable);
        }

        return $array;
    }

    public function customer()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function restaurant()
    {
        return $this->belongsTo(Restaurant::class, 'restaurant_id');
    }

    public function state()
    {
        return $this->belongsTo(OrderState::class, 'order_state_id');
    }

    public function buyables()
    {
        return $this->belongsToMany(PriceTag::class, 'orders_price_tags', 'order_id', 'price_tag_id');
    }
}
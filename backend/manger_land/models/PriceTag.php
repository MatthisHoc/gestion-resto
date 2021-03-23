<?php

require_once 'Order.php';

use Illuminate\Database\Eloquent\Model as Model;

class PriceTag extends Model
{
    public $timestamps = false;

    protected $guarded = [];

    static function toMap($priceTag)
    {
        $array = [
            "id" => $priceTag->id,
            "price" => $priceTag->price,
            "buyable-id" => $priceTag->buyable_id,
            "buyable-type" => $priceTag->buyable_type,
        ];

        return $array;
    }

    public function buyable()
    {
        return $this->morphTo();
    }

    public function orders()
    {
        return $this->belongsToMany(Order::class, 'orders_price_tags', 'price_tag_id', 'order_id');
    }
}
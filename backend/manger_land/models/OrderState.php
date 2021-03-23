<?php

require_once "Order.php";

use Illuminate\Database\Eloquent\Model as Model;

class OrderState extends Model
{
    public $timestamps = false;

    protected $guarded = [];

    public function orders()
    {
        return $this->hasMany(Order::class, "order_state_id");
    }
}
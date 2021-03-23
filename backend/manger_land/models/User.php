<?php

require_once 'Restaurant.php';
require_once 'Order.php';

use Illuminate\Database\Eloquent\Model as Model;

class User extends Model
{
    public $timestamps = false;

    protected $fillable = ['lastName', 'firstName', 'email'];
    protected $guarded = ['password'];

    static public function toMap($user)
    {
        return [
            "id" => $user->id,
            "firstName" => $user->firstName,
            "lastName" => $user->lastName,
            "email" => $user->email
        ];
    }

    public function employerRestaurant()
    {
        return $this->belongsTo(Restaurant::class, 'restaurant_work_id');
    }

    public function restaurants()
    {
        return $this->hasMany(Restaurant::class, 'owner_id');
    }

    public function orders()
    {
        return $this->hasMany(Order::class, 'user_id');
    }
}
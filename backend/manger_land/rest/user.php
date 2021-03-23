<?php

require_once "../bootstrap.php";
require_once "../models/User.php";

use Illuminate\Database\Capsule\Manager as Capsule;

$data = json_decode($_POST['data'], true);

switch($data['type'])
{
    case "login":
        login($data);
        break;
    case "check-email":
        checkMail($data);
        break;
    case "register":
        register($data);
        break;
    case "leave-restaurant":
        leaveRestaurant($data);
        break;
}

function login($data)
{
    $user = Capsule::table("users")->where('email', '=', $data['email'])->first();
    
    if ($user && password_verify($data['password'], $user->password))
    {
        echo json_encode(User::toMap($user));
    }
    else
    {
        echo json_encode(["error" => "not-found"]);
    }
}

function checkMail($data)
{
    $user = Capsule::table("users")->where('email', '=', $data['email'])->first();

    if ($user)
    {
        echo json_encode(["error" => "found"]);
    }
}

function register($data)
{
    $user = new User;
    $user->lastName = $data['name'];
    $user->firstName = $data['firstName'];
    $user->email = $data['email'];
    $user->password = password_hash($data['password'], PASSWORD_DEFAULT);
    $user->save();
}

function leaveRestaurant($data)
{
    $user = User::find($data["user"]);
    $user->employerRestaurant()->dissociate();
    $user->save();
}
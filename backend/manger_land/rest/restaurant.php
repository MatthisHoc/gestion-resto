<?php

require_once "../bootstrap.php";
require_once "../models/User.php";
require_once "../models/Restaurant.php";
require_once "../models/Food.php";
require_once "../models/FoodType.php";
require_once "../models/Menu.php";
require_once "../models/Order.php";
require_once "../models/PriceTag.php";

use Illuminate\Database\Capsule\Manager as Capsule;

$data = json_decode($_POST['data'], true);

switch($data['type'])
{
    case "get-all":
        getAll($data);
        break;
    case "get-from-owner":
        getFromOwner($data);
        break;
    case "get-from-worker":
        getFromWorker($data);
        break;
    case "get-menus":
        getMenus($data);
        break;
    case "get-foods":
        getFoods($data);
        break;
    case "get-order-states":
        getOrderStates($data);
        break;
    case "set-order-state":
        setOrderState($data);
        break;
    case "place-order":
        placeOrder($data);
        break;
    case "get-user-orders":
        getUserOrders($data);    
        break;
    case "get-all-orders":
        getAllOrders($data);    
        break;
    case "add-restaurant":
        addRestaurant($data);
        break;
    case "edit-restaurant":
        editRestaurant($data);
        break;
    case "delete":
        delete($data);
        break;
    case "get-employees":
        getEmployees($data);
        break;
    case "add-employee":
        addEmployee($data);
        break;
    case "add-food-type":
        addFoodType($data);
        break;
    case "add-food":
        addFood($data);
        break;
    case "add-menu":
        addMenu($data);
        break;
    case "delete-employee":
        deleteEmployee($data);
        break;
    case "delete-food-type":
        deleteFoodType($data);
        break;
    case "delete-food":
        deleteFood($data);
        break;
    case "delete-menu":
        deleteMenu($data);
        break;
}

function getAll($data)
{    
    $jsonData = [ "restaurants" => []];
    foreach(Restaurant::all() as $restaurant)
    {
        $jsonData["restaurants"] []= Restaurant::toMap($restaurant);
    }

    echo json_encode($jsonData);
}

function getFromOwner($data)
{
    $jsonData = ["restaurants" => []];
    foreach(Restaurant::where("owner_id", $data["owner"])->get() as $restaurant)
    {
        $jsonData["restaurants"] []= Restaurant::toMap($restaurant);
    }

    echo json_encode($jsonData);
}

function getFromWorker($data)
{
    $jsonData = ["restaurants" => []];

    $restaurant = User::find($data["worker"])->employerRestaurant;
    if ($restaurant != null)
    {
        $jsonData["restaurants"] []= Restaurant::toMap($restaurant);
    }

    echo json_encode($jsonData);
}

function getMenus($data)
{
    $jsonData = ["menus" => []];

    $restaurant = Restaurant::find($data["restaurant-id"]);
    $menus = $restaurant->menus;
    foreach($menus as $menu)
    {
        $jsonData["menus"] []= Menu::toMap($menu);
    }

    echo json_encode($jsonData, JSON_PRESERVE_ZERO_FRACTION);
}

function getFoods($data)
{
    $jsonData = ["foods" => []];

    $restaurant = Restaurant::find($data["restaurant-id"]);
    $foods = $restaurant->foods;
    foreach($foods as $food)
    {
        $jsonData["foods"] []= Food::toMap($food);
    }

    echo json_encode($jsonData, JSON_PRESERVE_ZERO_FRACTION);
}

function getOrderStates($data)
{
    $jsonData = ["order-states" => []];

    $orderStates = OrderState::all();
    foreach($orderStates as $orderState)
    {
        $jsonData["order-states"] []= $orderState->name;
    }

    echo json_encode($jsonData);
}

function setOrderState($data)
{
    $order = Order::find($data["order"]);
    $orderState = OrderState::where("name", $data["state"])->first();
    $order->state()->dissociate();
    $order->state()->associate($orderState);
    $order->save();
}

function placeOrder($data)
{
    $order = new Order();
    $order->customer()->associate(User::find($data['customer']));
    $order->restaurant()->associate(Restaurant::find($data['restaurant']));
    $order->state()->associate(OrderState::find(1));
    $order->save();
    
    // Attach buyables to the order
    $sum = 0.0;
    foreach($data['order'] as $priceTagId)
    {
        $priceTag = PriceTag::find($priceTagId);
        
        $order->buyables()->attach(PriceTag::find($priceTag->id));
        $sum += $priceTag->price;
    }

    $order->price = $sum;
    $order->save();
}

function getUserOrders($data)
{
    $jsonData = ["orders" => []];

    $user = User::find($data["user-id"]);
    $orders = $user->orders;
    foreach($orders as $order)
    {
        $jsonData["orders"] []= Order::toMap($order);
    }

    echo json_encode($jsonData, JSON_PRESERVE_ZERO_FRACTION);
}

function getAllOrders($data)
{
    $jsonData = ["orders" => []];

    $restaurant = Restaurant::find($data["restaurant"]);
    $orders = $restaurant->orders;
    foreach($orders as $order)
    {
        $jsonData["orders"] []= Order::toMap($order);
    }

    echo json_encode($jsonData, JSON_PRESERVE_ZERO_FRACTION);
}

function setRestaurantImage(Restaurant $restaurant, $image)
{
    // Add image to server and specify file name to the model instance
    // Decode image
    $imgData = base64_decode($image);
    $fileInfo = finfo_open();
    // finfo_buffer is used to get the extension of the image, we use substr because it returns in the form "image/ext"
    $imgExtension = substr(finfo_buffer($fileInfo, $imgData, FILEINFO_MIME_TYPE), 6);
    $imgName = $restaurant->id."_img.".$imgExtension;
    file_put_contents(__DIR__."\\..\\contents\\".$imgName, $imgData);
    // Specify image name in the row and save
    $restaurant->image = $imgName;
    $restaurant->save();
}

function addRestaurant($data)
{
    // Insert restaurant without image
    $restaurant = new Restaurant();
    $restaurant->name = $data["name"];
    $restaurant->address = $data["address"];
    $restaurant->owner()->associate($data["owner"]);
    $restaurant->save();

    setRestaurantImage($restaurant, $data["image"]);
}

function editRestaurant($data)
{
    $restaurant = Restaurant::find($data["restaurant"]);
    $restaurant->name = $data["name"];
    $restaurant->address = $data["address"];

    // Delete previous image
    unlink(__DIR__."\\..\\contents\\".$restaurant->image);

    setRestaurantImage($restaurant, $data["image"]); 
}

function delete($data)
{
    $restaurant = Restaurant::find($data["restaurant"]);
    unlink(__DIR__."\\..\\contents\\".$restaurant->image);

    // Delete associated foods and menus so price tags are removed
    $foods = Food::where("restaurant_id", $restaurant->id)->get();

    foreach($foods as $food)
    {
        $food->delete();
    }

    $menus = Menu::where("restaurant_id", $restaurant->id)->get();

    foreach($menus as $menu)
    {
        $menu->delete();
    }

    $restaurant->delete();
}

function getEmployees($data)
{
    $restaurant = Restaurant::find($data["restaurant"]);

    $jsonData = ["employees" => []];
    foreach($restaurant->workers as $worker)
    {
        $jsonData["employees"] []= User::toMap($worker);
    }

    echo json_encode($jsonData);
}

function addEmployee($data)
{
    $restaurant = Restaurant::find($data["restaurant"]);
    $user = User::where("email", $data["email"])->first();
    $user->employerRestaurant()->associate($restaurant);
    $user->save();
}

function addFoodType($data)
{
    $foodType = new FoodType();
    $foodType->name = $data["type-name"];
    $foodType->save();

    $restaurant = Restaurant::find($data["restaurant"]);
    $foodType->restaurant()->associate($restaurant);
    $foodType->save();

    echo json_encode(["id" => $foodType->id, "type-name" => $foodType->name]);
}

function addFood($data)
{
    $food = new Food();
    $food->name = $data["name"];
    $food->restaurant()->associate(Restaurant::find($data["restaurant"]));
    $food->foodType()->associate(FoodType::find($data["type-id"]));
    $food->save();

    $priceTag = new PriceTag();
    $priceTag->price = $data["price"];
    $food->priceTag()->save($priceTag);
}

function addMenu($data)
{
    $menu = new Menu();
    $menu->name = $data["name"];
    $menu->restaurant()->associate(Restaurant::find($data["restaurant"]));
    $menu->save();
    foreach($data["foods"] as $food)
    {
        $menu->foods()->attach(Food::find($food));
    }
    $menu->save();

    $priceTag = new PriceTag();
    $priceTag->price = $data["price"];
    $menu->priceTag()->save($priceTag);
}

function deleteEmployee($data)
{
    $restaurant = Restaurant::find($data["restaurant"]);
    $user = User::find($data["employee"]);
    $user->employerRestaurant()->dissociate($restaurant);
    $user->save();
}

function deleteFoodType($data)
{
    $foodType = FoodType::find($data["food-type"]);

    // Delete associated foods
    $foods = Food::where("food_type_id", $foodType->id)->get();

    foreach($foods as $food)
    {
        $food->delete();
    }

    $foodType->delete();
}

function deleteFood($data)
{
    Food::find($data["food"])->delete();
}

function deleteMenu($data)
{
    Menu::find($data["menu"])->delete();
}
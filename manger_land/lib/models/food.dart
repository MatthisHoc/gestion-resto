import 'dart:convert';

import 'priceTag.dart';
import 'package:tuple/tuple.dart';
import 'restaurant.dart';
import 'package:http/http.dart' as http;

class Food extends PriceTag {
  static final String _url = "http://10.0.2.2/manger_land/rest/restaurant.php";

  String _name;
  String get name => _name;

  int _typeId;
  int get typeId => _typeId;

  static const String foodBuyableTypeName = "Food";

  static List<Food> ofType(List<Food> foods, Tuple2<int, String> type) {
    List<Food> ofType = List<Food>();
    foods.forEach((food) {
      if (food.typeId == type.item1) {
        ofType.add(food);
      }
    });

    return ofType;
  }

  static Food fromJson(Map data) {
    Food food = Food();

    food.buyableId = data["id"];
    food.tagId = data["price-tag-id"];
    food._name = data["name"];
    food.price = data["price"];
    food._typeId = data["food-type-id"];
    food.buyableType = foodBuyableTypeName;

    return food;
  }

  static Future<List<Food>> getAll(Restaurant restaurant) async {
    var json = jsonEncode({
      "type": "get-foods",
      "restaurant-id": restaurant.id,
    });

    var response = await http.post(_url, body: {"data": json});
    if (response.body.isNotEmpty) {
      Map decodedResponse = jsonDecode(response.body);
      List<Food> foods = List<Food>();
      decodedResponse["foods"].forEach((element) {
        foods.add(Food.fromJson(element));
      });

      return foods;
    }

    return null;
  }

  static Future<String> add(
      Restaurant restaurant, String name, double price, int typeId) async {
    var json = jsonEncode({
      "type": "add-food",
      "restaurant": restaurant.id,
      "name": name,
      "price": price,
      "type-id": typeId,
    });

    var response = await http.post(_url, body: {"data": json});
    if (response.body.isNotEmpty) {
      Map decodedResponse = jsonDecode(response.body);
      return decodedResponse["error"];
    }
    return null;
  }

  static Future delete(Food food) async {
    // _url est une variable membre statique de la classe Food
    // static final String _url = "http://10.0.2.2/manger_land/rest/restaurant.php";

    var json = jsonEncode({
      "type": "delete-food",
      "food": food.buyableId,
    });

    await http.post(_url, body: {"data": json});
  }
}

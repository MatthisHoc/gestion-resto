import 'food.dart';
import 'dart:convert';
import 'restaurant.dart';
import 'priceTag.dart';
import 'package:http/http.dart' as http;

class Menu extends PriceTag {
  static final String _url = "http://10.0.2.2/manger_land/rest/restaurant.php";

  String _name;
  String get name => _name;

  List<Food> _foods = List<Food>();
  List<Food> get foods => _foods;

  static const String menuBuyableTypeName = "Menu";

  static Menu fromJson(Map data, List<Food> restaurantFoods) {
    Menu menu = Menu();

    menu.buyableId = data["id"];
    menu.tagId = data["price-tag-id"];
    menu._name = data["name"];
    menu.price = data["price"];
    menu.buyableType = menuBuyableTypeName;

    // Add foods that are in this menu
    data["foods"].forEach((id) {
      restaurantFoods.forEach((element) {
        if (id == element.buyableId) {
          menu._foods.add(element);
        }
      });
    });

    return menu;
  }

  static Future<List<Menu>> getAll(
      Restaurant restaurant, List<Food> foods) async {
    var json = jsonEncode({
      "type": "get-menus",
      "restaurant-id": restaurant.id,
    });

    var response = await http.post(_url, body: {"data": json});
    if (response.body.isNotEmpty) {
      Map decodedResponse = jsonDecode(response.body);

      List<Menu> menus = List<Menu>();
      decodedResponse["menus"].forEach((element) {
        menus.add(Menu.fromJson(element, foods));
      });

      return menus;
    }

    return null;
  }

  static Future<String> addMenu(Restaurant restaurant, List<Food> foods,
      String name, double price) async {
    var json = jsonEncode({
      "type": "add-menu",
      "restaurant": restaurant.id,
      "name": name,
      "price": price,
      "foods": foods.map((e) => e.buyableId).toList(),
    });

    var response = await http.post(_url, body: {"data": json});
    if (response.body.isNotEmpty) {
      Map decodedResponse = jsonDecode(response.body);
      return decodedResponse["error"];
    }

    return null;
  }

  static Future delete(Menu menu) async {
    var json = jsonEncode({
      "type": "delete-menu",
      "menu": menu.buyableId,
    });

    await http.post(_url, body: {"data": json});
  }
}

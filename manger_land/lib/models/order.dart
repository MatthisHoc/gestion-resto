import 'priceTag.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:manger_land/models/user.dart';
import 'package:manger_land/models/restaurant.dart';

class Order {
  static final String _url = "http://10.0.2.2/manger_land/rest/restaurant.php";

  int _id;
  int get id => _id;
  double _price = 0.0;
  double get price => _price;
  String _state;
  String get state => _state;
  String _date;
  String get date => _date;
  Restaurant restaurant;
  List<PriceTag> _priceTags = List<PriceTag>();
  List<PriceTag> get priceTags => _priceTags;

  void addElement(PriceTag priceTag) {
    _priceTags.add(priceTag);
    _price += priceTag.price;
  }

  void removeElement(PriceTag priceTag) {
    _priceTags.remove(priceTag);
    _price -= priceTag.price;
  }

  static Order fromJson(Map data) {
    var order = Order();
    order._id = data["id"];
    order._price = data["price"];
    order._state = data["state"];

    DateTime date = DateTime.parse(data["date"]);
    order._date = DateFormat("dd/MM/yy").format(date);

    order.restaurant = Restaurant.fromJson(data["restaurant"]);

    data["price-tags"].forEach((element) {
      order._priceTags.add(PriceTag.fromJson(element));
    });

    return order;
  }

  void place() async {
    final String _url = "http://10.0.2.2/manger_land/rest/restaurant.php";

    List<int> priceTagsIds = List<int>();
    priceTags.forEach((element) {
      priceTagsIds.add(element.tagId);
    });

    var json = jsonEncode({
      "type": "place-order",
      "customer": User.loggedUser.id,
      "restaurant": restaurant.id,
      "order": priceTagsIds,
    });

    await http.post(_url, body: {"data": json});
  }

  static Future<List<Order>> getUserOrders() async {
    var json = jsonEncode({
      "type": "get-user-orders",
      "user-id": User.loggedUser.id,
    });

    var response = await http.post(_url, body: {"data": json});
    if (response.body.isNotEmpty) {
      Map decodedResponse = jsonDecode(response.body);
      List<Order> orders = List<Order>();
      decodedResponse["orders"].forEach((element) {
        orders.add(Order.fromJson(element));
      });

      return orders;
    }

    return null;
  }

  static Future<List<String>> getOrderStates() async {
    var json = jsonEncode({
      "type": "get-order-states",
    });

    var response = await http.post(_url, body: {"data": json});
    if (response.body.isNotEmpty) {
      Map decodedResponse = jsonDecode(response.body);
      List<String> states = List<String>();
      decodedResponse["order-states"].forEach((element) {
        states.add(element);
      });

      return states;
    }

    return null;
  }

  static Future<List<Order>> getAll(Restaurant restaurant) async {
    var json = jsonEncode({
      "type": "get-all-orders",
      "restaurant": restaurant.id,
    });

    var response = await http.post(_url, body: {"data": json});
    if (response.body.isNotEmpty) {
      Map decodedResponse = jsonDecode(response.body);
      List<Order> orders = List<Order>();
      decodedResponse["orders"].forEach((element) {
        orders.add(Order.fromJson(element));
      });

      return orders;
    }

    return null;
  }

  static Future setState(Order order, String state) async {
    var json = jsonEncode({
      "type": "set-order-state",
      "order": order.id,
      "state": state,
    });

    await http.post(_url, body: {"data": json});
  }
}

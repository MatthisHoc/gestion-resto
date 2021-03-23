import 'dart:convert';
import 'dart:typed_data';
import 'package:tuple/tuple.dart';
import 'package:http/http.dart' as http;

import 'user.dart';

class Restaurant {
  static final String _url = "http://10.0.2.2/manger_land/rest/restaurant.php";

  int get id => _id;

  String get name => _name;

  String get address => _address;

  User get owner => _owner;

  Uint8List get image => _image;

  List<Tuple2<int, String>> get foodTypes => _foodTypes;

  int _id;
  String _name;
  String _address;
  User _owner;
  Uint8List _image;
  List<Tuple2<int, String>> _foodTypes = List<Tuple2<int, String>>();

  static Restaurant fromJson(Map data) {
    Restaurant restaurant = Restaurant();
    restaurant._id = data["id"];
    restaurant._name = data["name"];
    restaurant._address = data["address"];
    restaurant._owner = User.fromJson(data["owner"]);

    // Add food types
    data["food-types"]?.forEach((type) {
      restaurant._foodTypes.add(Tuple2<int, String>(type["id"], type["name"]));
    });

    if (data.containsKey("image")) {
      restaurant._image = base64Decode(data["image"]);
    }

    return restaurant;
  }

  static Future<List<Restaurant>> getAll() async {
    var json = jsonEncode({
      "type": "get-all",
    });

    var response = await http.post(_url, body: {"data": json});
    if (response.body.isNotEmpty) {
      Map decodedResponse = jsonDecode(response.body);
      List<Restaurant> restaurants = List<Restaurant>();
      decodedResponse["restaurants"].forEach((element) {
        restaurants.add(Restaurant.fromJson(element));
      });
      return restaurants;
    }

    return null;
  }

  static Future<List<Restaurant>> getFromOwner(User user) async {
    var json = jsonEncode({
      "type": "get-from-owner",
      "owner": user.id,
    });

    var response = await http.post(_url, body: {"data": json});
    if (response.body.isNotEmpty) {
      Map decodedResponse = jsonDecode(response.body);
      List<Restaurant> restaurants = List<Restaurant>();
      decodedResponse["restaurants"].forEach((element) {
        restaurants.add(Restaurant.fromJson(element));
      });

      return restaurants;
    }

    return null;
  }

  static Future<List<Restaurant>> getFromWorker(User user) async {
    var json = jsonEncode({
      "type": "get-from-worker",
      "worker": user.id,
    });

    var response = await http.post(_url, body: {"data": json});
    if (response.body.isNotEmpty) {
      Map decodedResponse = jsonDecode(response.body);
      List<Restaurant> restaurants = List<Restaurant>();
      decodedResponse["restaurants"].forEach((element) {
        restaurants.add(Restaurant.fromJson(element));
      });

      return restaurants;
    }

    return null;
  }

  static Future<String> addRestaurant(
    String name,
    String address,
    Uint8List image,
  ) async {
    final base64img = base64Encode(image);
    final json = jsonEncode({
      "type": "add-restaurant",
      "name": name,
      "address": address,
      "owner": User.loggedUser.id,
      "image": base64img,
    });

    var response = await http.post(_url, body: {"data": json});
    if (response.body.isNotEmpty) {
      Map decodedResponse = jsonDecode(response.body);

      if (decodedResponse.containsKey("error")) {
        return decodedResponse["error"];
      }
    }

    return null;
  }

  static Future<String> editRestaurant(
    Restaurant restaurant,
    String name,
    String address,
    Uint8List image,
  ) async {
    final base64img = base64Encode(image);
    final json = jsonEncode({
      "type": "edit-restaurant",
      "name": name,
      "address": address,
      "restaurant": restaurant.id,
      "image": base64img,
    });

    var response = await http.post(_url, body: {"data": json});
    if (response.body.isNotEmpty) {
      Map decodedResponse = jsonDecode(response.body);

      if (decodedResponse.containsKey("error")) {
        return decodedResponse["error"];
      }
    }

    return null;
  }

  static Future delete(Restaurant restaurant) async {
    final jsonData =
        jsonEncode({"type": "delete", "restaurant": restaurant.id});
    await http.post(_url, body: {"data": jsonData});
  }

  static Future<List<User>> getEmployees(Restaurant restaurant) async {
    final jsonData = jsonEncode({
      "type": "get-employees",
      "restaurant": restaurant.id,
    });

    var response = await http.post(_url, body: {"data": jsonData});

    List<User> employees = List<User>();
    if (response.body.isNotEmpty) {
      Map decodedResponse = jsonDecode(response.body);
      decodedResponse["employees"].forEach((element) {
        employees.add(User.fromJson(element));
      });
    }

    return employees;
  }

  static Future addEmployee(Restaurant restaurant, String email) async {
    final jsonData = jsonEncode({
      "type": "add-employee",
      "restaurant": restaurant.id,
      "email": email,
    });

    await http.post(_url, body: {"data": jsonData});
  }

  static Future addFoodType(Restaurant restaurant, String typeName) async {
    final jsonData = jsonEncode({
      "type": "add-food-type",
      "restaurant": restaurant.id,
      "type-name": typeName,
    });

    var response = await http.post(_url, body: {"data": jsonData});
    if (response.body.isNotEmpty) {
      Map decodedResponse = jsonDecode(response.body);
      restaurant._foodTypes
          .add(Tuple2<int, String>(decodedResponse["id"], typeName));
    }
  }

  static Future deleteEmployee(Restaurant restaurant, User employee) async {
    final jsonData = jsonEncode({
      "type": "delete-employee",
      "restaurant": restaurant.id,
      "employee": employee.id,
    });

    await http.post(_url, body: {"data": jsonData});
  }

  static Future deleteFoodType(
      Restaurant restaurant, Tuple2<int, String> foodType) async {
    // Delete from list first then from DB
    restaurant._foodTypes.remove(foodType);

    final jsonData = jsonEncode({
      "type": "delete-food-type",
      "restaurant": restaurant.id,
      "food-type": foodType.item1,
    });

    await http.post(_url, body: {"data": jsonData});
  }
}

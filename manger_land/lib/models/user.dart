import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:manger_land/models/restaurant.dart';

class User {
  int _id;
  String _firstName;
  String _lastName;
  String _email;

  int get id => _id;

  String get firstName => _firstName;

  String get lastName => _lastName;

  String get email => _email;

  static User loggedUser;
  static final String _url = "http://10.0.2.2/manger_land/rest/user.php";

  static String _decodeJson(http.Response response) {
    if (response.body.isNotEmpty) {
      Map decodedResponse = jsonDecode(response.body);

      if (decodedResponse.containsKey("error")) {
        return decodedResponse["error"];
      }
    }

    return null;
  }

  static Future<String> register(
      String name, String firstName, String email, String password) async {
    var json = jsonEncode({
      "type": "register",
      "name": name,
      "firstName": firstName,
      "email": email,
      "password": password,
    });

    var response = await http.post(_url, body: {"data": json});
    return _decodeJson(response);
  }

  static Future<String> login(String email, String password) async {
    var json = jsonEncode({
      "type": "login",
      "email": email,
      "password": password,
    });

    var response = await http.post(_url, body: {"data": json});
    // Decode json
    if (response.body.isNotEmpty) {
      Map decodedResponse = jsonDecode(response.body);

      // Check if an error occured and return it
      if (decodedResponse.containsKey("error")) {
        return decodedResponse["error"];
      }
      // Otherwise set the logged user in the application
      User.loggedUser = User.fromJson(decodedResponse);
    }

    return null;
  }

  static Future<String> checkMail(String email) async {
    var json = jsonEncode({
      "type": "check-email",
      "email": email,
    });

    var response = await http.post(_url, body: {"data": json});
    return _decodeJson(response);
  }

  static Future leaveRestaurant(Restaurant restaurant) async {
    var json = jsonEncode({
      "type": "leave-restaurant",
      "user": User.loggedUser.id,
      "restaurant": restaurant.id,
    });

    await http.post(_url, body: {"data": json});
  }

  static User fromJson(Map json) {
    User user = User();
    user._id = json['id'];
    user._firstName = json['firstName'];
    user._lastName = json['lastName'];
    user._email = json['email'];

    return user;
  }
}

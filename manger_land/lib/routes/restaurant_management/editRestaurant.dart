import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:manger_land/models/restaurant.dart';
import 'package:manger_land/widgets/AppBar.dart';
import 'package:manger_land/widgets/RestaurantForm.dart';

class EditRestaurantRoute extends StatefulWidget {
  final Restaurant restaurant;

  EditRestaurantRoute(this.restaurant);

  @override
  _EditRestaurantRouteState createState() =>
      _EditRestaurantRouteState(restaurant);
}

class _EditRestaurantRouteState extends State<EditRestaurantRoute> {
  final Restaurant restaurant;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  _EditRestaurantRouteState(this.restaurant) {
    nameController.text = restaurant.name;
    addressController.text = restaurant.address;
  }

  void _editRestaurant(Uint8List image) async {
    await Restaurant.editRestaurant(
        restaurant, nameController.text, addressController.text, image);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Modifier un restaurant"),
      body: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(36.0, 15.0, 36.0, 15.0),
          child: RestaurantForm(
            nameController,
            addressController,
            _editRestaurant,
            image: restaurant.image,
            buttonLabel: "Modifier",
          ),
        ),
      ),
    );
  }
}

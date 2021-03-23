import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:manger_land/models/restaurant.dart';
import 'package:manger_land/widgets/AppBar.dart';
import 'package:manger_land/widgets/RestaurantForm.dart';

class AddRestaurantRoute extends StatefulWidget {
  @override
  _AddRestaurantRouteState createState() => _AddRestaurantRouteState();
}

class _AddRestaurantRouteState extends State<AddRestaurantRoute> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  void _addRestaurant(Uint8List image) async {
    await Restaurant.addRestaurant(
        _nameController.text, _addressController.text, image);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Ajouter un restaurant"),
      body: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(36.0, 15.0, 36.0, 15.0),
          child: RestaurantForm(
              _nameController, _addressController, _addRestaurant),
        ),
      ),
    );
  }
}

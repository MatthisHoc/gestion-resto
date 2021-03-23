import 'package:flutter/material.dart';
import 'package:manger_land/models/restaurant.dart';
import 'package:manger_land/models/user.dart';
import 'package:manger_land/routes/restaurant_management/editRestaurant.dart';
import 'package:manger_land/routes/restaurant_management/manageFoods.dart';
import 'package:manger_land/routes/restaurant_management/manageMenus.dart';
import 'package:manger_land/routes/restaurant_management/manageStaff.dart';
import 'package:manger_land/routes/restaurant_management/manageFoodTypes.dart';
import 'package:manger_land/routes/restaurant_management/viewOrders.dart';
import 'package:manger_land/widgets/AppBar.dart';

class ManageRestaurantRoute extends StatefulWidget {
  final Restaurant _restaurant;
  final bool isOwner;

  ManageRestaurantRoute(this._restaurant, this.isOwner);

  @override
  _ManageRestaurantRouteState createState() =>
      _ManageRestaurantRouteState(_restaurant, isOwner);
}

class _ManageRestaurantRouteState extends State<ManageRestaurantRoute> {
  final Restaurant _restaurant;
  final bool isOwner;
  _ManageRestaurantRouteState(this._restaurant, this.isOwner);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("Gestion restaurant"),
      body: GridView.count(
        padding: EdgeInsets.all(20.0),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[
          RestaurantManagementTile(Icons.shopping_cart_outlined, "Commandes",
              () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ViewOrdersRoute(_restaurant)));
          }),
          if (isOwner)
            RestaurantManagementTile(Icons.person_outlined, "Personnel", () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ManageStaffRoute(_restaurant)));
            }),
          if (isOwner)
            RestaurantManagementTile(Icons.edit_outlined, "Modifier", () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditRestaurantRoute(_restaurant)));
            }),
          if (isOwner)
            RestaurantManagementTile(Icons.label_outlined, "Types d'aliments",
                () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ManageFoodTypesRoute(_restaurant)));
            }),
          if (isOwner)
            RestaurantManagementTile(Icons.food_bank_outlined, "Aliments", () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ManageFoodRoute(_restaurant)));
            }),
          if (isOwner)
            RestaurantManagementTile(Icons.shopping_basket_outlined, "Menus",
                () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ManageMenuRoute(_restaurant)));
            }),
          if (isOwner)
            RestaurantManagementTile(Icons.delete_forever_outlined, "Supprimer",
                () async {
              await Restaurant.delete(_restaurant);
              Navigator.pop(context);
            }, Colors.red[400]),
          if (!isOwner)
            RestaurantManagementTile(Icons.exit_to_app_outlined, "Quitter",
                () async {
              await User.leaveRestaurant(_restaurant);
              Navigator.pop(context);
            }, Colors.red[400]),
        ],
      ),
    );
  }
}

class RestaurantManagementTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final void Function() onPressed;

  RestaurantManagementTile(this.icon, this.label, this.onPressed, [Color color])
      : this.color = (color == null) ? Colors.teal[400] : color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.0,
      width: 75.0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            width: 3,
            color: color,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: FlatButton(
          onPressed: onPressed,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 40.0,
              ),
              SizedBox(height: 20.0),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

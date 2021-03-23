import 'package:flutter/material.dart';
import 'package:manger_land/widgets/AppBar.dart';
import 'package:manger_land/models/order.dart';
import 'package:manger_land/widgets/priceFormat.dart';
import 'package:manger_land/routes/restaurant.dart';

class OrdersRoute extends StatefulWidget {
  @override
  _OrdersRouteState createState() => _OrdersRouteState();
}

class _OrdersRouteState extends State<OrdersRoute> {
  List<Order> _orders = List<Order>();
  @override
  Widget build(BuildContext context) {
    if (_orders.isEmpty) {
      Order.getUserOrders().then((value) {
        setState(() {
          _orders = value.reversed.toList();
        });
      });
    }
    return Scaffold(
      appBar: CustomAppBar("Mes commandes"),
      body: Container(
        child: ListView.builder(
          itemCount: _orders.length,
          itemBuilder: (context, i) {
            return FlatButton(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        RestaurantRoute(_orders[i].restaurant),
                  ),
                );
                setState(() {
                  _orders = List<Order>();
                });
              },
              child: ListTile(
                title: Text(
                  _orders[i].restaurant.name,
                  style: TextStyle(fontSize: 25.0),
                ),
                isThreeLine: true,
                subtitle: Text(
                  _orders[i].date + "\n" + _orders[i].state,
                  style: TextStyle(fontSize: 20.0),
                ),
                trailing: Text(
                  PriceFormat.format(_orders[i].price) + "€",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

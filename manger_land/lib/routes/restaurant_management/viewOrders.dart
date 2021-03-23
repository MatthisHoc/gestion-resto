import 'package:flutter/material.dart';
import 'package:manger_land/models/order.dart';
import 'package:manger_land/models/restaurant.dart';
import 'package:manger_land/widgets/AppBar.dart';
import 'package:manger_land/widgets/priceFormat.dart';

class EditOrderDialog extends StatefulWidget {
  final Restaurant restaurant;
  final Order order;

  EditOrderDialog(this.restaurant, this.order);

  @override
  _EditOrderDialogState createState() =>
      _EditOrderDialogState(restaurant, order);
}

class _EditOrderDialogState extends State<EditOrderDialog> {
  final Restaurant restaurant;
  final Order order;
  final _formKey = GlobalKey<FormState>();
  String _selectedState = "";
  String _errorMessage = "";
  List<String> _orderStates = List<String>();

  _EditOrderDialogState(this.restaurant, this.order);

  void _validateForm() async {
    if (_formKey.currentState.validate()) {
      Order.setState(order, _selectedState).then((value) {
        Navigator.of(context, rootNavigator: true).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_orderStates.isEmpty) {
      Order.getOrderStates().then((value) {
        setState(() {
          _orderStates = value;
        });
      });
    }

    return Dialog(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Container(
        height: 250.0,
        width: 250.0,
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DropdownButtonFormField<String>(
                validator: (value) {
                  if (value == null) {
                    return "Vous devez selectionner un état";
                  }
                  return null;
                },
                hint: Text("Choisissez un état"),
                items: _orderStates
                    .map((e) =>
                        DropdownMenuItem<String>(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedState = value;
                  });
                },
              ),
              SizedBox(height: 20.0),
              Text(
                _errorMessage,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.0,
                ),
              ),
              SizedBox(height: 20.0),
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.teal[400],
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: _validateForm,
                  child: Text(
                    "Modifier",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ViewOrdersRoute extends StatefulWidget {
  final Restaurant restaurant;

  ViewOrdersRoute(this.restaurant);

  @override
  _ViewOrdersRouteState createState() => _ViewOrdersRouteState(restaurant);
}

class _ViewOrdersRouteState extends State<ViewOrdersRoute> {
  final Restaurant restaurant;
  List<Order> _orders;

  _ViewOrdersRouteState(this.restaurant);

  @override
  Widget build(BuildContext context) {
    if (_orders == null) {
      Order.getAll(restaurant).then((value) {
        setState(() {
          _orders = value;
        });
      });
    }

    return Scaffold(
      appBar: CustomAppBar("Gérer les commandes"),
      body: Center(
        child: (_orders == null || _orders.isEmpty)
            ? Text(
                "Vous n'avez pas encore de commandes",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              )
            : ListView.separated(
                itemBuilder: (context, i) {
                  var order = _orders[i];
                  return ListTile(
                    title: Text(
                      order.date,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    isThreeLine: true,
                    subtitle: Text(
                      PriceFormat.format(order.price) + "€\n" + order.state,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    trailing: FlatButton(
                      shape: CircleBorder(),
                      child: Icon(
                        Icons.edit,
                        color: Colors.teal[400],
                        size: 30.0,
                      ),
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (context) =>
                                EditOrderDialog(restaurant, order));
                        setState(() {
                          _orders = null;
                        });
                      },
                    ),
                  );
                },
                separatorBuilder: (context, i) {
                  return Divider();
                },
                itemCount: _orders.length),
      ),
    );
  }
}

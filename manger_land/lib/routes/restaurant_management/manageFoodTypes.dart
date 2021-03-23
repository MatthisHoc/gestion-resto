import 'package:flutter/material.dart';
import 'package:manger_land/models/restaurant.dart';
import 'package:manger_land/widgets/AppBar.dart';
import 'package:tuple/tuple.dart';

class AddFoodTypeDialog extends StatefulWidget {
  final Restaurant restaurant;

  AddFoodTypeDialog(this.restaurant);

  @override
  _AddFoodTypeDialogState createState() => _AddFoodTypeDialogState(restaurant);
}

class _AddFoodTypeDialogState extends State<AddFoodTypeDialog> {
  final Restaurant restaurant;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _errorMessage = "";

  _AddFoodTypeDialogState(this.restaurant);

  void _validateForm() async {
    if (_formKey.currentState.validate()) {
      Restaurant.addFoodType(restaurant, _nameController.text).then((value) {
        Navigator.of(context, rootNavigator: true).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              TextFormField(
                obscureText: false,
                controller: _nameController,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Vous devez renseigner un type";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "Type",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35.0)),
                ),
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
                    "Ajouter",
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

class ManageFoodTypesRoute extends StatefulWidget {
  final Restaurant restaurant;

  ManageFoodTypesRoute(this.restaurant);

  @override
  _ManageFoodTypesRouteState createState() =>
      _ManageFoodTypesRouteState(restaurant);
}

class _ManageFoodTypesRouteState extends State<ManageFoodTypesRoute> {
  final Restaurant restaurant;
  List<Tuple2<int, String>> _foodTypes;

  _ManageFoodTypesRouteState(this.restaurant);

  @override
  Widget build(BuildContext context) {
    if (_foodTypes == null) {
      _foodTypes = restaurant.foodTypes;
    }

    return Scaffold(
      appBar: CustomAppBar("Gérer les types"),
      body: Center(
        child: (_foodTypes == null || _foodTypes.isEmpty)
            ? Text(
                "Vous n'avez pas encore de types d'aliments",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              )
            : ListView.separated(
                itemBuilder: (context, i) {
                  var foodType = _foodTypes[i];
                  return ListTile(
                    title: Text(
                      foodType.item2,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    trailing: FlatButton(
                      shape: CircleBorder(),
                      child: Icon(Icons.delete,
                          color: Colors.red[400], size: 30.0),
                      onPressed: () async {
                        await Restaurant.deleteFoodType(restaurant, foodType);
                        setState(() {
                          _foodTypes = null;
                        });
                      },
                    ),
                  );
                },
                separatorBuilder: (context, i) {
                  return Divider();
                },
                itemCount: _foodTypes.length),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal[400],
          child: Icon(Icons.add),
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (context) {
                return AddFoodTypeDialog(restaurant);
              },
            );
            setState(() {
              _foodTypes = null;
            });
          }),
    );
  }
}

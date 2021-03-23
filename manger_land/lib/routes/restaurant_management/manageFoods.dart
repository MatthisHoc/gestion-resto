import 'package:flutter/material.dart';
import 'package:manger_land/models/food.dart';
import 'package:manger_land/models/restaurant.dart';
import 'package:manger_land/widgets/AppBar.dart';
import 'package:manger_land/widgets/priceFormat.dart';
import 'package:tuple/tuple.dart';

class AddFoodDialog extends StatefulWidget {
  final Restaurant restaurant;

  AddFoodDialog(this.restaurant);

  @override
  _AddFoodDialogState createState() => _AddFoodDialogState(restaurant);
}

class _AddFoodDialogState extends State<AddFoodDialog> {
  final Restaurant restaurant;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  Tuple2<int, String> _selectedType = Tuple2<int, String>(-1, "");
  String _errorMessage = "";

  _AddFoodDialogState(this.restaurant);

  void _validateForm() async {
    if (_formKey.currentState.validate()) {
      Food.add(restaurant, _nameController.text,
              double.parse(_priceController.text), _selectedType.item1)
          .then((value) {
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
        height: 450.0,
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
                    return "Vous devez renseigner un nom";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "Nom",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35.0)),
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                obscureText: false,
                controller: _priceController,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Vous devez renseigner un prix";
                  }
                  if (double.tryParse(value) == null) {
                    return "Le prix renseigné n'est pas valide";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "Prix",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35.0)),
                ),
              ),
              SizedBox(height: 20.0),
              DropdownButtonFormField<Tuple2<int, String>>(
                  validator: (value) {
                    if (value == null) {
                      return "Vous devez selectionner un type d'aliment";
                    }
                    return null;
                  },
                  hint: Text("Choisissez un type"),
                  items: restaurant.foodTypes
                      .map((e) => DropdownMenuItem<Tuple2<int, String>>(
                          value: e, child: Text(e.item2)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  }),
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

class ManageFoodRoute extends StatefulWidget {
  final Restaurant restaurant;

  ManageFoodRoute(this.restaurant);

  @override
  _ManageFoodRouteState createState() => _ManageFoodRouteState(restaurant);
}

class _ManageFoodRouteState extends State<ManageFoodRoute> {
  final Restaurant restaurant;
  List<Food> _foods;

  _ManageFoodRouteState(this.restaurant);

  @override
  Widget build(BuildContext context) {
    if (_foods == null) {
      Food.getAll(restaurant).then((value) {
        setState(() {
          _foods = value;
        });
      });
    }

    return Scaffold(
      appBar: CustomAppBar("Gérer les aliments"),
      body: Center(
        child: (_foods == null || _foods.isEmpty)
            ? Text(
                "Vous n'avez pas encore d'aliments",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              )
            : ListView.separated(
                itemBuilder: (context, i) {
                  var food = _foods[i];
                  return ListTile(
                    title: Text(
                      food.name,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    subtitle: Text(
                      PriceFormat.format(food.price) + "€",
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
                        await Food.delete(food).then((value) {
                          setState(() {
                            _foods = null;
                          });
                        });
                      },
                    ),
                  );
                },
                separatorBuilder: (context, i) {
                  return Divider();
                },
                itemCount: _foods.length),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal[400],
          child: Icon(Icons.add),
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (context) {
                return AddFoodDialog(restaurant);
              },
            );
            setState(() {
              _foods = null;
            });
          }),
    );
  }
}

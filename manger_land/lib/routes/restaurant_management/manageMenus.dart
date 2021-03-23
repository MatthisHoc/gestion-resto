import 'package:flutter/material.dart';
import 'package:manger_land/models/food.dart';
import 'package:manger_land/models/menu.dart';
import 'package:manger_land/models/restaurant.dart';
import 'package:manger_land/widgets/AppBar.dart';
import 'package:manger_land/widgets/priceFormat.dart';

class AddMenuDialog extends StatefulWidget {
  final Restaurant restaurant;
  final List<Food> foods;

  AddMenuDialog(this.restaurant, this.foods);

  @override
  _AddMenuDialogState createState() => _AddMenuDialogState(restaurant, foods);
}

class _AddMenuDialogState extends State<AddMenuDialog> {
  final Restaurant restaurant;
  final List<Food> foods;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final Set<int> _selectedFoods = Set<int>();
  String _errorMessage = "";

  _AddMenuDialogState(this.restaurant, this.foods);

  void _validateForm() async {
    if (_formKey.currentState.validate()) {
      List<Food> selectedFoods = List<Food>();
      _selectedFoods.forEach((element) {
        selectedFoods.add(foods[element]);
      });
      Menu.addMenu(restaurant, selectedFoods, _nameController.text,
              double.parse(_priceController.text))
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
              Expanded(
                child: ListView.builder(
                  itemCount: foods.length,
                  itemBuilder: (context, i) {
                    return FlatButton(
                      onPressed: () {
                        if (_selectedFoods.contains(i)) {
                          setState(() {
                            _selectedFoods.remove(i);
                          });
                        } else {
                          setState(() {
                            _selectedFoods.add(i);
                          });
                        }
                      },
                      child: ListTile(
                        title: Text(
                          foods[i].name,
                          style: TextStyle(
                            color: (_selectedFoods.contains(i))
                                ? Colors.teal[400]
                                : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
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

class ManageMenuRoute extends StatefulWidget {
  final Restaurant restaurant;

  ManageMenuRoute(this.restaurant);

  @override
  _ManageMenuRouteState createState() => _ManageMenuRouteState(restaurant);
}

class _ManageMenuRouteState extends State<ManageMenuRoute> {
  final Restaurant restaurant;
  List<Food> _foods;
  List<Menu> _menus;

  _ManageMenuRouteState(this.restaurant);

  @override
  Widget build(BuildContext context) {
    if (_menus == null) {
      Food.getAll(restaurant).then((value) {
        setState(() {
          _foods = value;
        });
        Menu.getAll(restaurant, value).then((menus) {
          setState(() {
            _menus = menus;
          });
        });
      });
    }

    return Scaffold(
      appBar: CustomAppBar("Gérer les menus"),
      body: Center(
        child: (_menus == null || _menus.isEmpty)
            ? Text(
                "Vous n'avez pas encore de menus",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              )
            : ListView.separated(
                itemBuilder: (context, i) {
                  var menu = _menus[i];
                  return ListTile(
                    title: Text(
                      menu.name,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    subtitle: Text(
                      PriceFormat.format(menu.price) + "€",
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
                        Menu.delete(menu).then((value) {
                          setState(() {
                            _menus = null;
                          });
                        });
                      },
                    ),
                  );
                },
                separatorBuilder: (context, i) {
                  return Divider();
                },
                itemCount: _menus.length),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal[400],
          child: Icon(Icons.add),
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (context) {
                return AddMenuDialog(restaurant, _foods);
              },
            );
            setState(() {
              _menus = null;
            });
          }),
    );
  }
}

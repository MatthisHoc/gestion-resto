import 'package:flutter/material.dart';
import 'package:manger_land/models/restaurant.dart';
import 'package:manger_land/models/user.dart';
import 'package:manger_land/widgets/AppBar.dart';

class AddStaffDialog extends StatefulWidget {
  final Restaurant restaurant;

  AddStaffDialog(this.restaurant);

  @override
  _AddStaffDialogState createState() => _AddStaffDialogState(restaurant);
}

class _AddStaffDialogState extends State<AddStaffDialog> {
  final Restaurant restaurant;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String _errorMessage = "";

  _AddStaffDialogState(this.restaurant);

  void _validateForm() async {
    if (_formKey.currentState.validate()) {
      User.checkMail(_emailController.text).then((value) {
        if (value == null) {
          setState(() {
            _errorMessage = "L'adresse e-mail n'existe pas";
          });
        } else {
          Restaurant.addEmployee(restaurant, _emailController.text)
              .then((value) {
            Navigator.of(context, rootNavigator: true).pop();
          });
        }
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
                controller: _emailController,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Vous devez renseigner une adresse e-mail";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "Email",
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

class ManageStaffRoute extends StatefulWidget {
  final Restaurant restaurant;

  ManageStaffRoute(this.restaurant);

  @override
  _ManageStaffRouteState createState() => _ManageStaffRouteState(restaurant);
}

class _ManageStaffRouteState extends State<ManageStaffRoute> {
  final Restaurant restaurant;
  List<User> _employees;

  _ManageStaffRouteState(this.restaurant);

  @override
  Widget build(BuildContext context) {
    if (_employees == null) {
      Restaurant.getEmployees(restaurant).then((value) {
        if (this.mounted) {
          setState(() {
            _employees = value;
          });
        }
      });
    }

    return Scaffold(
      appBar: CustomAppBar("Gérer le personnel"),
      body: Center(
        child: (_employees == null || _employees.isEmpty)
            ? Text(
                "Vous n'avez pas encore d'employés dans votre restaurant",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              )
            : ListView.separated(
                itemBuilder: (context, i) {
                  var employee = _employees[i];
                  return ListTile(
                    title: Text(
                      employee.firstName + " " + employee.lastName,
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
                        await Restaurant.deleteEmployee(restaurant, employee);
                        setState(() {
                          _employees = null;
                        });
                      },
                    ),
                  );
                },
                separatorBuilder: (context, i) {
                  return Divider();
                },
                itemCount: _employees.length),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal[400],
          child: Icon(Icons.add),
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (context) {
                return AddStaffDialog(restaurant);
              },
            );
            setState(() {
              _employees = null;
            });
          }),
    );
  }
}

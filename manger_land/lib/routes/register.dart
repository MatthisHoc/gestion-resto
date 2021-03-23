import 'package:flutter/material.dart';
import 'package:manger_land/widgets/AppBar.dart';
import 'package:manger_land/models/user.dart';

class RegisterRoute extends StatefulWidget {
  @override
  _RegisterRouteState createState() => _RegisterRouteState();
}

class _RegisterRouteState extends State<RegisterRoute> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = "";

  void _validateForm() {
    if (_formKey.currentState.validate()) {
      User.checkMail(_emailController.text).then((value) {
        if (value != null) {
          setState(() {
            _errorMessage = "L'adresse e-mail existe deja";
          });
        } else {
          User.register(_nameController.text, _firstNameController.text,
                  _emailController.text, _passwordController.text)
              .then((value) {
            Navigator.pop(context);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _nameField = TextFormField(
      obscureText: false,
      controller: _nameController,
      validator: (value) {
        if (value.isEmpty) {
          return "Nom vide";
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Nom",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(35.0)),
      ),
    );

    final _firstNameField = TextFormField(
      obscureText: false,
      controller: _firstNameController,
      validator: (value) {
        if (value.isEmpty) {
          return "Prenom vide";
        }

        return null;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Prenom",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(35.0))),
    );

    final _emailField = TextFormField(
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
          hintText: "E-mail",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(35.0))),
    );

    final _passwordField = TextFormField(
      obscureText: true,
      controller: _passwordController,
      validator: (value) {
        if (value.isEmpty) {
          return "Vous devez renseigner un mot de passe";
        }

        return null;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Mot de passe",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(35.0))),
    );

    final _errorText = Text(
      _errorMessage,
      style: TextStyle(
        color: Colors.red,
        fontSize: 14.0,
      ),
    );

    final _registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.teal[400],
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: _validateForm,
        child: Text(
          "S'inscrire",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: CustomAppBar("Inscription"),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.fromLTRB(36.0, 15.0, 36.0, 15.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(child: _nameField),
                      SizedBox(width: 20.0),
                      Flexible(child: _firstNameField),
                    ],
                  ),
                  SizedBox(height: 25.0),
                  _emailField,
                  SizedBox(height: 25.0),
                  _passwordField,
                  SizedBox(height: 20.0),
                  _errorText,
                  SizedBox(height: 20.0),
                  _registerButton,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

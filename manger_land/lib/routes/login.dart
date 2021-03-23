import 'package:flutter/material.dart';
import 'package:manger_land/routes/home.dart';
import 'package:manger_land/models/user.dart';
import 'register.dart';

class LoginRoute extends StatefulWidget {
  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = "";

  void _validateForm() {
    if (_formKey.currentState.validate()) {
      User.login(_emailController.text.toString(),
              _passwordController.text.toString())
          .then((value) {
        if (value != null) {
          setState(() {
            _errorMessage = "Adresse e-mail ou mot de passe incorrect";
          });
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomeRoute(),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle errorStyle = TextStyle(
      fontSize: 16.0,
      color: Colors.red,
    );

    // Fields
    final emailField = TextFormField(
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
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextFormField(
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
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.teal[400],
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: _validateForm,
        child: Text(
          "Se connecter",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );

    final errorMessage = Text(_errorMessage, style: errorStyle);

    final registerText = GestureDetector(
      child: Text(
        "S'inscrire",
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
          fontSize: 20.0,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterRoute()),
        );
      },
    );

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 45.0),
                  emailField,
                  SizedBox(height: 45.0),
                  passwordField,
                  SizedBox(height: 45.0),
                  loginButton,
                  SizedBox(height: 25.0),
                  registerText,
                  SizedBox(height: 25.0),
                  errorMessage,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

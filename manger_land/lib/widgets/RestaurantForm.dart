import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RestaurantForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController addressController;
  final Uint8List image;
  final String buttonLabel;
  final void Function(Uint8List image) validationCallback;

  RestaurantForm(
      this.nameController, this.addressController, this.validationCallback,
      {Uint8List image, String buttonLabel = "Créer"})
      : this.image = image,
        this.buttonLabel = buttonLabel;

  @override
  _RestaurantFormState createState() => _RestaurantFormState(
      nameController, addressController, validationCallback,
      image: image, buttonLabel: buttonLabel);
}

class _RestaurantFormState extends State<RestaurantForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController;
  final TextEditingController addressController;
  final void Function(Uint8List image) validationCallback;
  Uint8List _image;
  String _errorMessage = "";
  final String _buttonLabel;

  _RestaurantFormState(
      this.nameController, this.addressController, this.validationCallback,
      {Uint8List image, String buttonLabel})
      : this._image = image,
        this._buttonLabel = buttonLabel;

  void _validateForm() async {
    if (_formKey.currentState.validate()) {
      if (_image == null) {
        setState(() {
          _errorMessage = "Vous devez ajouter une photo";
        });
      } else {
        validationCallback(_image);
      }
    }
  }

  Future _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path).readAsBytesSync();
      } else {
        _image = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _errorText = Text(
      _errorMessage,
      style: TextStyle(
        color: Colors.red,
        fontSize: 14.0,
      ),
    );

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            obscureText: false,
            controller: nameController,
            validator: (value) {
              if (value.isEmpty) {
                return "Vous devez renseigner un nom";
              }

              return null;
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Nom",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(35.0)),
            ),
          ),
          SizedBox(height: 25.0),
          TextFormField(
            obscureText: false,
            controller: addressController,
            validator: (value) {
              if (value.isEmpty) {
                return "Vous devez renseigner une adresse";
              }

              return null;
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Adresse",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(35.0)),
            ),
          ),
          SizedBox(height: 25.0),
          FlatButton(
            color: Colors.teal[400],
            minWidth: MediaQuery.of(context).size.width / 4.0,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: _pickImage,
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
            shape: CircleBorder(
              side: BorderSide(width: 0.0, color: Colors.transparent),
            ),
          ),
          SizedBox(height: 20.0),
          _errorText,
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
                _buttonLabel,
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
    );
  }
}

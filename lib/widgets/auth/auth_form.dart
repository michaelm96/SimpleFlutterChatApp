import 'dart:io';

import '../pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class Authform extends StatefulWidget {
  final Function submitForm;
  final bool isLoading;

  Authform(this.submitForm, this.isLoading);
  @override
  _AuthformState createState() => _AuthformState();
}

class _AuthformState extends State<Authform> {
  final _formKey = GlobalKey<FormState>();
  // cause every form need key
  var _isLogin = false;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File _pickedImage;

  void _setPickedImage(File image) {
    _pickedImage = image;
  }

  void _trySubmit(BuildContext ctx) {
    final isValid = _formKey.currentState.validate();
    //Method to run validate in every TextformField
    FocusScope.of(context).unfocus();
    //Close the keyboard

    print('------>>>  $_pickedImage  <<<------');

    if (_pickedImage == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please insert an image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitForm(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _pickedImage,
        _isLogin,
        ctx,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // take as little space as needed
                children: [
                  Text(
                    'Flutter Chat',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _isLogin
                      ? Text(
                          'Login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : Text(
                          'Register',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  if (!_isLogin) UserImagePicker(_setPickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                    ),
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      // needed to differentiate value cause flutter can't tell the difference between TextFormField(s)
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value.isEmpty || value.length < 6) {
                          return 'Please enter at least 6 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    // to hide the input
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  widget.isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : RaisedButton(
                          child: Text(_isLogin ? 'Login' : 'Register'),
                          onPressed: () {
                            _trySubmit(context);
                          },
                        ),
                  if (!widget.isLoading)
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'),
                      textColor: Theme.of(context).primaryColor,
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

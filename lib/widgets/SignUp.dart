import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../Styles.dart';
import '../models/User.dart';
import '../services/authentication.dart';
import '../widgets/DailogBox.dart';
import 'CustomButton.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

enum SignUpMethods { email, google, facebook }
enum TypeOfUser { customer, seller }

class _SignUpFormState extends State<SignUpForm> {
  TypeOfUser _userType = TypeOfUser.customer;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false, _showPassword = false;
  String _username, _email, _password;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      // autovalidate: _autovalidate,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Stack(overflow: Overflow.visible, children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          enabled: !isLoading,
                          style: TextStyle(fontSize: 20),
                          keyboardType: TextInputType.text,
                          validator: (value) =>
                              value.isEmpty ? "enter username" : null,
                          onSaved: (value) => _username = value,
                          decoration: InputDecoration(
                              labelText: 'Username',
                              labelStyle: TextStyle(color: MyColors.primary),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              prefixIcon:
                                  Icon(Icons.person, color: MyColors.primary)),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          enabled: !isLoading,
                          style: TextStyle(fontSize: 20),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => _validateEmail(value.trim()),
                          onSaved: (value) => _email = value.trim(),
                          decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: MyColors.primary),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              prefixIcon:
                                  Icon(Icons.mail, color: MyColors.primary)),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          enabled: !isLoading,
                          style: TextStyle(fontSize: 20),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value.isEmpty)
                              return 'Enter Password';
                            else if (value.length < 6)
                              return 'Minimum 6 characters required';
                            else
                              return null;
                          },
                          onChanged: (value) =>
                              setState(() => _password = value),
                          obscureText: !_showPassword,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: MyColors.primary),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              prefixIcon:
                                  Icon(Icons.lock, color: MyColors.primary),
                              suffixIcon: _password != null && _password != ''
                                  ? GestureDetector(
                                      child: Icon(_showPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                      onTap: () => setState(
                                          () => _showPassword = !_showPassword))
                                  : null),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            Radio(
                              value: TypeOfUser.customer,
                              groupValue: _userType,
                              onChanged: (value) {
                                setState(() {
                                  _userType = value;
                                });
                              },
                            ),
                            Text('Customer'),
                            Radio(
                              value: TypeOfUser.seller,
                              groupValue: _userType,
                              onChanged: (value) {
                                setState(() {
                                  _userType = value;
                                });
                              },
                            ),
                            Text('Seller'),
                          ],
                        ),
                        SizedBox(height: 70),
                      ],
                    ),
                  ),
                ),
              ),
              if (!isLoading)
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 90.0),
                    child: Row(
                      children: <Widget>[
                        MyButton(
                          text: 'Sign Up',
                          action: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              handleSignUp(SignUpMethods.email);
                            }
                            // else
                            // setState(() => _autovalidate = true);
                          },
                        )
                      ],
                    ),
                  ),
                ),
            ]),
            SizedBox(height: 10),
            isLoading
                ? Column(
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text('Creating your account...',
                          style: MyTextStyles.label)
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 90),
                    child: Row(
                      children: <Widget>[
                        if (_userType == TypeOfUser.customer)
                          MyButton(
                              // text: 'Facebook',
                              textColor: Colors.white,
                              buttonColor: Colors.indigo,
                              icon: FontAwesome.facebook,
                              action: () =>
                                  handleSignUp(SignUpMethods.facebook)),
                        SizedBox(width: 10),
                        MyButton(
                            // text: 'Google',
                            textColor: Colors.white,
                            buttonColor: Colors.deepOrange,
                            icon: FontAwesome.google,
                            action: () => handleSignUp(SignUpMethods.google))
                      ],
                    ),
                  )
          ]),
        ),
      ),
    );
  }

  void handleSignUp(SignUpMethods method) async {
    Map result;
    switch (method) {
      case SignUpMethods.email:
        FocusScope.of(context).unfocus();
        setState(() => isLoading = true);
        result = await AuthService().signUp('email', 'customer',
            user: User(
                email: _email,
                password: _password,
                username: _username,
                userType: _userType));
        setState(() => isLoading = false);
        displayMessage(result);
        break;
      case SignUpMethods.google:
        FocusScope.of(context).unfocus();
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => Center(child: CircularProgressIndicator()));
        result = await AuthService()
            .signUp('google', 'customer', user: User(userType: _userType));
        Navigator.of(context, rootNavigator: true).pop();
        displayMessage(result);
        break;
      case SignUpMethods.facebook:
        FocusScope.of(context).unfocus();
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => Center(child: CircularProgressIndicator()));
        result = await AuthService()
            .signUp('facebook', 'customer', user: User(userType: _userType));
        Navigator.of(context, rootNavigator: true).pop();
        displayMessage(result);
        break;
      default:
    }
  }

  void displayMessage(Map result) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => DialogBox(
              title: result['success'] ? 'Done' : 'Error :(',
              description:
                  result['success'] ? "Sign-Up Successful" : result['msg'],
              buttonText1: result['success'] ? 'Continue' : 'Ok',
              button1Func: () {
                Navigator.of(context, rootNavigator: true).pop();
                if (result['success'])
                  Navigator.pushReplacementNamed(context, '/phone_verification',
                      arguments: {
                        'email': result['user'].email,
                        'creds': result['creds'],
                        'password': result['password'],
                        'type': result['type'],
                      });
              },
            ));
  }

  String _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }
}

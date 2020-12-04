import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:smackit/Styles.dart';
import '../services/authentication.dart';
import '../widgets/DailogBox.dart';
import 'CustomButton.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

enum SignInMethods { email, google, facebook }

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _autovalidate = false, isLoading = false, _showPassword = false;
  String _email, _password;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      // autovalidate: _autovalidate,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _emailController,
                              enabled: !isLoading,
                              autocorrect: false,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Roboto',
                                  letterSpacing: 1),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) =>
                                  _validateEmail(value.trim()),
                              onSaved: (value) => _email = value.trim(),
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle:
                                      TextStyle(color: MyColors.primary),
                                  hintText: 'Your Email',
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  prefixIcon: Icon(Icons.mail,
                                      color: MyColors.primary)),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              enabled: !isLoading,
                              autocorrect: false,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Roboto',
                                  letterSpacing: 1),
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
                                  labelStyle:
                                      TextStyle(color: MyColors.primary),
                                  hintText: 'Your Password',
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  prefixIcon:
                                      Icon(Icons.lock, color: MyColors.primary),
                                  suffixIcon: _password != null &&
                                          _password != ''
                                      ? GestureDetector(
                                          child: Icon(
                                              _showPassword
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: MyColors.primary),
                                          onTap: () => setState(() =>
                                              _showPassword = !_showPassword))
                                      : null),
                            ),
                            SizedBox(height: 30),
                            if (!isLoading)
                              Container(
                                margin: const EdgeInsets.only(bottom: 50),
                                child: GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      Navigator.pushNamed(context, '/forgot',
                                          arguments: _emailController.text);
                                    },
                                    child: Text("FORGOT PASSWORD ?",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 2,
                                            color: Theme.of(context)
                                                .accentColor))),
                              ),
                            SizedBox(height: 20),
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
                        padding: const EdgeInsets.symmetric(horizontal: 90),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            MyButton(
                                text: 'Sign In',
                                action: () => handleSignIn(SignInMethods.email))
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 10),
              isLoading
                  ? Column(
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text('Signing you in...', style: MyTextStyles.label)
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 90.0),
                      child: Row(
                        children: <Widget>[
                          MyButton(
                              // text: 'Facebook',
                              textColor: Colors.white,
                              buttonColor: Colors.indigo,
                              icon: FontAwesome.facebook,
                              action: () =>
                                  handleSignIn(SignInMethods.facebook)),
                          SizedBox(width: 10),
                          MyButton(
                              // text: 'Google',
                              textColor: Colors.white,
                              buttonColor: Colors.deepOrange,
                              icon: FontAwesome.google,
                              action: () => handleSignIn(SignInMethods.google)),
                        ],
                      ),
                    ),
              // SizedBox(height: 10),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 90.0),
              //   child: Row(
              //     children: <Widget>[],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  void handleSignIn(SignInMethods method) async {
    Map result;
    switch (method) {
      case SignInMethods.email:
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          FocusScope.of(context).unfocus();
          setState(() => isLoading = true);
          result = await AuthService().signIn(_email, _password, 'customer');
          setState(() => isLoading = false);
          signIn(result);
        } else
          setState(() => _autovalidate = true);
        break;
      case SignInMethods.google:
        FocusScope.of(context).unfocus();
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => Center(child: CircularProgressIndicator()));
        result = await AuthService().googleSignIn();
        Navigator.of(context, rootNavigator: true).pop();
        signIn(result);
        break;
      case SignInMethods.facebook:
        FocusScope.of(context).unfocus();
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => Center(child: CircularProgressIndicator()));
        result = await AuthService().facebookSignIn();
        Navigator.of(context, rootNavigator: true).pop();
        signIn(result);
        break;
      default:
    }
  }

  void signIn(Map result) async {
    if (result['success']) {
      showDialog(
          context: context,
          builder: (_) => DialogBox(
                title: 'Success',
                description: "Signed in Successfully",
                buttonText1: null,
                button1Func: null,
                icon: Icons.check_circle,
                iconColor: Colors.teal,
              ));
      await Future.delayed(Duration(seconds: 2));
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pushReplacementNamed(context, '/main',
          arguments: result['user']);
    } else
      showDialog(
          context: context,
          builder: (_) => DialogBox(
                title: 'Error :(',
                description: result['msg'],
                buttonText1: 'Ok',
                button1Func: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smackit/Styles.dart';
import 'package:smackit/LoginRegister/ForgotPassword.dart';
import 'package:smackit/screens/HomePage.dart';
import 'package:smackit/services/authentication.dart';

class SellerLogin extends StatefulWidget {
  @override
  _SellerLoginState createState() => _SellerLoginState();
}

class _SellerLoginState extends State<SellerLogin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showPass = true;
  bool _autoValidate = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  _checkIfUserExists() async {
    final user = await FirebaseFirestore.instance
        .collection('seller')
        .where('email', isEqualTo: _emailController.text.trim().toLowerCase())
        .limit(1)
        .get();
    if (user.docs.length == 0) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "User is not registered as a Seller",
          style: TextStyle(color: Colors.white, fontFamily: 'Lato'),
        ),
        elevation: 0,
        duration: Duration(seconds: 2),
        backgroundColor: MyColors.primaryLight,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(5), topLeft: Radius.circular(5))),
      ));
    } else {
      Map result = await AuthService()
          .signIn(_emailController.text, _passController.text, 'seller');
      displayMessage(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: MyColors.background,
        body: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            // alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  // Center(
                  //     child: Column(
                  //   children: [
                  //     Container(
                  //         height: MediaQuery.of(context).size.height * 0.055,
                  //         margin: EdgeInsets.only(
                  //             bottom: 5,
                  //             top: MediaQuery.of(context).size.height * 0.1),
                  //         child: Image.asset('assets/images/onboardingLogo.png')),
                  //     Text(
                  //       "Explore your favorites\n around you.",
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(fontSize: 12, color: Color(0xff858585)),
                  //     )
                  //   ],
                  // )),
                  // Container(
                  //   // margin: EdgeInsets.only(
                  //   //     top: MediaQuery.of(context).size.height * 0.15),
                  //   padding: const EdgeInsets.all(16.0),
                  //   child: TextFormField(
                  //     keyboardType: TextInputType.emailAddress,
                  //     style: TextStyle(fontSize: 14, fontFamily: 'Lato'),
                  //     decoration: InputDecoration(
                  //       // icon: Icon(
                  //       //   Icons.mail,
                  //       //   color: Colors.black,
                  //       // ),
                  //       focusedBorder: OutlineInputBorder(
                  //           borderSide:
                  //               BorderSide(color: Color.fromRGBO(0, 0, 0, 0.7)),
                  //           borderRadius: BorderRadius.circular(4)),
                  //       border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.all(Radius.circular(4))),
                  //       labelText: 'Email',
                  //       labelStyle: TextStyle(
                  //         color: Color.fromRGBO(0, 0, 0, 0.4),
                  //       ),
                  //       contentPadding: const EdgeInsets.symmetric(
                  //           vertical: 20, horizontal: 20),
                  //     ),
                  //     controller: _emailController,
                  //     validator: (value) {
                  //       if (value.isEmpty ||
                  //           !value.contains('@') ||
                  //           !value.contains('.')) {
                  //         return 'Enter Valid email address';
                  //       }
                  //       return null;
                  //     },
                  //   ),
                  // ),
                  Text(
                    "Email address",
                    style: TextStyle(fontSize: 14, color: Color(0xff222222)),
                  ),
                  TextFormField(
                    style: TextStyle(fontSize: 15),
                    controller: _emailController,
                    autocorrect: _autoValidate,
                    // style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                    keyboardType: TextInputType.emailAddress,
                    // onSaved: (value) => _email = value.trim(),
                    validator: (value) => _validateEmail(value),
                    decoration: InputDecoration(
                      hintStyle:
                          TextStyle(fontSize: 15, color: Color(0xff9D9D9D)),
                      hintText: 'Dosamarvis@gmail.com',
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  // Container(
                  //   padding: const EdgeInsets.all(16.0),
                  //   child: TextFormField(
                  //     keyboardType: TextInputType.emailAddress,
                  //     style: TextStyle(fontSize: 14, fontFamily: 'Lato'),
                  //     decoration: InputDecoration(
                  //       // icon: Icon(
                  //       //   Icons.mail,
                  //       //   color: Colors.black,
                  //       // ),
                  //       focusedBorder: OutlineInputBorder(
                  //           borderSide:
                  //               BorderSide(color: Color.fromRGBO(0, 0, 0, 0.7)),
                  //           borderRadius: BorderRadius.circular(4)),
                  //       border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.all(Radius.circular(4))),
                  //       labelText: 'Password',
                  //       labelStyle: TextStyle(
                  //         color: Color.fromRGBO(0, 0, 0, 0.4),
                  //       ),
                  //       contentPadding: const EdgeInsets.symmetric(
                  //           vertical: 20, horizontal: 20),
                  //     ),
                  //     controller: _passController,
                  //     validator: (value) {
                  //       if (value.isEmpty) {
                  //         return 'Enter Valid password';
                  //       }
                  //       return null;
                  //     },
                  //   ),
                  // ),
                  Text(
                    "Password",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Color(0xff222222)),
                  ),
                  TextFormField(
                    style: TextStyle(fontSize: 15),
                    controller: _passController,
                    autocorrect: _autoValidate,
                    // style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                    // onSaved: (value) => _email = value.trim(),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter password';
                      }
                      return null;
                    },
                    obscureText: showPass, obscuringCharacter: '*',
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: showPass
                            ? SvgPicture.asset("assets/images/feather_eye.svg")
                            : SvgPicture.asset(
                                "assets/images/hide_feather_eye.svg"),
                        onPressed: () {
                          setState(() {
                            showPass = !showPass;
                          });
                        },
                      ),
                      hintStyle:
                          TextStyle(fontSize: 15, color: Color(0xff9D9D9D)),
                      hintText: 'SSD22d',
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        // User().setEmail(_emailController.text);
                        // User().setPassword(_passController.text);
                        _checkIfUserExists();
                      } else {
                        setState(() {
                          _autoValidate = true;
                        });
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 16),
                      decoration: BoxDecoration(
                          color: MyColors.bg,
                          borderRadius: BorderRadius.circular(4)),
                      width: MediaQuery.of(context).size.width,
                      height: 48,
                      child: Center(
                        child: Text("Login",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ForgotPassword('seller'),
                    )),
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * 0.1),
                      child: Text("Forgot Password?",
                          style: TextStyle(
                              fontSize: 14, color: Color(0xffc5c5c5))),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  // void displayMessage(Map result) {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (_) => DialogBox(
  //             title: result['success'] ? 'Done' : 'Error :(',
  //             description:
  //                 result['success'] ? "Sign-Up Successful" : result['msg'],
  //             buttonText1: result['success'] ? 'Continue' : 'Ok',
  //             button1Func: () {
  //               Navigator.of(context, rootNavigator: true).pop();
  //               if (result['success'])
  //                 // Navigator.pushReplacementNamed(context, '/phone_verification',
  //                 //     arguments: {
  //                 //       'email': result['user'].email,
  //                 //       'creds': result['creds'],
  //                 //       'password': result['password'],
  //                 //       'type': result['type'],
  //                 //     });
  //                 print('done login');
  //             },
  //           ));
  // }
  void displayMessage(Map result) {
    if (result['success']) {
      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
      });
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Login Successful",
          style: TextStyle(color: Colors.white, fontFamily: 'Lato'),
        ),
        elevation: 0,
        duration: Duration(seconds: 2),
        backgroundColor: MyColors.primaryLight,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(5), topLeft: Radius.circular(5))),
      ));
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Error : ${result['msg']}",
          style: TextStyle(color: Colors.white, fontFamily: 'Lato'),
        ),
        elevation: 0,
        duration: Duration(seconds: 2),
        backgroundColor: MyColors.primaryLight,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(5), topLeft: Radius.circular(5))),
      ));
    }
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

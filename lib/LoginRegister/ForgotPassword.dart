import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smackit/LoginRegister/RedirectingPage.dart';
import 'package:smackit/services/authentication.dart';
import '../Styles.dart';

class ForgotPassword extends StatefulWidget {
  final String userType;
  ForgotPassword(this.userType);
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();
  bool _autovalidate = false;
  bool _isLoading = false;
  String _email = '';

  // @override
  // void initState(){
  //   super.initState();
  // }

  _checkIfUserExists() async {
    final user = await FirebaseFirestore.instance
        .collection(widget.userType)
        .where('email', isEqualTo: _email)
        .limit(1)
        .get();
    if (user.docs.length == 0) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "No user found",
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
      FocusScope.of(context).unfocus();
      setState(() => _isLoading = true);
      bool sent = await AuthService().resetPassword(_email);
      if (sent) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            "Reset Password link sent!",
            style: TextStyle(color: Colors.white, fontFamily: 'Lato'),
          ),
          elevation: 0,
          duration: Duration(seconds: 2),
          backgroundColor: MyColors.primaryLight,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5), topLeft: Radius.circular(5))),
        ));
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => RedirectingPage()));
        });
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            "Please try again in some time",
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
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // String _email = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leadingWidth: MediaQuery.of(context).size.width * 0.11,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: GestureDetector(
              onTap: () => {Navigator.of(context).pop()},
              child: Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.03),
                  child: SvgPicture.asset(
                    'assets/images/arrow.svg',
                  ))),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                      child: Column(children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.055,
                        width: MediaQuery.of(context).size.width * 0.08,
                        margin: EdgeInsets.only(
                          bottom: 5,
                        ),
                        child: Image.asset('assets/images/onboardingLogo.png')),
                    Text(
                      "Explore your favorites\n around you.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Color(0xff858585)),
                    )
                  ])),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                  ),
                  // Image(
                  //     image: AssetImage('images/reset_password.png'),
                  //     fit: BoxFit.contain,
                  //     height: 100,
                  //     width: 100),
                  // SizedBox(height: 20),
                  Text('Forgot Password',
                      style: TextStyle(color: Color(0xff1c1c1c), fontSize: 22)),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Text(
                    'Please, enter your email address. You\n will receive a link to create a new\n password via email.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Color(0xff858585)),
                  ),
                  SizedBox(height: 20),
                  Form(
                    key: _formkey,
                    child: TextFormField(
                      autocorrect: _autovalidate,
                      enabled: !_isLoading,
                      style: TextStyle(fontSize: 14),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => _validateEmail(value.trim()),
                      onSaved: (value) => _email = value.trim(),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20),
                        labelText: 'Email',
                        // prefixIcon: Icon(Icons.mail_outline,
                        // color: MyColors.primary)
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  _isLoading
                      ? CircularProgressIndicator()
                      : GestureDetector(
                          onTap: () async {
                            if (_formkey.currentState.validate()) {
                              _formkey.currentState.save();
                              _checkIfUserExists();
                            } else
                              FocusScope.of(context).unfocus();
                            setState(() => _autovalidate = true);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.05),
                            decoration: BoxDecoration(
                                color: MyColors.bg,
                                borderRadius: BorderRadius.circular(4)),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.07,
                            child: Center(
                              child: Text("Send",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)),
                            ),
                          ),
                        ),
                  SizedBox(height: 10),
                  _isLoading
                      ? Text("Sending Email...",
                          style: TextStyle(
                            fontSize: 16,
                          ))
                      : Container()
                  // FlatButton(
                  //     onPressed: () => Navigator.of(context).pop(),
                  //     child: Text("Back",
                  //         style: TextStyle(
                  //                 fontSize: 18,
                  //                 color: Theme.of(context).accentColor)
                  //             .copyWith(letterSpacing: 2)),
                  //   )
                ],
              ),
            ),
          ),
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

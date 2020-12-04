import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as u;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smackit/LoginRegister/VerifyEmail.dart';
import 'package:smackit/models/User.dart';
import 'package:smackit/Styles.dart';
import 'package:smackit/screens/HomePage.dart';
import 'package:smackit/services/authentication.dart';
import '../widgets/SignUp.dart';

class CustomerRegistrationPage extends StatefulWidget {
  @override
  _CustomerRegistrationPageState createState() =>
      _CustomerRegistrationPageState();
}

class _CustomerRegistrationPageState extends State<CustomerRegistrationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showPass = true;
  bool showPassConfirm = true;
  bool _autoValidate = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _passConfirmController = TextEditingController();
  // final _flipKey = GlobalKey<FlipCardState>();
  Map result;
  bool isLogin = true;
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
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
                      if (value.isEmpty || !(value.length > 5)) {
                        return 'Enter valid password';
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
                      hintText: '******',
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Text(
                    "Confirm Password",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Color(0xff222222)),
                  ),
                  TextFormField(
                    style: TextStyle(fontSize: 15),
                    controller: _passConfirmController,
                    autocorrect: _autoValidate,
                    // style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                    // onSaved: (value) => _email = value.trim(),
                    validator: (value) {
                      if (value.trim().compareTo(_passController.text) != 0 ||
                          value.isEmpty) {
                        return 'Password mismatch';
                      }
                      return null;
                    },
                    obscureText: showPassConfirm, obscuringCharacter: '*',
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: showPassConfirm
                            ? SvgPicture.asset("assets/images/feather_eye.svg")
                            : SvgPicture.asset(
                                "assets/images/hide_feather_eye.svg"),
                        onPressed: () {
                          setState(() {
                            showPassConfirm = !showPassConfirm;
                          });
                        },
                      ),
                      hintStyle:
                          TextStyle(fontSize: 15, color: Color(0xff9D9D9D)),
                      hintText: '******',
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  GestureDetector(
                    onTap: () async {
                      User _user = User(
                          userType: TypeOfUser.customer,
                          email: _emailController.text,
                          password: _passController.text);
                      if (_formKey.currentState.validate()) {
                        Map result = await AuthService()
                            .signUp('email', 'customer', user: _user);
                        displayMessage(result);
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
                        child: Text("Register",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Center(
                    child: Container(
                        height: MediaQuery.of(context).size.width * 0.06,
                        width: MediaQuery.of(context).size.width,
                        child: SvgPicture.asset(
                            'assets/images/OrContinueWith.svg')),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            Map result = await AuthService().signUp(
                                'google', 'customer',
                                user: User(userType: TypeOfUser.customer));
                            displayMessage(result);
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.075,
                            width: MediaQuery.of(context).size.width / 2.6,
                            margin: EdgeInsets.only(left: 16),
                            child: Center(
                                child: Row(
                              children: [
                                Container(
                                    margin: EdgeInsets.only(
                                      right: 10,
                                      left: 20,
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.029,
                                    child: Image.asset(
                                        'assets/images/google.png')),
                                Text(
                                  "Google",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ],
                            )),
                            decoration: BoxDecoration(
                                color: Color(0xff5392F0),
                                border: Border.all(
                                    width: 1,
                                    color: Color.fromRGBO(0, 0, 0, 0.2)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.height * 0.00001,
                        ),
                        GestureDetector(
                          onTap: () async {
                            Map result = await AuthService().signUp(
                                'facebook', 'customer',
                                user: User(userType: TypeOfUser.customer));
                            displayMessage(result);
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.075,
                            width: MediaQuery.of(context).size.width / 2.6,
                            margin: EdgeInsets.only(left: 8, right: 16),
                            child: Center(
                                child: Row(
                              children: [
                                Container(
                                    margin: EdgeInsets.only(
                                      right: 10,
                                      left: 20,
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.029,
                                    child: Image.asset(
                                        'assets/images/facebook.png')),
                                Text(
                                  "Facebook",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ],
                            )),
                            decoration: BoxDecoration(
                                color: Color(0xff3B5998),
                                border: Border.all(
                                    width: 1,
                                    color: Color.fromRGBO(0, 0, 0, 0.2)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  // final u.FirebaseAuth _auth = u.FirebaseAuth.instance;
  // final GoogleSignIn googleSignIn = GoogleSignIn();
  // Future<String> signInUsingGoogle() async {
  //   final u.FirebaseAuth _auth = u.FirebaseAuth.instance;
  //   print("1");
  //   final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  //   print("2");
  //   final GoogleSignInAuthentication googleSignInAuthentication =
  //       await googleSignInAccount.authentication;
  //   final u.AuthCredential credential = u.GoogleAuthProvider.credential(
  //     accessToken: googleSignInAuthentication.accessToken,
  //     idToken: googleSignInAuthentication.idToken,
  //   );

  //   final u.UserCredential authResult =
  //       await _auth.signInWithCredential(credential);
  //   final u.User user = authResult.user;

  //   if (user != null) {
  //     assert(!user.isAnonymous);
  //     assert(await user.getIdToken() != null);

  //     final u.User currentUser = _auth.currentUser;
  //     assert(user.uid == currentUser.uid);

  //     print('signInWithGoogle succeeded: $user');

  //     return '$user';
  //   }

  //   return null;
  // }

  // signInUsingFacebook() async {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (_) => Center(child: CircularProgressIndicator()));
  //   result = await AuthService()
  //       .signUp('facebook', user: User(userType: TypeOfUser.customer));
  //   Navigator.of(context, rootNavigator: true).pop();
  //   displayMessage(result);
  // }

  void displayMessage(Map result) async {
    if (result['success']) {
      u.User user = await AuthService().getCurrentUser();
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .get();
      bool data = doc.data()['email_verified'];
      if (!data)
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            "Sign-up Successful",
            style: TextStyle(color: Colors.white, fontFamily: 'Lato'),
          ),
          elevation: 0,
          duration: Duration(milliseconds: 500),
          backgroundColor: MyColors.primaryLight,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5), topLeft: Radius.circular(5))),
        ));
      Future.delayed(const Duration(seconds: 1), () async {
        if (data) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomePage(),
            ));
          });
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              "Facebook sign up successful",
              style: TextStyle(color: Colors.white, fontFamily: 'Lato'),
            ),
            elevation: 0,
            duration: Duration(milliseconds: 500),
            backgroundColor: MyColors.primaryLight,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5), topLeft: Radius.circular(5))),
          ));
        } else {
          Navigator.of(context).pop();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => VerifyEmail(
                      _emailController.text.trim().toLowerCase(), 'users')));
        }
      });
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

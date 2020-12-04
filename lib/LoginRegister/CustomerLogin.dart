import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smackit/Styles.dart';
import 'package:smackit/LoginRegister/ForgotPassword.dart';
import 'package:smackit/screens/HomePage.dart';
import 'package:smackit/services/authentication.dart';

class CustomerLogin extends StatefulWidget {
  @override
  _CustomerLoginState createState() => _CustomerLoginState();
}

class _CustomerLoginState extends State<CustomerLogin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showPass = true;
  bool _autoValidate = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  // User user = new User();
  // final _flipKey = GlobalKey<FlipCardState>();
  Map result;
  bool isLogin = true;

  _checkIfUserExists() async {
    final user = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: _emailController.text.trim().toLowerCase())
        .limit(1)
        .get();
    if (user.docs.length == 0) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "User is not registered as a Customer",
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
          .signIn(_emailController.text, _passController.text, 'customer');
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
            // child: SingleChildScrollView(
            //   child: FadeAnimation(
            //     delay: 1.5,
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: <Widget>[
            //         SizedBox(height: 50),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: <Widget>[
            //             FlatButton(
            //               onPressed: !isLogin
            //                   ? () {
            //                       _flipKey.currentState.toggleCard();
            //                       setState(() => isLogin = true);
            //                     }
            //                   : null,
            //               shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(25)),
            //               child: FittedBox(
            //                 child: Padding(
            //                   padding: const EdgeInsets.symmetric(
            //                       horizontal: 12.0, vertical: 10),
            //                   child: Text(
            //                     'Login',
            //                     style: TextStyle(
            //                         fontSize: 25,
            //                         color: isLogin
            //                             ? MyColors.secondary
            //                             : MyColors.primary,
            //                         fontWeight: isLogin ? FontWeight.bold : null),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //             SizedBox(width: 5),
            //             FlatButton(
            //               onPressed: isLogin
            //                   ? () {
            //                       _flipKey.currentState.toggleCard();
            //                       setState(() => isLogin = false);
            //                     }
            //                   : null,
            //               shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(25)),
            //               child: FittedBox(
            //                 child: Padding(
            //                   padding: const EdgeInsets.symmetric(
            //                       horizontal: 12.0, vertical: 10),
            //                   child: Text(
            //                     'Register',
            //                     style: TextStyle(
            //                         fontSize: 25,
            //                         color: !isLogin
            //                             ? MyColors.secondary
            //                             : MyColors.primary,
            //                         fontWeight: !isLogin ? FontWeight.bold : null),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //         FlipCard(
            //           key: _flipKey,
            //           flipOnTouch: false,
            //           front: LoginForm(),
            //           back: SignUpForm(),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // GestureDetector(
                  //   onTap: () => {signInUsingGoogle()},
                  //   child: Container(
                  //     height: MediaQuery.of(context).size.height * 0.075,
                  //     width: MediaQuery.of(context).size.width,
                  //     margin: EdgeInsets.only(left: 16, right: 16),
                  //     child: Center(
                  //         child: Row(
                  //       children: [
                  //         Container(
                  //             margin: EdgeInsets.only(
                  //               right: 20,
                  //               left: 20,
                  //             ),
                  //             height:
                  //                 MediaQuery.of(context).size.height * 0.029,
                  //             child: Image.asset('assets/images/google.png')),
                  //         Text(
                  //           "Sign up with Google",
                  //           style: TextStyle(
                  //               fontSize: 14, color: Color(0xff1C1C1C)),
                  //         ),
                  //       ],
                  //     )),
                  //     decoration: BoxDecoration(
                  //         border: Border.all(
                  //             width: 1, color: Color.fromRGBO(0, 0, 0, 0.2)),
                  //         borderRadius: BorderRadius.all(Radius.circular(4))),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height * 0.03,
                  // ),
                  // GestureDetector(
                  //   onTap: () => signInUsingFacebook(),
                  //   child: Container(
                  //     height: MediaQuery.of(context).size.height * 0.075,
                  //     width: MediaQuery.of(context).size.width,
                  //     margin: EdgeInsets.only(left: 16, right: 16),
                  //     child: Center(
                  //         child: Row(
                  //       children: [
                  //         Container(
                  //             margin: EdgeInsets.only(
                  //               right: 20,
                  //               left: 20,
                  //             ),
                  //             height:
                  //                 MediaQuery.of(context).size.height * 0.029,
                  //             child: Image.asset('assets/images/facebook.png')),
                  //         Text(
                  //           "Sign up with Facebook",
                  //           style: TextStyle(fontSize: 14, color: Colors.white),
                  //         ),
                  //       ],
                  //     )),
                  //     decoration: BoxDecoration(
                  //         color: Color(0xff3B5998),
                  //         border: Border.all(
                  //             width: 1, color: Color.fromRGBO(0, 0, 0, 0.2)),
                  //         borderRadius: BorderRadius.all(Radius.circular(4))),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height * 0.03,
                  // ),
                  // Container(
                  //   height: MediaQuery.of(context).size.height * 0.075,
                  //   width: MediaQuery.of(context).size.width,
                  //   margin: EdgeInsets.only(left: 16, right: 16),
                  //   child: Center(
                  //       child: Row(
                  //     children: [
                  //       Container(
                  //           margin: EdgeInsets.only(
                  //             right: 20,
                  //             left: 20,
                  //           ),
                  //           height: MediaQuery.of(context).size.height * 0.029,
                  //           child: Image.asset('assets/images/emailLogo.png')),
                  //       Text(
                  //         "Sign up with Email",
                  //         style: TextStyle(fontSize: 14, color: Colors.white),
                  //       ),
                  //     ],
                  //   )),
                  //   decoration: BoxDecoration(
                  //       color: MyColors.bg,
                  //       border: Border.all(
                  //           width: 1, color: Color.fromRGBO(0, 0, 0, 0.2)),
                  //       borderRadius: BorderRadius.all(Radius.circular(4))),
                  // ),
                  // Container(
                  //   margin: EdgeInsets.only(
                  //       top: MediaQuery.of(context).size.height / 8),
                  //   child: Column(
                  //     children: [
                  //       Text(
                  //         "Already have an account?",
                  //         style:
                  //             TextStyle(color: Color(0xff858585), fontSize: 14),
                  //       ),
                  //       GestureDetector(
                  //         onTap: () => Navigator.of(context).push(
                  //             MaterialPageRoute(
                  //                 builder: (context) => SellerLogin())),
                  //         // onTap: () => print("hello"),
                  //         child: Text(
                  //           "Sign In",
                  //           style: TextStyle(color: MyColors.bg, fontSize: 18),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // )
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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
                    validator: (value) => _validateEmail(value.trim()),
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
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Map result = await AuthService().googleSignIn();
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
                                  child:
                                      Image.asset('assets/images/google.png')),
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
                          Map result = await AuthService().facebookSignIn();
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
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ForgotPassword('users'),
                    )),
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * 0.1),
                      child: Text("Forgot Password?",
                          style: TextStyle(
                              fontSize: 14, color: Color(0xffc5c5c5))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
  // DatabaseService db = DatabaseService();
  // User _user;
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
  //   _user.setEmail(user.email);
  //   _user.setUid(user.uid);
  //   _user.setPhototUrl(googleSignInAccount.photoUrl);
  //   if (user != null) {
  //    db.createUser()
  //   }

  //   return null;
  // }

  // u.FirebaseAuth _auth = u.FirebaseAuth.instance;
  // Future<u.User> _signIn() async {
  //   GoogleSignInAccount googleSignInAccount = await GoogleSignIn().signIn();
  //   GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;
  //   final u.AuthCredential credential = u.GoogleAuthProvider.credential(
  //     accessToken: gSA.accessToken,
  //     idToken: gSA.idToken,
  //   );
  //   final u.UserCredential authResult =
  //       await _auth.signInWithCredential(credential);
  //   u.User user = authResult.user;
  //   return user;
  // }

  // final facebookSignIn = FacebookLogin();
  // signInUsingFacebook() async {
  //   FacebookLoginResult result =
  //       await facebookSignIn.logInWithReadPermissions(['email']);
  //   print(result.toString() + "This is result");
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
        duration: Duration(milliseconds: 500),
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

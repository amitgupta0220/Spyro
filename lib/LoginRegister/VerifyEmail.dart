import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smackit/Styles.dart';
import 'package:smackit/screens/HomePage.dart';

class VerifyEmail extends StatefulWidget {
  final String _email, type;
  @override
  _VerifyEmailState createState() => _VerifyEmailState();
  VerifyEmail(this._email, this.type);
}

class _VerifyEmailState extends State<VerifyEmail> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int countForVerifyEmailClicked = 0;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String msgForWaitingVerifyToast =
      "Please check your email and click on verify link";
  String email = 'email';
  bool isVerified = false;
  @override
  void initState() {
    super.initState();
    sendEmail();
  }

  sendEmail() async {
    try {
      User user = _firebaseAuth.currentUser;
      setState(() {
        this.email = widget._email;
      });
      await user.sendEmailVerification();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "E-mail Verification link sent!",
          style: TextStyle(color: Colors.white, fontFamily: 'Lato'),
        ),
        elevation: 0,
        duration: Duration(seconds: 2),
        backgroundColor: MyColors.primaryLight,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(5), topLeft: Radius.circular(5))),
      ));
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Error: Retry in some time.",
          style: TextStyle(color: Colors.white, fontFamily: 'Lato'),
        ),
        elevation: 0,
        duration: Duration(seconds: 2),
        backgroundColor: MyColors.primaryLight,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(5), topLeft: Radius.circular(5))),
      ));
      print("An error occured while trying to send email verification");
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                child: SvgPicture.asset('assets/images/arrow.svg'))),
      ),
      backgroundColor: MyColors.background,
      body: Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: SvgPicture.asset('assets/images/verifyEmail.svg'),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Center(
                  child: Text(
                    "Check your email",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 24,
                        color: Color(0xff292929),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Center(
                  child: Text(
                    "To continue tap on the link\n we have sent you on your \nemail address.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff878787),
                        fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                GestureDetector(
                  onTap: () async {
                    User user = FirebaseAuth.instance.currentUser..reload();
                    setState(() {});
                    // print(user.isEmailVerified);
                    if (user.emailVerified) {
                      DocumentReference doc = FirebaseFirestore.instance
                          .collection(widget.type)
                          .doc(widget._email);
                      doc.update({'email_verified': true});
                      setState(() {
                        this.isVerified = true;
                      });
                      Future.delayed(Duration(seconds: 1), () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ));
                      });
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                          "Verification successful",
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Lato'),
                        ),
                        elevation: 0,
                        duration: Duration(milliseconds: 500),
                        backgroundColor: MyColors.primaryLight,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                topLeft: Radius.circular(5))),
                      ));
                      // Future.delayed(const Duration(seconds: 2), () {
                      //   Navigator.pushReplacement(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => RedirectingPage()));
                      // });
                    } else {
                      countForVerifyEmailClicked++;
                      if (countForVerifyEmailClicked >= 3) {
                        setState(() {
                          this.msgForWaitingVerifyToast =
                              "Please wait while we are verifying you";
                        });
                      }
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                          msgForWaitingVerifyToast,
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Lato'),
                        ),
                        elevation: 0,
                        duration: Duration(seconds: 2),
                        backgroundColor: MyColors.primaryLight,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                topLeft: Radius.circular(5))),
                      ));
                    }
                  },
                  child: Container(
                    // margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: MyColors.bg,
                        borderRadius: BorderRadius.circular(4)),
                    width: MediaQuery.of(context).size.width,
                    height: 48,
                    child: Center(
                      child: Text("Verify Email",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.075,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn’t get an email?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff878787),
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        print("retry");
                      },
                      child: Text(
                        "Retry",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xffD2302E),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}

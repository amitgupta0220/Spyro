import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smackit/LoginRegister/NavPage.dart';
import 'package:smackit/LoginRegister/NavPageRegistration.dart';
import 'package:smackit/Styles.dart';

class RedirectingPage extends StatefulWidget {
  @override
  _RedirectingPageState createState() => _RedirectingPageState();
}

class _RedirectingPageState extends State<RedirectingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.background,
        body: Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            // alignment: Alignment.center,
            child: SingleChildScrollView(
                child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.055,
                      width: MediaQuery.of(context).size.width * 0.08,
                      margin: EdgeInsets.only(
                          bottom: 5,
                          top: MediaQuery.of(context).size.height * 0.05),
                      child: Image.asset('assets/images/onboardingLogo.png')),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Explore your favorites\n around you.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Color(0xff858585)),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: SvgPicture.asset('assets/images/redirectPageIcon.svg'),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Text(
                  "Lorem ipsum dolor sit amet,\nconsectetur adipisci",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff292929)),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sit faucibus ",
                  style: TextStyle(fontSize: 12, color: Color(0xffafafaf)),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => NavPage()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.075,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            width: 1,
                            color: Colors.black)), //color: Color(0xff888888)
                    child: Center(
                      child: Text("Log in",
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NavPageRegistration())),
                  child: Container(
                    margin: EdgeInsets.only(top: 16),
                    decoration: BoxDecoration(
                        color: MyColors.primaryLight,
                        borderRadius: BorderRadius.circular(4)),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.075,
                    child: Center(
                      child: Text("Register",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ),
              ],
            ))));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smackit/Styles.dart';
import 'package:smackit/services/authentication.dart';
import 'package:smackit/LoginRegister/RedirectingPage.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: AppBar(
        leading: Container(),
        backgroundColor: MyColors.primaryLight,
        elevation: 0,
        title: Container(
          margin:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.2),
          child: Text('Profile',
              style: TextStyle(color: Colors.white, fontSize: 22)),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/images/pencil.svg',
              height: MediaQuery.of(context).size.width * 0.08,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.05),
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.width * 0.3,
                alignment: Alignment.center,
                child: CircleAvatar(
                  child: Icon(
                    Icons.person,
                    color: MyColors.bg,
                  ),
                  radius: 50,
                  backgroundColor: MyColors.background,
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: MyColors.primaryLight, width: 1),
                    color: MyColors.background,
                    shape: BoxShape.circle),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.05,
            ),
            Center(
              child: Column(
                children: [
                  Text('Name',
                      style: TextStyle(
                        color: Color(0xff292929),
                        fontSize: 14,
                      )),
                  Text('Premium',
                      style: TextStyle(
                        color: Color(0xffc5c5c5),
                        fontSize: 8,
                      )),
                ],
              ),
            ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.width * 0.05,
            // ),
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.09),
              child: Column(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/images/userForProfile.svg'),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.04,
                      ),
                      Text(
                        "Some Name",
                        style: TextStyle(
                            color: Color(0xff292929),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset('assets/images/phoneForProfile.svg'),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.04,
                      ),
                      Text(
                        "+91 9999999999",
                        style: TextStyle(
                            color: Color(0xff292929),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset('assets/images/emailForProfile.svg'),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.04,
                      ),
                      Text(
                        "test@test.com",
                        style: TextStyle(
                            color: Color(0xff292929),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset('assets/images/locationForProfile.svg'),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.04,
                      ),
                      Text(
                        "Mumbai",
                        style: TextStyle(
                            color: Color(0xff292929),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset('assets/images/aboutForProfile.svg'),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.04,
                      ),
                      Text(
                        "About me",
                        style: TextStyle(
                            color: Color(0xff292929),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          "My Stores",
                          style: TextStyle(
                              color: MyColors.primaryLight,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Container(
                        child:
                            SvgPicture.asset('assets/images/bagForProfile.svg'),
                      )
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          "My Reviews",
                          style: TextStyle(
                              color: MyColors.primaryLight,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Container(
                        child: SvgPicture.asset(
                            'assets/images/reviewForProfile.svg'),
                      )
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  GestureDetector(
                    onTap: () {
                      AuthService().signOut();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => RedirectingPage()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "Logout",
                            style: TextStyle(
                                color: MyColors.primaryLight,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Container(
                          child: SvgPicture.asset(
                              'assets/images/logoutForProfile.svg'),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}

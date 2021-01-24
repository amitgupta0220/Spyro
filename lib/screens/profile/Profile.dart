import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smackit/Styles.dart';
import 'package:smackit/screens/Stores/MyReviewsTab.dart';
import 'package:smackit/screens/Stores/MyStoresTab.dart';
import 'package:smackit/screens/profile/ProfileEditTab.dart';
import 'package:smackit/services/authentication.dart';
import 'package:smackit/LoginRegister/RedirectingPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  final String name, phone, about, location, email;
  Profile({this.about, this.email, this.location, this.name, this.phone});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name, phone, about, locationForProfile, email;
  // User _user;
  // FirebaseAuth _auth = FirebaseAuth.instance;
  // getUser() async {
  //   _user = _auth.currentUser;
  //   final userDoc = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(_user.email)
  //       .get();
  //   phone = userDoc.data()['phone'];
  //   about = userDoc.data()['about'];
  //   name = userDoc.data()['name'];
  //   email = _user.email;
  //   locationForProfile = userDoc.data()['location'];
  // }

  @override
  void initState() {
    super.initState();
    name = widget.name;
    phone = widget.phone;
    about = widget.about;
    email = widget.email;
    locationForProfile = widget.location;
    getOtherData();
    // getUser();
  }

  getOtherData() async {
    DocumentSnapshot documentRefernce =
        await FirebaseFirestore.instance.collection("users").doc(email).get();
    locationForProfile = documentRefernce.data()["location"];
    name = documentRefernce.data()["name"];
    phone = documentRefernce.data()["phone"];
    about = documentRefernce.data()["about"];
    setState(() {});
  }

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
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.17),
          child: Text('Profile',
              style: TextStyle(color: Colors.white, fontSize: 22)),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/images/pencil.svg',
              height: MediaQuery.of(context).size.width * 0.08,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfileEditTab(
                        onFieldUpdated: onFieldUpdated,
                        about: about == null ? "About me" : about,
                        email: email,
                        location: locationForProfile,
                        name: name,
                        phone:
                            phone == null ? "Enter your phone number" : phone,
                      )));
            },
          )
        ],
      ),
      body: Container(
          // color: MyColors.background,
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
                  Text(name,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name",
                        style: TextStyle(
                            color: Color(0xff292929),
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.04,
                      ),
                      Text(
                        name,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Phone",
                        style: TextStyle(
                            color: Color(0xff292929),
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.04,
                      ),
                      Text(
                        phone == null ? "Enter you phone number" : phone,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email",
                        style: TextStyle(
                            color: Color(0xff292929),
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.04,
                      ),
                      Text(
                        email == null ? "test@test.com" : email,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Location",
                        style: TextStyle(
                            color: Color(0xff292929),
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.04,
                      ),
                      Text(
                        locationForProfile == null
                            ? "Some location"
                            : locationForProfile,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "About Me",
                        style: TextStyle(
                            color: Color(0xff292929),
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.04,
                      ),
                      Text(
                        about == null ? "About me" : about,
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
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MyStoresTab()));
                    },
                    child: Row(
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
                          child: SvgPicture.asset(
                              'assets/images/bagForProfile.svg'),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MyReviewsTab()));
                    },
                    child: Row(
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

  dynamic onFieldUpdated(List data) {
    setState(() {
      this.name = data[0];
      this.phone = data[1];
      this.about = data[2];
    });
  }
}

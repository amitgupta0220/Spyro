import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smackit/Styles.dart';
import 'package:smackit/screens/Stores/addStore.dart';
import 'package:smackit/screens/chats/ChatPage.dart';
import 'package:smackit/screens/profile/Profile.dart';
import 'package:smackit/screens/Home/HomeTab.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  int _currentIndex = 0;
  User _user;
  String type;
  controlTap(index) {
    setState(() {
      _currentIndex = index;
    });
  }

  getUser() async {
    _user = _auth.currentUser;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user.email)
        .get();
    type = userDoc.data()['userType'] == 'customer' ? 'users' : 'seller';
    setState(() {});
    print("this is type" + _user.email);
  }

  void initState() {
    super.initState();
    getUser();
  }

  Future<bool> alert() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Do you want to Exit",
                style: TextStyle(fontFamily: 'Lato'),
              ),
              actions: <Widget>[
                Row(
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child:
                            Text("No", style: TextStyle(fontFamily: 'Lato'))),
                    SizedBox(
                      height: 50,
                    ),
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child:
                            Text("Yes", style: TextStyle(fontFamily: 'Lato')))
                  ],
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      HomeTab(),
      AddStore(),
      ChatPage(
        type: type,
      ),
      Profile(),
    ];
    return WillPopScope(
      onWillPop: () {
        return alert();
      },
      child: Scaffold(
        backgroundColor: Color(0xffc4c4c4),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: MyColors.bg,
          unselectedItemColor: Color(0xffc4c4c4), showUnselectedLabels: true,
          unselectedLabelStyle: TextStyle(color: Color(0xffc4c4c4)),
          currentIndex: _currentIndex,
          onTap: controlTap, // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add Store',
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset('assets/images/activeChatTab.svg'),
              icon: SvgPicture.asset('assets/images/chatTab.svg'),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              activeIcon:
                  SvgPicture.asset('assets/images/activeProfileTab.svg'),
              icon: SvgPicture.asset('assets/images/profileTab.svg'),
              label: 'Profile',
            ),
          ],
        ),
        body: _children[_currentIndex],
      ),
    );
  }
}

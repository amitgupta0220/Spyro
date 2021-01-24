import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:smackit/Styles.dart';
import 'package:smackit/screens/Stores/addStore.dart';
import 'package:smackit/screens/chats/NavChat.dart';
import 'package:smackit/screens/profile/Profile.dart';
import 'package:smackit/screens/Home/HomeTab.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String subCity;
  String city;
  String name, phoneNo, about, locationForProfile, email;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Location location = new Location();
  bool _serviceEnabled = false;
  // PermissionStatus _permissionGranted;
  LocationData _locationData;
  int _currentIndex = 0;
  User _user;
  String type, uid;
  controlTap(index) {
    setState(() {
      _currentIndex = index;
    });
  }

  getUser() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // subCity = prefs.getString('subCity');
    _user = _auth.currentUser;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user.email)
        .get();
    phoneNo = userDoc.data()['phone'];
    about = userDoc.data()['about'];
    name = userDoc.data()['name'];
    email = _user.email;
    locationForProfile = userDoc.data()['location'];
    type = userDoc.data()['userType'] == 'customer' ? 'users' : 'seller';
    uid = _user.uid;
    setState(() {});
    print("this is type " + type);
  }

  getLocation() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    _serviceEnabled = await location.serviceEnabled();
    // assert(_serviceEnabled != null);
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // _permissionGranted = await location.hasPermission();
    // if (_permissionGranted == PermissionStatus.denied) {
    //   _permissionGranted = await location.requestPermission();
    //   if (_permissionGranted != PermissionStatus.granted) {
    //     return;
    //   }
    // }

    _locationData = await location.getLocation();
    final coordinates =
        new Coordinates(_locationData.latitude, _locationData.longitude);
    // new Coordinates(_locationData.latitude, _locationData.longitude);
    List<Address> addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    // prefs.setString("subCity", addresses.first.subLocality);
    setState(() {
      subCity = addresses.first.subLocality;
      if (subCity.contains(" ")) {
        subCity = subCity.split(" ")[0];
      } else if (subCity.contains("(")) {
        subCity = subCity.split("(")[0];
      } else if (subCity.contains("[")) {
        subCity = subCity.split("[")[0];
      }
      city = addresses.first.subAdminArea;
      locationForProfile = subCity + "," + city;
      FirebaseFirestore.instance
          .collection("users")
          .doc(email)
          .update({"location": locationForProfile});
      print("this is subCity " + addresses.first.subLocality);
    });
    // Scaffold.of(context).showSnackBar(SnackBar(
    //   content: Text(
    //     _locationData.longitude.toString(),
    //     style: TextStyle(color: Colors.white, fontFamily: 'Lato'),
    //   ),
    //   elevation: 0,
    //   duration: Duration(milliseconds: 1000),
    //   backgroundColor: MyColors.primaryLight,
    //   shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.only(
    //           topRight: Radius.circular(5), topLeft: Radius.circular(5))),
    // ));
  }

  void initState() {
    super.initState();
    getUser();
    getLocation();
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
      HomeTab(subCity: subCity, city: city),
      AddStore(),
      // ChatPage(
      //   type: type,
      //   uid: uid,
      // ),
      NavChat(
        type: type,
        uid: uid,
      ),
      Profile(
        about: about,
        email: email,
        location: locationForProfile,
        name: name,
        phone: phoneNo,
      ),
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
        body: _serviceEnabled && subCity != null
            ? _children[_currentIndex]
            // // : Center(
            // //     child: Column(
            // //       mainAxisAlignment: MainAxisAlignment.center,
            // //       children: [
            // //         Text("Location not enabled"),
            // //         FlatButton(
            // //             child: Text("Tap to retry"),
            // //             onPressed: () {
            // //               Navigator.of(context).pushReplacement(
            // //                   MaterialPageRoute(
            // //                       builder: (context) => HomePage()));
            // //             }),
            // //         CircularProgressIndicator(),
            //       ],
            : Scaffold(
                appBar: AppBar(
                  leadingWidth: MediaQuery.of(context).size.width * 0.15,
                  leading: Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.02),
                    child: IconButton(
                      onPressed: () {
                        print(subCity);
                        // temp();
                      },
                      icon: SvgPicture.asset(
                        'assets/images/SplashLogo.svg',
                      ),
                    ),
                  ),
                  title: Text(
                    subCity == null ? "Location" : subCity,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                      // decorationStyle: TextDecorationStyle.dashed
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.05),
                      child:
                          SvgPicture.asset('assets/images/rewardForHome.svg'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.05),
                      child: SvgPicture.asset('assets/images/bellForHome.svg'),
                    ),
                  ],
                  elevation: 0,
                  backgroundColor: MyColors.primaryLight,
                ),
                backgroundColor: MyColors.primary,
                body: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                        // mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                          Container(
                            color: MyColors.primaryLight,
                            height: MediaQuery.of(context).size.height * 0.085,
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.05,
                                right: MediaQuery.of(context).size.width * 0.05,
                                bottom:
                                    MediaQuery.of(context).size.width * 0.03,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4)),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.03),
                                    child: SvgPicture.asset(
                                        'assets/images/searchForHome.svg'),
                                  ),
                                  Flexible(
                                    child: TextFormField(
                                      enabled: false,
                                      // controller: _searchController,
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff9D9D9D)),
                                        hintText:
                                            'Search for food, hardware, pets...',
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Text("Location not enabled"),
                          FlatButton(
                              child: Text("Tap to retry"),
                              onPressed: () {
                                // Navigator.of(context).pushReplacement(
                                //     MaterialPageRoute(
                                //         builder: (context) => HomePage()));
                                getLocation();
                              }),
                          CircularProgressIndicator(),
                        ])),
              ),
      ),
    );
  }
}

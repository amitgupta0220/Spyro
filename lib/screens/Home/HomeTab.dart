import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smackit/Styles.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smackit/screens/Home/SearchPage.dart';
import 'package:smackit/screens/Stores/ViewStores.dart';

class HomeTab extends StatefulWidget {
  final String subCity, city;
  HomeTab({this.subCity, this.city});
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  // String subCity = 'Borivali';
  String subCatergorayCase = "all";
  final _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // temp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width * 0.15,
        leading: Container(
          margin:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02),
          child: IconButton(
            onPressed: () {
              String cityy = "Vikhroli(e)";
              if (cityy.contains("(")) print(cityy.split("(")[0]);
              // temp();
            },
            icon: SvgPicture.asset(
              'assets/images/SplashLogo.svg',
            ),
          ),
        ),
        title: Text(
          widget.subCity == null ? "Location" : widget.subCity,
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
            child: SvgPicture.asset('assets/images/rewardForHome.svg'),
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
        child: ListView(
          children: [
            Container(
              color: MyColors.primaryLight,
              height: MediaQuery.of(context).size.height * 0.085,
              width: MediaQuery.of(context).size.width,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SearchPage()));
                },
                child: Container(
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: MediaQuery.of(context).size.width * 0.05,
                    bottom: MediaQuery.of(context).size.width * 0.03,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.03,
                            right: MediaQuery.of(context).size.width * 0.03),
                        child:
                            SvgPicture.asset('assets/images/searchForHome.svg'),
                      ),
                      Flexible(
                        child: TextFormField(
                          enabled: false,
                          controller: _searchController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 14, color: Color(0xff9D9D9D)),
                            hintText: 'Search for food, hardware, pets...',
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            DiscountCard(),
            CreateMenuOptions(
              onFieldUpdated: onFieldUpdated,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            subCatergorayCase == "all"
                ? StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('stores_new')
                        .where('Location', isEqualTo: widget.city.split(" ")[0])
                        // .limit(10)
                        .snapshots(),
                    builder: (context, snapshot) {
                      List<Widget> storeList = [];
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasData) {
                        // print(snapshot.data.docs.length);
                        int i = 0;
                        final datas = snapshot.data.docs;
                        for (var data in datas) {
                          // print(data);
                          String location = data.data()['Address'];
                          var category = data.data()['category'];
                          var name = data.data()['name'];
                          // var rating = data.data()['rating'];
                          var phoneNo = data.data()['Phone No'];
                          var rating = 3.0;
                          var uid = data.data()['uid'];
                          // var email = data.data()['email'];

                          if (location
                                  .toLowerCase()
                                  .contains(widget.subCity.toLowerCase()) &&
                              i < 11) {
                            i++;
                            storeList.add(StoreDisplay(
                              // email: email,
                              phoneNo: phoneNo ?? "2222222222",
                              timing: '09:00AM-06:00PM',
                              uid: uid,
                              address: location,
                              category: category,
                              name: name,
                              rating: rating,
                            ));
                          }
                        }
                        return ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            primary: false,
                            children: <Widget>[
                              ...storeList.map((e) {
                                return e;
                              }).toList()
                            ]);
                        // : Scaffold.of(context).showSnackBar(SnackBar(
                        //     content: Text(
                        //       "Enable Location",
                        //       style: TextStyle(
                        //           color: Colors.white, fontFamily: 'Lato'),
                        //     ),
                        //     elevation: 0,
                        //     duration: Duration(milliseconds: 1000),
                        //     backgroundColor: MyColors.primaryLight,
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.only(
                        //             topRight: Radius.circular(5),
                        //             topLeft: Radius.circular(5))),
                        //   ));
                      }
                      return Container();
                    },
                  )
                : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('stores_new')
                        .where('Location', isEqualTo: widget.city.split(" ")[0])
                        .where(
                            subCatergorayCase == "Hardware store"
                                ? "subcategory"
                                : "category",
                            isEqualTo: subCatergorayCase)
                        // .limit(10)
                        .snapshots(),
                    builder: (context, snapshot) {
                      List<Widget> storeList = [];
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasData) {
                        // print(snapshot.data.docs.length);
                        int i = 0;
                        final datas = snapshot.data.docs;
                        for (var data in datas) {
                          // print(data);
                          String location = data.data()['Address'];
                          var category = data.data()['category'];
                          var name = data.data()['name'];
                          // var rating = data.data()['rating'];
                          var phoneNo = data.data()['Phone No'];
                          var rating = 3.0;
                          var uid = data.data()['uid'];
                          // var email = data.data()['email'];

                          if (location
                                  .toLowerCase()
                                  .contains(widget.subCity.toLowerCase()) &&
                              i < 11) {
                            i++;
                            storeList.add(StoreDisplay(
                              // email: email,
                              phoneNo: phoneNo ?? "2222222222",
                              timing: '09:00AM-06:00PM',
                              uid: uid,
                              address: location,
                              category: category,
                              name: name,
                              rating: rating,
                            ));
                          }
                        }
                        return ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            primary: false,
                            children: <Widget>[
                              ...storeList.map((e) {
                                return e;
                              }).toList()
                            ]);
                        // : Scaffold.of(context).showSnackBar(SnackBar(
                        //     content: Text(
                        //       "Enable Location",
                        //       style: TextStyle(
                        //           color: Colors.white, fontFamily: 'Lato'),
                        //     ),
                        //     elevation: 0,
                        //     duration: Duration(milliseconds: 1000),
                        //     backgroundColor: MyColors.primaryLight,
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.only(
                        //             topRight: Radius.circular(5),
                        //             topLeft: Radius.circular(5))),
                        //   ));
                      }
                      return Container();
                    },
                  ),
          ],
        ),
      ),
    );
  }

  onFieldUpdated(String value) {
    setState(() {
      subCatergorayCase = value;
    });
  }
}

class DiscountCard extends StatefulWidget {
  @override
  _DiscountCardState createState() => _DiscountCardState();
}

class _DiscountCardState extends State<DiscountCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.width * 0.03,
          left: MediaQuery.of(context).size.width * 0.03,
          right: MediaQuery.of(context).size.width * 0.03),
      decoration: BoxDecoration(
          color: MyColors.primaryLight, borderRadius: BorderRadius.circular(4)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.037,
              top: MediaQuery.of(context).size.width * 0.04,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("New Discounts",
                    style: TextStyle(
                      color: Color(0xffFFCE47),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                Text("20% Off on All\nProducts",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ))
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * 0.04,
            ),
            alignment: Alignment.bottomRight,
            child: SvgPicture.asset('assets/images/ellipseForHome.svg'),
          )
        ],
      ),
    );
  }
}

int selected = 0;

class CreateMenuOptions extends StatefulWidget {
  final ValueChanged<String> onFieldUpdated;
  CreateMenuOptions({this.onFieldUpdated});
  @override
  _CreateMenuOptionsState createState() => _CreateMenuOptionsState();
}

class _CreateMenuOptionsState extends State<CreateMenuOptions> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.03,
          // left: MediaQuery.of(context).size.width * 0.03,
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.148,
        child: ListView(scrollDirection: Axis.horizontal, children: [
          GestureDetector(
            onTap: () {
              setState(() {
                selected = 0;
                widget.onFieldUpdated("all");
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.025,
                    left: MediaQuery.of(context).size.width * 0.025,
                  ),
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.height * 0.08,
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                  decoration: BoxDecoration(
                    color: selected == 0 ? MyColors.primaryLight : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                      child: SvgPicture.asset(
                    'assets/images/menuAll.svg',
                    color: selected == 0 ? Colors.white : Color(0xff747474),
                  )),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Center(
                  child: Text("All",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        // color: Color(0xffc5c5c5),
                        color: selected == 0
                            ? MyColors.primaryLight
                            : Color(0xffc5c5c5),
                      )),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                selected = 1;
                widget.onFieldUpdated("Electrical supply store");
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.025,
                    left: MediaQuery.of(context).size.width * 0.025,
                  ),
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.height * 0.08,
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                  decoration: BoxDecoration(
                    // color: MyColors.primaryLight,
                    color: selected == 1 ? MyColors.primaryLight : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                      child: SvgPicture.asset(
                    'assets/images/menuHardware.svg',
                    color: selected == 1 ? Colors.white : Color(0xff747474),
                  )),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                // "Street\nFood"
                Text("Electrical",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: selected == 1
                          ? MyColors.primaryLight
                          : Color(0xffc5c5c5),
                      // color: MyColors.primaryLight,
                    ))
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                selected = 2;
                widget.onFieldUpdated("Only Vegan");
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.025,
                    left: MediaQuery.of(context).size.width * 0.025,
                  ),
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.height * 0.08,
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                  decoration: BoxDecoration(
                    // color: MyColors.primaryLight,
                    color: selected == 2 ? MyColors.primaryLight : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                      child: SvgPicture.asset(
                    'assets/images/menuVeg.svg',
                    color: selected == 2 ? Colors.white : Color(0xff747474),
                  )),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text("Only\nVegan",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: selected == 2
                          ? MyColors.primaryLight
                          : Color(0xffc5c5c5),
                      // color: MyColors.primaryLight,
                    ))
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                selected = 3;
                widget.onFieldUpdated("Hardware store");
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.025,
                    left: MediaQuery.of(context).size.width * 0.025,
                  ),
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.height * 0.08,
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                  decoration: BoxDecoration(
                    // color: MyColors.primaryLight,
                    color: selected == 3 ? MyColors.primaryLight : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                      child: SvgPicture.asset(
                    'assets/images/menuHardware.svg',
                    color: selected == 3 ? Colors.white : Color(0xff747474),
                  )),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text("Hardware",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: selected == 3
                          ? MyColors.primaryLight
                          : Color(0xffc5c5c5),
                      // color: MyColors.primaryLight,
                    ))
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                selected = 4;
                widget.onFieldUpdated("Pets");
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.025,
                    left: MediaQuery.of(context).size.width * 0.025,
                  ),
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.height * 0.08,
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                  decoration: BoxDecoration(
                    // color: MyColors.primaryLight,
                    color: selected == 4 ? MyColors.primaryLight : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                      child: SvgPicture.asset(
                    'assets/images/menuPet.svg',
                    color: selected == 4 ? Colors.white : Color(0xff747474),
                  )),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text("Pets",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: selected == 4
                          ? MyColors.primaryLight
                          : Color(0xffc5c5c5),
                      // color: MyColors.primaryLight,
                    ))
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                selected = 5;
                widget.onFieldUpdated("Home Garden");
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.025,
                    left: MediaQuery.of(context).size.width * 0.025,
                  ),
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.height * 0.08,
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                  decoration: BoxDecoration(
                    // color: MyColors.primaryLight,
                    color: selected == 5 ? MyColors.primaryLight : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                      child: SvgPicture.asset(
                    'assets/images/menuHomeGarden.svg',
                    color: selected == 5 ? Colors.white : Color(0xff747474),
                  )),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text("Home\nGarden",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: selected == 5
                          ? MyColors.primaryLight
                          : Color(0xffc5c5c5),
                      // color: MyColors.primaryLight,
                    ))
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                selected = 6;
                widget.onFieldUpdated("local stores");
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.025,
                    left: MediaQuery.of(context).size.width * 0.025,
                  ),
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.height * 0.08,
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                  decoration: BoxDecoration(
                    // color: MyColors.primaryLight,
                    color: selected == 6 ? MyColors.primaryLight : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                      child: SvgPicture.asset(
                    'assets/images/menuLocalStore.svg',
                    color: selected == 6 ? Colors.white : Color(0xff747474),
                  )),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Center(
                  child: Text("Local\nStores",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: selected == 6
                            ? MyColors.primaryLight
                            : Color(0xffc5c5c5),
                        // color: MyColors.primaryLight,
                      )),
                )
              ],
            ),
          ),
        ]));
  }
}

class StoreDisplay extends StatelessWidget {
  final myUid = FirebaseAuth.instance.currentUser.uid;
  final myName = FirebaseAuth.instance.currentUser.displayName;
  final String name, category, address, uid, email, timing, phoneNo;
  final rating;
  StoreDisplay(
      {this.name,
      this.phoneNo,
      this.timing,
      this.address,
      this.category,
      this.rating,
      this.uid,
      this.email});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () async {
      //   String code;
      //   if (uid.hashCode > myUid.hashCode)
      //     code = '$uid-$myUid';
      //   else
      //     code = '$myUid-$uid';
      //   if (uid.trim() == myUid) {
      //     Scaffold.of(context).showSnackBar(SnackBar(
      //       content: Text(
      //         "You cannot chat with yourself",
      //         style: TextStyle(color: Colors.white, fontFamily: 'Lato'),
      //       ),
      //       elevation: 0,
      //       duration: Duration(milliseconds: 1000),
      //       backgroundColor: MyColors.primaryLight,
      //       shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.only(
      //               topRight: Radius.circular(5), topLeft: Radius.circular(5))),
      //     ));
      //   } else {
      //     DocumentSnapshot doc = await FirebaseFirestore.instance
      //         .collection('ongoing')
      //         .doc(myUid)
      //         .collection(myUid)
      //         .doc(code)
      //         .get();
      //     if (!doc.exists) {
      //       FirebaseFirestore.instance
      //           .collection('ongoing')
      //           .doc(myUid)
      //           .collection(myUid)
      //           .doc(code)
      //           .set({
      //         'msg': "Click to start chatting",
      //         'uid': myUid,
      //         'otherUid': uid,
      //         'time': DateTime.now(),
      //         'name': name,
      //         'img': null,
      //       });
      //       FirebaseFirestore.instance
      //           .collection('ongoing')
      //           .doc(uid)
      //           .collection(uid)
      //           .doc(code)
      //           .set({
      //         'msg': null,
      //         'uid': uid,
      //         'otherUid': myUid,
      //         'time': DateTime.now(),
      //         'name': myName,
      //         'img': null,
      //       });
      //     }
      //     Navigator.of(context).push(MaterialPageRoute(
      //         builder: (context) => Chat(
      //               code: code,
      //               email: email,
      //               name: name,
      //               uid: uid,
      //               img: null,
      //               myUid: myUid,
      //             )));
      //   }
      // },
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ViewStores(
                name, phoneNo, timing, address, category, rating, uid)));
      },
      child: Container(
        // padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.028),
        margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.height * 0.02,
          right: MediaQuery.of(context).size.height * 0.02,
          bottom: MediaQuery.of(context).size.height * 0.02,
        ),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.01),
            blurRadius: 4.0,
            spreadRadius: 5.0,
            offset: Offset(
              0.0,
              0.0,
            ),
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Color(0xffc5c5c5),
              ),
              height: MediaQuery.of(context).size.height * 0.17,
            ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.02,
            // ),
            Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.028),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                        color: Color(0xff292929),
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  Text(
                    category,
                    style: TextStyle(
                        color: Color(0xff858585),
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  Row(
                    children: [
                      RatingBar(
                          itemSize: 25,
                          onRatingUpdate: null,
                          initialRating: rating.toDouble(),
                          allowHalfRating: true,
                          itemBuilder: (context, _) => SvgPicture.asset(
                                'assets/images/starForHome.svg',
                              )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Text(rating.toDouble().toString())
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/locationForProfile.svg',
                        color: Color(0xff292929),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Flexible(
                          child: Text(
                        address,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff858585)),
                      ))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

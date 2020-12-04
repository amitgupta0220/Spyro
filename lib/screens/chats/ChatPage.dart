import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smackit/Styles.dart';

class ChatPage extends StatefulWidget {
  final String type;
  ChatPage({this.type});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  DateFormat timeFormat = DateFormat.jm();
  User _user;
  // String type;
  var uid;
  getUser() async {
    _user = _auth.currentUser;
    uid = _user.uid;
    // final userDoc = await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(_user.email)
    //     .get();
    // type = userDoc.data()['userType'] == 'customer' ? 'users' : 'seller';
    setState(() {});
    // print("this is type" + _user.email);
  }

  @override
  void initState() {
    // getUser();
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        elevation: 0,
        backgroundColor: MyColors.primaryLight,
        title: Container(
          margin:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.2),
          child: Text('Chats',
              style: TextStyle(color: Colors.white, fontSize: 22)),
        ),
      ),
      backgroundColor: MyColors.primary,
      body: Container(
        // margin: EdgeInsets.only(left: 16, right: 16),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('ongoing')
              .doc(uid)
              .collection(uid)
              .snapshots(),
          builder: (context, snapshot) {
            List<Widget> userList = [];
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              // print('got data');

              final users = snapshot.data.docs;
              for (var user in users) {
                var img = user.data()['img'];
                var uid = user.data()['uid'];
                var name = user.data()['name'];
                var type = user.data()['userType'];
                var msg = user.data()['msg'];
                Timestamp time = user.data()['time'];
                var uidOfOther = user.data()['otherUid'];
                if (uidOfOther != uid && uid != null) {
                  // FirebaseFirestore.instance
                  //     .collection('ongoing')
                  //     .doc(uid)
                  //     .collection(uid)
                  //     .doc(
                  //         'vljU4mqkpEX7oLX6nP2aSAkPPQN2-0aMRlnKCo1bWkOkg1BueSl8SXEH2')
                  //     .update({'time': DateTime.now()});

                  DateTime timeData = DateTime.fromMillisecondsSinceEpoch(
                          time.millisecondsSinceEpoch)
                      .add(Duration(hours: 5, minutes: 30));
                  print(timeData);
                  userList.add(UserDisplay(
                    uid: uid,
                    uidOfOther: uidOfOther,
                    img: img,
                    name: name,
                    time: timeFormat.format(timeData),
                    msg: msg,
                  ));
                }
              }
              return ListView(
                children: userList,
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class UserDisplay extends StatelessWidget {
  final String msg, time, name, uid, uidOfOther, img, type, email, otherEmail;
  UserDisplay(
      {this.msg,
      this.time,
      this.name,
      this.uid,
      this.uidOfOther,
      this.img,
      this.email,
      this.type,
      this.otherEmail});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.01),
            blurRadius: 4.0,
            spreadRadius: 5.0,
            offset: Offset(
              0.0,
              0.0,
            ),
          )
        ],
      ),
      // height: MediaQuery.of(context).size.height * 0.15,
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.028),
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.height * 0.02,
        right: MediaQuery.of(context).size.height * 0.02,
        top: MediaQuery.of(context).size.height * 0.02,
      ),
      child: InkWell(
        onTap: () async {
          String code;
          if (uidOfOther.hashCode > uid.hashCode)
            code = '$uidOfOther-$uid';
          else
            code = '$uid-$uidOfOther';
          // await FirebaseFirestore.instance
          //     .collection('chats')
          //     .doc(code)
          //     .collection(code)
          //     .get()
          //     .then((value) => print(value.toString()));
          // print(code);
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
              "Dummy details",
              style: TextStyle(color: Colors.white, fontFamily: 'Lato'),
            ),
            elevation: 0,
            duration: Duration(milliseconds: 1000),
            backgroundColor: MyColors.primaryLight,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5), topLeft: Radius.circular(5))),
          ));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: img != null ? null : Color(0xffe7e7e7),
                  backgroundImage: img != null ? NetworkImage(img) : null,
                  radius: 25,
                  child: img != null
                      ? null
                      : Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.height * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            color: Color(0xff292929),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Text(
                        msg,
                        style: TextStyle(
                            color: Color(0xff9b9b9b),
                            fontSize: 12,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(time,
                style: TextStyle(
                    color: Color(0xff858585),
                    fontSize: 12,
                    fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}

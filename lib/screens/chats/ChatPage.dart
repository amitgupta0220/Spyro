import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:smackit/Styles.dart';
import 'package:smackit/screens/chats/Chat.dart';

class ChatPage extends StatefulWidget {
  final String type, uid;
  ChatPage({this.type, this.uid});
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
    // getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: Container(),
      //   elevation: 0,
      //   backgroundColor: MyColors.primaryLight,
      //   title: Container(
      //     margin:
      //         EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.18),
      //     child: Text('Chats',
      //         style: TextStyle(color: Colors.white, fontSize: 22)),
      //   ),
      // ),
      backgroundColor: MyColors.primary,
      body: Container(
        // margin: EdgeInsets.only(left: 16, right: 16),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('ongoing')
              .doc(widget.uid)
              .collection(widget.uid)
              .orderBy('time', descending: true)
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
                var count = user.data()['count'];
                if (uidOfOther != uid && uid != null && msg != null) {
                  // FirebaseFirestore.instance
                  //     .collection('ongoing')
                  //     .doc(uid)
                  //     .collection(uid)
                  //     .doc(
                  //         'vljU4mqkpEX7oLX6nP2aSAkPPQN2-0aMRlnKCo1bWkOkg1BueSl8SXEH2')
                  //     .update({'time': DateTime.now()});

                  DateTime timeData = DateTime.fromMillisecondsSinceEpoch(
                      time.millisecondsSinceEpoch);
                  // .add(Duration(hours: 5, minutes: 30));
                  print(timeData);
                  userList.add(UserDisplay(
                    count: count,
                    uid: uid.toString().trim(),
                    uidOfOther: uidOfOther.toString().trim(),
                    img: img,
                    name: name,
                    time: Jiffy(timeData, "yyyy-MM-dd").fromNow(),
                    // time: timeFormat.format(timeData),
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
  final int count;
  UserDisplay(
      {this.msg,
      this.count,
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
    return Stack(
      children: [
        Container(
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
          width: MediaQuery.of(context).size.width,
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
              DocumentSnapshot doc = await FirebaseFirestore.instance
                  .collection('ongoing')
                  .doc(uid)
                  .collection(uid)
                  .doc(code)
                  .get();
              if (!doc.exists) {
                FirebaseFirestore.instance
                    .collection('ongoing')
                    .doc(uid)
                    .collection(uid)
                    .doc(code)
                    .set({
                  'msg': "Click to start chatting",
                  'uid': uid,
                  'otherUid': uidOfOther,
                  'time': DateTime.now(),
                  'name': name,
                  'img': img,
                  'count': 0,
                });
              } else {
                print(code);
              }
              //     .then((value) => print(value.toString()));

              // Scaffold.of(context).showSnackBar(SnackBar(
              //   content: Text(
              //     "Dummy details",
              //     style: TextStyle(color: Colors.white, fontFamily: 'Lato'),
              //   ),
              //   elevation: 0,
              //   duration: Duration(milliseconds: 1000),
              //   backgroundColor: MyColors.primaryLight,
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.only(
              //           topRight: Radius.circular(5), topLeft: Radius.circular(5))),
              // ));
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Chat(
                        code: code,
                        email: email,
                        name: name,
                        uid: uidOfOther,
                        img: img,
                        myUid: uid,
                      )));
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
                    Container(
                      width: MediaQuery.of(context).size.width -
                          MediaQuery.of(context).size.height * 0.28,
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
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
                            overflow: TextOverflow.ellipsis,
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
                Flexible(
                  child: Text(time,
                      // overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Color(0xff858585),
                          fontSize: 10,
                          fontWeight: FontWeight.w400)),
                ),
              ],
            ),
          ),
        ),
        Positioned(
            right: 8,
            top: 8,
            child: count == 0
                ? Container()
                : Container(
                    decoration: BoxDecoration(
                        color: MyColors.primaryLight, shape: BoxShape.circle),
                    height: MediaQuery.of(context).size.width * 0.08,
                    width: MediaQuery.of(context).size.width * 0.08,
                    child: Center(
                      child: Text(count.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  )),
      ],
    );
  }
}

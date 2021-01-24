import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:smackit/Styles.dart';
import 'package:smackit/screens/chats/GroupChat.dart';

class GroupChatPage extends StatefulWidget {
  final String type, uid, userName;
  GroupChatPage({this.type, this.uid, this.userName});
  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  DateFormat timeFormat = DateFormat.jm();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.primary,
        body: Container(
            // margin: EdgeInsets.only(left: 16, right: 16),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('group_chat')
                    // .where('participants', arrayContains: widget.uid)
                    .orderBy('last_msg_time', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  List<Widget> userList = [];
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    final users = snapshot.data.docs;
                    for (var user in users) {
                      if (user.data()['participants'].contains(widget.uid)) {
                        String code = user.id.toString();
                        var groupName = user.data()['group_name'];
                        var lastMsg = user.data()['last_msg'];
                        Timestamp lastMsgTime = user.data()['last_msg_time'];
                        var lastMsgBy = user.data()['last_msg_by'];
                        var lastMsgByName = user.data()['last_msg_by_name'];
                        DateTime timeData = DateTime.fromMillisecondsSinceEpoch(
                            lastMsgTime.millisecondsSinceEpoch);
                        userList.add(UserDisplay(
                            lastMsgByName: lastMsgByName,
                            msg: lastMsg,
                            name: groupName,
                            time: Jiffy(timeData, "yyyy-MM-dd").fromNow(),
                            // timeFormat.format(timeData),
                            uid: lastMsgBy,
                            myUid: widget.uid,
                            userName: widget.userName,
                            code: code));
                      }
                    }
                    return ListView(
                      children: userList,
                      reverse: false,
                    );
                  }
                  return (Center(child: Text("No Chats")));
                })));
  }
}

class UserDisplay extends StatelessWidget {
  final String lastMsgByName, myUid, msg, time, name, uid, code, userName;
  UserDisplay({
    this.userName,
    this.code,
    this.lastMsgByName,
    this.myUid,
    this.msg,
    this.time,
    this.name,
    this.uid,
  });

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
            onLongPress: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text(
                          "Delete this group?",
                          style: TextStyle(fontFamily: 'Lato'),
                        ),
                        actions: <Widget>[
                          Row(
                            children: <Widget>[
                              FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("No",
                                      style: TextStyle(fontFamily: 'Lato'))),
                              SizedBox(
                                height: 50,
                              ),
                              FlatButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection("group_chat")
                                        .doc(code)
                                        .delete();
                                    Navigator.pop(context);
                                  },
                                  child: Text("Yes",
                                      style: TextStyle(fontFamily: 'Lato')))
                            ],
                          )
                        ],
                      ));
            },
            onTap: () async {
              // print(userName);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GroupChat(
                        userName: userName,
                        code: code,
                        myUid: myUid,
                        name: name,
                        uid: uid,
                      )));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xffe7e7e7),
                      radius: 25,
                      child: Icon(
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
                            uid == myUid
                                ? "You: " + msg
                                : lastMsgByName.isEmpty
                                    ? msg
                                    : lastMsgByName + ": " + msg,
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
        // Positioned(
        //       right: 0,
        //       top: 0,
        //       child: count == 0
        //           ? Container()
        //           : Container(
        //               decoration: BoxDecoration(
        //                   color: MyColors.primaryLight, shape: BoxShape.circle),
        //               height: MediaQuery.of(context).size.width * 0.08,
        //               width: MediaQuery.of(context).size.width * 0.08,
        //               child: Center(
        //                 child: Text(count.toString(),
        //                     style: TextStyle(color: Colors.white, fontSize: 12)),
        //               ),
        //             )),
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smackit/Styles.dart';
import 'package:smackit/screens/chats/ChatBubble.dart';

class GroupChat extends StatefulWidget {
  final String name, uid, myUid, code, userName;
  GroupChat({this.name, this.uid, this.myUid, this.userName, this.code});
  @override
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  String message;
  int i = 0;
  bool isMe;
  final _replyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE5E5E5),
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width * 0.11,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.043),
                child: SvgPicture.asset("assets/images/arrowWhite.svg"))),
        backgroundColor: MyColors.primaryLight,
        elevation: 0,
        title: Container(
          margin:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.04),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // CircleAvatar(
              //   backgroundColor: Color(0xffe7e7e7),
              //   radius: MediaQuery.of(context).size.width * 0.045,
              //   child: Icon(
              //     Icons.person,
              //     color: Colors.grey,
              //   ),
              // ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Flexible(
                child: Text(widget.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 22)),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
              color: Color(0xffE5E5E5),
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.1),
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('group_chat')
                      .doc(widget.code)
                      .collection("chats")
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData) {
                      // FirebaseFirestore.instance
                      //     .collection("ongoing")
                      //     .doc(widget.myUid)
                      //     .collection(widget.myUid)
                      //     .doc(widget.code)
                      //     .update({'count': 0});
                      List<Widget> messageWidgets = [];
                      final messages = snapshot.data.docs;
                      for (var message in messages) {
                        final String user = message.data()['uid'];
                        isMe = (user == widget.myUid);
                        final String msg = message.data()['msg'];
                        final String msgBy = message.data()['msg_by'];
                        final time = message.data()['time'];
                        // if (i == 0) {
                        //   FirebaseFirestore.instance
                        //       .collection("ongoing")
                        //       .doc(widget.myUid)
                        //       .collection(widget.myUid)
                        //       .doc(widget.code)
                        //       .update({'msg': msg, 'time': time});
                        // }
                        // i++;
                        if (msg != null) {
                          // print(msg);
                          messageWidgets.add(isMe
                              ? SenderChatBubble(
                                  isMessage: true,
                                  text: msg,
                                  time: time,
                                )
                              : ReceiverChatBubble(
                                  senderName: msgBy,
                                  isMessage: true,
                                  text: msg,
                                  time: time,
                                ));
                        }
                      }
                      return ListView(
                        children: messageWidgets,
                        reverse: true,
                      );
                    }
                    return Container();
                  })),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.height * 0.02,
                right: MediaQuery.of(context).size.height * 0.02,
                bottom: MediaQuery.of(context).size.height * 0.02,
              ),
              height: MediaQuery.of(context).size.height * 0.08,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(64),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.05),
                      blurRadius: 8.0,
                      spreadRadius: 1.0,
                      offset: Offset(
                        0.0,
                        0.0,
                      )),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                      flex: 5,
                      child: Container(
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * 0.02,
                        ),
                        child: TextFormField(
                          onChanged: (msg) {
                            message = msg;
                          },
                          // maxLines: 10,
                          // maxLengthEnforced: false,
                          textCapitalization: TextCapitalization.sentences,
                          controller: _replyController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 14,
                                color: Color(0xff9B9B9B),
                                fontWeight: FontWeight.w400),
                            hintText: 'Send a message',
                          ),
                        ),
                      )),
                  Flexible(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () async {
                          if (message != '') {
                            _replyController.clear();
                            FirebaseFirestore.instance
                                .collection('group_chat')
                                .doc(widget.code)
                                .collection("chats")
                                .add({
                              'msg': message,
                              'uid': widget.myUid,
                              'time': DateTime.now(),
                              'msg_by': widget.userName,
                              // 'isMessage': true,
                            });
                            FirebaseFirestore.instance
                                .collection('group_chat')
                                .doc(widget.code)
                                .update({
                              'last_msg': message,
                              'last_msg_time': DateTime.now(),
                              'last_msg_by': widget.myUid,
                              'last_msg_by_name':
                                  widget.userName, //something name
                            });
                            message = "";
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            right: MediaQuery.of(context).size.height * 0.01,
                          ),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: MyColors.primary),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.arrow_forward_ios_outlined),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ReceiverChatBubble extends StatelessWidget {
  ReceiverChatBubble(
      {this.text, this.time, this.image, this.isMessage, this.senderName});
  final String text, image, senderName;
  final Timestamp time;
  final bool isMessage;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: ModifiedChatBubble(
        elevation: 0,
        // elevation: 20,
        clipper: ChatBubbleClipper5(type: BubbleType.receiverBubble),
        backGroundColor: Color(0xffF7F7F7),
        margin: EdgeInsets.only(top: 3),
        child: Padding(
          padding: EdgeInsets.only(left: isMessage ? 10 : 8),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: isMessage
                ? Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          senderName,
                          style: TextStyle(
                              color: MyColors.primaryLight, fontFamily: 'Lato'),
                        ),
                        Text(
                          text,
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'Lato'),
                        ),
                      ],
                    ),
                  )
                : InkWell(
                    onTap: () {
                      // customDialog(context, image);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(1),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Card(
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Image(
                              image: NetworkImage(image),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class SenderChatBubble extends StatelessWidget {
  SenderChatBubble({this.text, this.time, this.isMessage, this.image});
  final String text, image;
  final Timestamp time;
  final bool isMessage;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: ModifiedChatBubble(
        // elevation: 20,
        clipper: ChatBubbleClipper5(type: BubbleType.sendBubble),
        alignment: Alignment.centerRight,
        backGroundColor: MyColors.primaryLight,
        child: Padding(
          padding: EdgeInsets.only(right: isMessage ? 10 : 8),
          child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: isMessage
                  ? Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        text,
                        style:
                            TextStyle(color: Colors.white, fontFamily: 'Lato'),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        // customDialog(context, image);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(1),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.35,
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Card(
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: Image(
                                image: NetworkImage(image),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )),
        ),
      ),
    );
  }
}

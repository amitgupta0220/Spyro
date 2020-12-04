import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smackit/models/User.dart';

import '../../Styles.dart';

class ChatScreen extends StatefulWidget {
  final DocumentReference chatRef;
  ChatScreen({Key key, @required this.chatRef}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Group Chat'),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: widget.chatRef
                .collection('chat')
                .orderBy('created_at', descending: true)
                .snapshots(),
            builder: (_, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              List<DocumentSnapshot> msgs = snapshot.data.documents;
              return Column(children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemBuilder: (_, index) => ChatBubble(msg: msgs[index]),
                    itemCount: msgs.length,
                  ),
                ),
                MessageInput(chatDoc: widget.chatRef),
              ]);
            }));
  }
}

class ChatBubble extends StatelessWidget {
  final DocumentSnapshot msg;
  const ChatBubble({Key key, @required this.msg}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bool isMe =
        msg.data()["sender"] == CurrentUser.user.email ? true : false;
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width * 0.2,
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
                color: isMe ? MyColors.primary : null,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(isMe ? 0 : 15),
                  bottomLeft: Radius.circular(!isMe ? 0 : 15),
                  topLeft: Radius.circular(15),
                ),
                border: Border.all(color: MyColors.primary, width: 1)),
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    if (!isMe)
                      Text(
                        msg.data()['sender_name'],
                        style: TextStyle(
                          color: MyColors.secondary,
                          fontSize: 16,
                        ),
                      ),
                    Text(
                      msg.data()['message'],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 5),
                Text(
                  DateFormat('hh:mm a').format(
                      DateTime.fromMillisecondsSinceEpoch(
                          msg.data()['created_at'].seconds * 1000)),
                  style: TextStyle(
                      color: MyColors.secondary,
                      fontSize: 12,
                      fontFamily: 'Roboto'),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MessageInput extends StatefulWidget {
  final DocumentReference chatDoc;
  MessageInput({@required this.chatDoc});
  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  bool _empty = true;
  final _controller = TextEditingController();
  String name;
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance()
        .then((prefs) => name = prefs.getString('uname'));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 12),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(35),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
              child: LimitedBox(
            maxHeight: 300,
            child: new Scrollbar(
              child: new SingleChildScrollView(
                scrollDirection: Axis.vertical,
                reverse: true,
                child: TextField(
                  minLines: 1,
                  maxLines: 4,
                  autofocus: false,
                  onChanged: (value) {
                    if (value.isEmpty)
                      setState(() => _empty = true);
                    else
                      setState(() => _empty = false);
                  },
                  controller: _controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Type a message",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          )),
          IconButton(
              icon: Icon(
                Icons.add,
                color: MyColors.secondary,
              ),
              onPressed: () {}),
          IconButton(
            icon: Icon(
              Icons.send,
              color: _empty ? Colors.grey : MyColors.secondary,
            ),
            onPressed: () => _empty ? null : _send(context),
          ),
        ],
      ),
    );
  }

  void _send(BuildContext context) async {
    print('sending');
    final email = CurrentUser.user.email;
    var msg = _controller.text;
    _controller.clear();
    setState(() => _empty = true);
    try {
      final Map<String, dynamic> msgDoc = {
        'message': msg,
        'message_type': 'text',
        'sender_name': name,
        'sender': email,
        'created_at': Timestamp.fromDate(DateTime.now())
      };
      final doc = await widget.chatDoc.collection('chat').add(msgDoc);
      await widget.chatDoc.set({'last_msg': msgDoc}, SetOptions(merge: true));
      print('sent ${doc.id}');
    } catch (e) {
      print('error: $e');
    }
  }
}

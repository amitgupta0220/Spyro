import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smackit/models/User.dart';

import '../../Styles.dart';
import 'ChatScreen.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Smackenger'),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('chats').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              List<DocumentSnapshot> chats = snapshot.data.documents;
              return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (_, index) {
                    Map<String, dynamic> chat = chats[index].data();
                    Map<String, dynamic> lastMsg = chat['last_msg'];
                    return Card(
                      color: MyColors.primaryLight,
                      elevation: 5,
                      child: ListTile(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => ChatScreen(
                                      chatRef: chats[index].reference))),
                          leading: CircleAvatar(
                            backgroundColor: MyColors.primary,
                            child: Icon(Icons.group, color: Colors.black),
                          ),
                          title: Text(chat['chat_name']),
                          subtitle: RichText(
                            text: TextSpan(
                                text:
                                    lastMsg['sender'] == CurrentUser.user.email
                                        ? 'You: '
                                        : '${lastMsg['sender_name']}: ',
                                style: TextStyle(color: MyColors.secondary),
                                children: [TextSpan(text: lastMsg['message'])]),
                          ),
                          trailing: Text(
                            DateFormat('hh:mm a').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    lastMsg['created_at'].seconds * 1000)),
                            style: TextStyle(
                                color: MyColors.secondary,
                                fontFamily: 'Roboto'),
                          )),
                    );
                  });
            }));
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smackit/Styles.dart';
import 'package:smackit/screens/chats/ChatPage.dart';
import 'package:smackit/screens/chats/GroupChatPage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smackit/screens/chats/CreateGroup.dart';

class NavChat extends StatefulWidget {
  final String type, uid;
  NavChat({this.type, this.uid});
  @override
  _NavChatState createState() => _NavChatState();
}

class _NavChatState extends State<NavChat> with SingleTickerProviderStateMixin {
  TabController tabController;
  String userName;
  int _currentIndex = 0;

  @override
  void initState() {
    userName = FirebaseAuth.instance.currentUser.displayName;
    super.initState();
    tabController = new TabController(vsync: this, length: 3);
    tabController.addListener(_tabSelect);
  }

  void _tabSelect() {
    setState(() {
      _currentIndex = tabController.index;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  // showDialogForAddingGroup() {
  //   return showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //             title: Text(
  //               "Create Group",
  //               style: TextStyle(fontSize: 16),
  //             ),
  //             scrollable: true,
  //             content: Column(
  //               children: [
  //                 Row(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     SvgPicture.asset('assets/images/userForProfile.svg'),
  //                     SizedBox(
  //                       width: MediaQuery.of(context).size.width * 0.02,
  //                     ),
  //                     Flexible(
  //                       child: TextFormField(
  //                         controller: _nameController,
  //                         // autocorrect: _autoValidate,
  //                         // style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
  //                         keyboardType: TextInputType.name,
  //                         // onSaved: (value) => _email = value.trim(),
  //                         validator: (value) {
  //                           if (value.isEmpty || value.length < 3)
  //                             return "Enter a valid name";
  //                           return null;
  //                         },
  //                         decoration: InputDecoration(
  //                           hintStyle: TextStyle(
  //                               fontSize: 14, color: Color(0xff9D9D9D)),
  //                           hintText: 'Name of your Group',
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 SafeArea(
  //                   child: Text("hi"),
  //                 )
  //               ],
  //             ),
  //           ));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Container(),
          elevation: 0,
          backgroundColor: MyColors.primaryLight,
          title: Container(
            margin:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.18),
            child: Text('Chats',
                style: TextStyle(color: Colors.white, fontSize: 22)),
          ),
          actions: [
            _currentIndex == 1
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CreateGroup(
                                  myUid: widget.uid,
                                )));
                      },
                      child: SvgPicture.asset(
                        "assets/images/createGroup.svg",
                        color: Colors.white,
                      ),
                    ),
                  )
                : Container()
          ],
        ),
        backgroundColor: Color(0xffE5E5E5),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.height * 0.028,
                  right: MediaQuery.of(context).size.height * 0.028,
                  top: MediaQuery.of(context).size.height * 0.028,
                ),
                child: TabBar(
                  onTap: (number) {
                    // setState(() {});
                  },
                  indicatorColor: Colors.white,
                  indicator: BoxDecoration(
                    color: MyColors.primaryLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  indicatorWeight: 0.2,
                  controller: tabController,
                  // labelStyle: TextStyle(color: Colors.white),
                  // indicatorColor: Colors.white,
                  tabs: <Widget>[
                    Container(
                      child: Tab(
                          iconMargin: EdgeInsets.all(0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SvgPicture.asset(
                                  "assets/images/chatGroupChat.svg",
                                  color: tabController.index == 0
                                      ? Colors.white
                                      : Colors.black),
                              Text(
                                "Direct",
                                style: TextStyle(
                                    color: tabController.index == 0
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ],
                          )),
                    ),
                    Container(
                      child: Tab(
                          iconMargin: EdgeInsets.all(0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SvgPicture.asset(
                                  "assets/images/groupGroupChat.svg",
                                  color: tabController.index == 1
                                      ? Colors.white
                                      : Colors.black),
                              Text(
                                "Groups",
                                style: TextStyle(
                                    color: tabController.index == 1
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ],
                          )),
                    ),
                    Container(
                      child: Tab(
                          iconMargin: EdgeInsets.all(0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SvgPicture.asset(
                                  "assets/images/topicsGroupChat.svg",
                                  color: tabController.index == 2
                                      ? Colors.white
                                      : Colors.black),
                              Text(
                                "Topics",
                                style: TextStyle(
                                    color: tabController.index == 2
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    ChatPage(
                      type: widget.type,
                      uid: widget.uid,
                    ),
                    GroupChatPage(
                      userName: userName,
                      type: widget.type,
                      uid: widget.uid,
                    ),
                    Container()
                  ],
                  controller: tabController,
                ),
              )
            ],
          ),
        ));
  }
}

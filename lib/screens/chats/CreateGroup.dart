import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:smackit/Styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:smackit/widgets/EmojiPicker.dart';

class CreateGroup extends StatefulWidget {
  final String myUid;
  CreateGroup({this.myUid});
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  DateFormat timeFormat = DateFormat.jm();
  final _nameController = TextEditingController();
  final _searchController = TextEditingController();
  bool _autoValidate = false;
  List<Widget> searchList = [];
  List<Widget> onGoingList = [];
  bool isEmojiVisible = false;
  bool isKeyBoardVisible = false;
  final focusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    if (UserList.list != null) {
      UserList.list.clear();
    }
  }

  @override
  void initState() {
    onGoingListSearch();
    super.initState();
    KeyboardVisibility.onChange.listen((bool isKeyBoardVisible) {
      setState(() {
        this.isKeyBoardVisible = isKeyBoardVisible;
      });
      if (isKeyBoardVisible && isEmojiVisible) {
        setState(() {
          isEmojiVisible = false;
        });
      }
    });
    // UserList.list.clear();
  }

  onGoingListSearch() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('ongoing')
        .doc(widget.myUid)
        .collection(widget.myUid)
        .orderBy('time', descending: true)
        .get()
        .then((value) {
      value.docs.forEach((element) => {
            if (element.data().isNotEmpty)
              {
                onGoingList.add(UserDisplay(
                  name: element.data()['name'],
                  uid: widget.myUid,
                  uidOfOther: element.data()['otherUid'],
                ))
              }
          });
      setState(() {});
      return null;
    });
  }

  searchForEmail(String value) {
    setState(() {
      searchList.clear();
    });
    FirebaseFirestore instance = FirebaseFirestore.instance;
    final snap = instance.collection("users").doc(value).get().then((doc) {
      if (doc.exists) {
        if (doc.data()['uid'] == widget.myUid) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              "You cannot add youself",
              style: TextStyle(color: Colors.white, fontFamily: 'Lato'),
            ),
            elevation: 0,
            duration: Duration(milliseconds: 1000),
            backgroundColor: MyColors.primaryLight,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5), topLeft: Radius.circular(5))),
          ));
        } else {
          if (UserList.list.contains(doc.data()['uid'])) {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text(
                "Already added this user",
                style: TextStyle(color: Colors.white, fontFamily: 'Lato'),
              ),
              elevation: 0,
              duration: Duration(milliseconds: 1000),
              backgroundColor: MyColors.primaryLight,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      topLeft: Radius.circular(5))),
            ));
          } else {
            print("here");
            searchList.add(UserDisplay(
              img: null,
              name: doc.data()['name'],
              uid: widget.myUid,
              uidOfOther: doc.data()['uid'],
            ));
            setState(() {});
          }
        }
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            "No user found",
            style: TextStyle(color: Colors.white, fontFamily: 'Lato'),
          ),
          elevation: 0,
          duration: Duration(milliseconds: 1000),
          backgroundColor: MyColors.primaryLight,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5), topLeft: Radius.circular(5))),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // floatingActionButton: FloatingActionButton(
      //   elevation: 0,
      //   backgroundColor: MyColors.bg,
      //   tooltip: "Continue",
      //   onPressed: () async {
      //     UserList.list.add(widget.myUid);
      //     print(UserList.list);
      //     if (_formKey.currentState.validate() && UserList.list != null) {
      //       if (UserList.list.length >= 3) {
      //         DocumentReference doc = await FirebaseFirestore.instance
      //             .collection('group_chat')
      //             .add({
      //           "created_by": widget.myUid,
      //           "created_on": DateTime.now(),
      //           "group_name": _nameController.text,
      //           "last_msg": "Tap to start conversation",
      //           "last_msg_by": "",
      //           "last_msg_by_name": "",
      //           "last_msg_time": DateTime.now(),
      //           "participants": FieldValue.arrayUnion(UserList.list),
      //         });
      //         await FirebaseFirestore.instance
      //             .collection("group_chat")
      //             .doc(doc.id)
      //             .collection("chats")
      //             .add({
      //           "msg": null,
      //           "msg_by": "",
      //           "time": DateTime.now(),
      //           "uid": widget.myUid
      //         });
      //         UserList.list.clear();
      //         Navigator.of(context).pop();
      //       } else {
      //         _scaffoldKey.currentState.showSnackBar(SnackBar(
      //           content: Text(
      //             "Select atleast 2 members",
      //             style: TextStyle(color: Colors.white, fontFamily: 'Lato'),
      //           ),
      //           elevation: 0,
      //           duration: Duration(milliseconds: 1500),
      //           backgroundColor: MyColors.primaryLight,
      //           shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.only(
      //                   topRight: Radius.circular(5),
      //                   topLeft: Radius.circular(5))),
      //         ));
      //         UserList.list.clear();
      //       }
      //     } else {
      //       setState(() {
      //         _autoValidate = true;
      //       });
      //       UserList.list.clear();
      //     }
      //   },
      //   child: Icon(Icons.keyboard_arrow_right),
      // ),
      backgroundColor: MyColors.primary,
      appBar: AppBar(
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: GestureDetector(
        //         child: Icon(
        //       Icons.search,
        //       color: Colors.white,
        //     )),
        //   )
        // ],
        leadingWidth: MediaQuery.of(context).size.width * 0.11,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.035),
                child: SvgPicture.asset("assets/images/arrowWhite.svg"))),
        elevation: 0,
        backgroundColor: MyColors.primaryLight,
        title: Container(
          margin:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.18),
          child: GestureDetector(
            onTap: () {
              setState(() {});
            },
            child: Text('Create group',
                style: TextStyle(color: Colors.white, fontSize: 22)),
          ),
        ),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Container(
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
                  // padding: EdgeInsets.all(
                  //     MediaQuery.of(context).size.height * 0.028),
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.height * 0.02,
                    right: MediaQuery.of(context).size.height * 0.02,
                    top: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => _showPicker(context),
                        child: Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.height * 0.01),
                          child: CircleAvatar(
                              backgroundColor: Color(0xfff1f1f1),
                              backgroundImage: _image == null
                                  ? null
                                  : AssetImage(_image.path),
                              radius: 25,
                              child: _image == null
                                  ? SvgPicture.asset(
                                      "assets/images/setGroupIcon.svg")
                                  // : Image.asset(
                                  //     _image.path,
                                  //     fit: BoxFit.contain,
                                  //     width: MediaQuery.of(context).size.width *
                                  //         0.08,
                                  //   ),
                                  : Container()),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.028),
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: TextFormField(
                          focusNode: focusNode,
                          controller: _nameController,
                          autocorrect: _autoValidate,
                          // style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          // onSaved: (value) => _email = value.trim(),
                          validator: (value) {
                            if (value.isEmpty || value.length < 3)
                              return "Enter a valid name";
                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color(0xff9D9D9D)),
                            hintText: 'Enter Group Name here..',
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          onClickedEmoji();
                        },
                        child: Container(
                          child: isEmojiVisible
                              ? Icon(Icons.keyboard)
                              : SvgPicture.asset(
                                  'assets/images/emojiPickerIcon.svg'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.height * 0.028,
                  top: MediaQuery.of(context).size.height * 0.028,
                  bottom: MediaQuery.of(context).size.height * 0.028,
                ),
                child: Text(
                  "*Select atleast 2 members",
                  style: TextStyle(
                      color: MyColors.bg,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                // height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  onFieldSubmitted: (value) {
                    searchForEmail(_searchController.text.trim().toLowerCase());
                  },
                  controller: _searchController,
                  autocorrect: _autoValidate,
                  // style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  // onSaved: (value) => _email = value.trim(),
                  validator: (value) {
                    if (value.isEmpty || value.length < 3)
                      return "Enter a valid email";
                    return null;
                  },
                  decoration: InputDecoration(
                      prefixIcon: GestureDetector(
                          onTap: () {
                            if (_searchController.text.trim().isNotEmpty)
                              searchForEmail(
                                  _searchController.text.trim().toLowerCase());
                            else
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text(
                                  "Enter valid email",
                                  style: TextStyle(
                                      color: Colors.white, fontFamily: 'Lato'),
                                ),
                                elevation: 0,
                                duration: Duration(milliseconds: 1000),
                                backgroundColor: MyColors.primaryLight,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        topLeft: Radius.circular(5))),
                              ));
                          },
                          child: Icon(Icons.search)),
                      // suffixIcon: GestureDetector(
                      //     onTap: () {
                      //       if (_searchController.text.trim().isNotEmpty)
                      //         searchForEmail(
                      //             _searchController.text.trim().toLowerCase());
                      //     },
                      //     child: Icon(Icons.search)),

                      filled: true,
                      fillColor: Colors.white,
                      hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff9D9D9D)),
                      hintText: 'Search for people to add using email',
                      enabledBorder: UnderlineInputBorder()),
                ),
              ),
              buildSearchList(),
              buildOnGoingList(),
              // StreamBuilder<QuerySnapshot>(
              //     stream: FirebaseFirestore.instance
              //         .collection('ongoing')
              //         .doc(widget.myUid)
              //         .collection(widget.myUid)
              //         .orderBy('time', descending: true)
              //         .snapshots(),
              //     builder: (context, snapshot) {
              //       List<Widget> userLists = [];
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return Center(child: CircularProgressIndicator());
              //       }
              //       if (snapshot.hasData) {
              //         // print('got data');

              //         final users = snapshot.data.docs;
              //         for (var user in users) {
              //           var img = user.data()['img'];
              //           var uid = user.data()['uid'];
              //           var name = user.data()['name'];
              //           Timestamp time = user.data()['time'];
              //           var uidOfOther = user.data()['otherUid'];
              //           if (uidOfOther != uid && uid != null) {
              //             DateTime timeData =
              //                 DateTime.fromMillisecondsSinceEpoch(
              //                     time.millisecondsSinceEpoch);
              //             userLists.add(UserDisplay(
              //               uid: uid.toString().trim(),
              //               uidOfOther: uidOfOther.toString().trim(),
              //               img: img,
              //               name: name,
              //               time: timeFormat.format(timeData),
              //             ));
              //           }
              //         }
              //         return Expanded(
              //           child: ListView(
              //             children: userLists,
              //           ),
              //         );
              //       }
              //       return Container();
              //     }),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width / 2.6,
                        margin: EdgeInsets.only(left: 16),
                        child: Center(
                            child: Text(
                          "Cancel",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff898989)),
                        )),
                        decoration: BoxDecoration(
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.height * 0.00001,
                    ),
                    GestureDetector(
                      onTap: () async {
                        UserList.list.add(widget.myUid);
                        print(UserList.list);
                        if (_formKey.currentState.validate() &&
                            UserList.list != null) {
                          if (UserList.list.length >= 3) {
                            DocumentReference doc = await FirebaseFirestore
                                .instance
                                .collection('group_chat')
                                .add({
                              "created_by": widget.myUid,
                              "created_on": DateTime.now(),
                              "group_name": _nameController.text,
                              "last_msg": "Tap to start conversation",
                              "last_msg_by": "",
                              "last_msg_by_name": "",
                              "last_msg_time": DateTime.now(),
                              "participants":
                                  FieldValue.arrayUnion(UserList.list),
                            });
                            await FirebaseFirestore.instance
                                .collection("group_chat")
                                .doc(doc.id)
                                .collection("chats")
                                .add({
                              "msg": null,
                              "msg_by": "",
                              "time": DateTime.now(),
                              "uid": widget.myUid
                            });
                            UserList.list.clear();
                            Navigator.of(context).pop();
                          } else {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(
                                "Select atleast 2 members",
                                style: TextStyle(
                                    color: Colors.white, fontFamily: 'Lato'),
                              ),
                              elevation: 0,
                              duration: Duration(milliseconds: 1500),
                              backgroundColor: MyColors.primaryLight,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(5),
                                      topLeft: Radius.circular(5))),
                            ));
                            // UserList.list.clear();
                            UserList.list.remove(widget.myUid);
                            // buildOnGoingList();
                            // buildSearchList();
                          }
                        } else {
                          setState(() {
                            _autoValidate = true;
                          });
                          // UserList.list.clear();
                          UserList.list.remove(widget.myUid);
                        }
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width / 2.6,
                        margin: EdgeInsets.only(left: 8, right: 16),
                        child: Center(
                            child: Text("Create",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white))),
                        decoration: BoxDecoration(
                            color: MyColors.primaryLight,
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                      ),
                    ),
                  ],
                ),
              ),
              Offstage(
                child: EmojiPickerWidget(
                  onEmojiSelected: onEmojiSelected,
                ),
                offstage: !isEmojiVisible,
              )
            ],
          )),
    );
  }

  buildSearchList() {
    return searchList != null
        ? searchList.length < 1
            ? Container()
            : Expanded(
                child: ListView(
                  children: searchList,
                ),
              )
        : Container();
  }

  buildOnGoingList() {
    return onGoingList != null
        ? onGoingList.length < 1
            ? Container()
            : Expanded(
                child: ListView(
                  children: onGoingList,
                ),
              )
        : Container();
  }

  onEmojiSelected(String emoji) {
    setState(() {
      _nameController.text = _nameController.text + emoji;
      // focusNode.unfocus();
    });
  }

  onClickedEmoji() async {
    if (isEmojiVisible) {
      // if (isKeyBoardVisible) {
      //   setState(() {
      //     isKeyBoardVisible = false;
      //   });
      // }
      focusNode.requestFocus();
    } else if (isKeyBoardVisible) {
      FocusScope.of(context).unfocus();
      // setState(() {
      //   isKeyBoardVisible = !isKeyBoardVisible;
      // });
    }
    onBlurred();
  }

  Future onBlurred() async {
    if (isKeyBoardVisible) {
      FocusScope.of(context).unfocus();
    }
    setState(() {
      isEmojiVisible = !isEmojiVisible;
    });
  }

  final ImagePicker _picker = ImagePicker();
  File _image;
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera() async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
  }

  _imgFromGallery() async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
  }
}

// List<String> globalList;
List<String> userList = [];

class UserDisplay extends StatefulWidget {
  final String time, name, uid, uidOfOther, img;
  UserDisplay({
    this.time,
    this.name,
    this.uid,
    this.uidOfOther,
    this.img,
  });
  @override
  _UserDisplayState createState() => _UserDisplayState();
}

class _UserDisplayState extends State<UserDisplay> {
  bool selected = false;
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
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.028),
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.height * 0.02,
        right: MediaQuery.of(context).size.height * 0.02,
        top: MediaQuery.of(context).size.height * 0.02,
      ),
      child: InkWell(
        onTap: () {
          selected = !selected;
          selected
              ? userList.add(widget.uidOfOther)
              : userList.remove(widget.uidOfOther);
          UserList().updateList(userList);
          print(UserList.list.toString());
          setState(() {});
          // UserList().updateList(userList);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      widget.img != null ? null : Color(0xffe7e7e7),
                  backgroundImage:
                      widget.img != null ? NetworkImage(widget.img) : null,
                  radius: 25,
                  child: widget.img != null
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
                  child: Text(
                    widget.name,
                    style: TextStyle(
                        color: Color(0xff292929),
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            selected
                ? Container(
                    width: MediaQuery.of(context).size.width * 0.14,
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/images/checkMark.svg"),
                        Text(" Added",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                            )),
                      ],
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.01),
                    decoration: BoxDecoration(
                      color: MyColors.bg,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: MyColors.primaryLight,
                        )
                      ],
                    ),
                    child: Center(
                      child: Text("+ Add",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

class UserList {
  static List<String> list = [];
  updateList(value) {
    list = value;
    // print(list);
  }
}

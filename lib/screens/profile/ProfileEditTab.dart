import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smackit/Styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileEditTab extends StatefulWidget {
  final ValueChanged<List> onFieldUpdated;
  final String name, email, phone, location, about;
  ProfileEditTab(
      {this.name,
      this.about,
      this.email,
      this.location,
      this.phone,
      @required this.onFieldUpdated});
  @override
  _ProfileEditTabState createState() => _ProfileEditTabState();
}

class _ProfileEditTabState extends State<ProfileEditTab> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _nameController = TextEditingController();
  final _aboutController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String tempPhone, tempAbout;
  bool _autoValidate = false;
  @override
  void initState() {
    // print(widget.phone);
    tempAbout = widget.about;
    tempPhone = widget.phone;
    _nameController.text = widget.name;
    _phoneController.text =
        widget.phone.length > 15 ? "" : widget.phone.split(" ")[1];
    _aboutController.text = widget.about == "About me" ? "" : widget.about;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width * 0.15,
        leading: Container(
          margin:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: SvgPicture.asset(
              'assets/images/crossForEditProfile.svg',
            ),
          ),
        ),
        title: Container(
          margin:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.16),
          child: Text(
            'Edit Profile',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
        ),
        elevation: 0,
        backgroundColor: MyColors.primaryLight,
      ),
      backgroundColor: MyColors.background,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stack(children: [
                    //   Center(
                    //     child: Container(
                    //       margin: EdgeInsets.only(
                    //           top: MediaQuery.of(context).size.width * 0.018),
                    //       width: MediaQuery.of(context).size.width * 0.3,
                    //       height: MediaQuery.of(context).size.width * 0.4,
                    //       alignment: Alignment.center,
                    //       child: CircleAvatar(
                    //         child: Icon(
                    //           Icons.person,
                    //           color: MyColors.bg,
                    //         ),
                    //         radius: MediaQuery.of(context).size.width * 0.4,
                    //         backgroundColor: MyColors.background,
                    //       ),
                    //       decoration: BoxDecoration(
                    //           border:
                    //               Border.all(color: MyColors.primaryLight, width: 1),
                    //           color: MyColors.background,
                    //           shape: BoxShape.circle),
                    //     ),
                    //   ),
                    //   Positioned(
                    //     top: MediaQuery.of(context).size.height * 0.16,
                    //     left: MediaQuery.of(context).size.width * 0.57,
                    //     child: Container(
                    //         decoration: BoxDecoration(
                    //             color: MyColors.primaryLight, shape: BoxShape.circle),
                    //         height: MediaQuery.of(context).size.height * 0.05,
                    //         width: MediaQuery.of(context).size.height * 0.05,
                    //         child: SvgPicture.asset(
                    //           'assets/images/camForProfileEdit.svg',
                    //           fit: BoxFit.scaleDown,
                    //         )),
                    //   )
                    // ]),
                    Center(
                        child: Container(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * 0.05,
                            ),
                            child: SvgPicture.asset(
                                "assets/images/changePictureFOrEditProfile.svg"))),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.05,
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.08),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name",
                              style: TextStyle(
                                  color: Color(0xff292929),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                            // SizedBox(
                            //   height: MediaQuery.of(context).size.width * 0.02,
                            // ),
                            TextFormField(
                              autocorrect: _autoValidate,
                              controller: _nameController,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (!(value.compareTo(widget.name) == 0)) {
                                  if (value.isEmpty) {
                                    return "Enter valid name";
                                  }
                                }
                                return null;
                              },
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            Text(
                              "Phone",
                              style: TextStyle(
                                  color: Color(0xff292929),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                            TextFormField(
                              autocorrect: _autoValidate,
                              controller: _phoneController,
                              maxLength: 10,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (!(value.compareTo(tempPhone) == 0)) {
                                  if (value.length < 10) {
                                    return "Enter valid phone number";
                                  }
                                }
                                return null;
                              },
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                              decoration: InputDecoration(
                                  hintText: "Enter phone number"),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            Text(
                              "About Me",
                              style: TextStyle(
                                  color: Color(0xff292929),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                            TextFormField(
                              autocorrect: _autoValidate,
                              controller: _aboutController,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (!(value.compareTo(tempAbout) == 0)) {
                                  if (value.isEmpty) {
                                    return "Enter proper description";
                                  }
                                }
                                return null;
                              },
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                              decoration: InputDecoration(hintText: "About me"),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            Text(
                              "Email",
                              style: TextStyle(
                                  color: Color(0xff292929),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.04,
                            ),
                            Text(
                              widget.email == null ? "No email" : widget.email,
                              style: TextStyle(
                                  color: Color(0xff292929),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            Text(
                              "Location",
                              style: TextStyle(
                                  color: Color(0xff292929),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.04,
                            ),
                            Text(
                              widget.location == null
                                  ? "Some location"
                                  : widget.location,
                              style: TextStyle(
                                  color: Color(0xff292929),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_formKey.currentState.validate()) {
                                  FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(widget.email)
                                      .update({
                                    "name": _nameController.text.trim(),
                                    "about": _aboutController.text.trim(),
                                    "phone":
                                        "+91 " + _phoneController.text.trim(),
                                    "phone_verified": false
                                  });
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      "Update successful",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Lato'),
                                    ),
                                    elevation: 0,
                                    duration: Duration(milliseconds: 400),
                                    backgroundColor: MyColors.primaryLight,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(5),
                                            topLeft: Radius.circular(5))),
                                  ));
                                  widget.onFieldUpdated([
                                    _nameController.text.trim(),
                                    "+91 " + _phoneController.text.trim(),
                                    _aboutController.text.trim()
                                  ]);
                                  Future.delayed(Duration(milliseconds: 700),
                                      () {
                                    Navigator.of(context).pop();
                                    // Navigator.of(context).pushReplacement(
                                    //     MaterialPageRoute(
                                    //         builder: (context) => HomePage()));
                                  });
                                } else {
                                  setState(() {
                                    _autoValidate = true;
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: MyColors.bg,
                                    borderRadius: BorderRadius.circular(4)),
                                width: MediaQuery.of(context).size.width,
                                height: 48,
                                child: Center(
                                  child: Text("Save",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ]),
            )),
      ),
    );
  }
}

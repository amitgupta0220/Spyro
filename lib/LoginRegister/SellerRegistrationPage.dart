import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smackit/LoginRegister/VerifyEmail.dart';
import 'package:smackit/Styles.dart';
import 'package:smackit/models/User.dart';
import 'package:smackit/services/authentication.dart';
import 'package:smackit/widgets/SignUp.dart';

class SellerRegistrationPage extends StatefulWidget {
  @override
  _SellerRegistrationPageState createState() => _SellerRegistrationPageState();
}

class _SellerRegistrationPageState extends State<SellerRegistrationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String dropdownValue = 'Proprietor';
  final _shopNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _websiteController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _passConfirmController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _autoValidate = false;
  bool showPass = true;
  bool showPassConfirm = true;
  // final ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Container(
                  //     height: MediaQuery.of(context).size.height * 0.055,
                  //     margin: EdgeInsets.only(
                  //         bottom: 5, top: MediaQuery.of(context).size.height * 0.1),
                  //     child: Image.asset('assets/images/onboardingLogo.png')),
                  // Text(
                  //   "Explore your favorites\n around you.",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(fontSize: 12, color: Color(0xff858585)),
                  // ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Text(
                        "Email",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 14, color: Color(0xff222222)),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: _autoValidate,
                        validator: (value) => _validateEmail(value),
                        controller: _emailController,
                        // initialValue: "test@test.com",
                        decoration: InputDecoration(
                          hintStyle:
                              TextStyle(fontSize: 14, color: Color(0xff9D9D9D)),
                          hintText: 'test@test.com',
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      Text(
                        "Password",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 14, color: Color(0xff222222)),
                      ),
                      TextFormField(
                          controller: _passController,
                          autocorrect: _autoValidate,
                          // style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                          keyboardType: TextInputType.name,
                          // onSaved: (value) => _email = value.trim(),
                          validator: (value) {
                            if (value.isEmpty || !(value.length > 5)) {
                              return 'Enter valid password';
                            }
                            return null;
                          },
                          obscureText: showPass,
                          obscuringCharacter: '*',
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                fontSize: 14, color: Color(0xff9D9D9D)),
                            hintText: '******',
                            suffixIcon: IconButton(
                              icon: showPass
                                  ? SvgPicture.asset(
                                      "assets/images/feather_eye.svg")
                                  : SvgPicture.asset(
                                      "assets/images/hide_feather_eye.svg"),
                              onPressed: () {
                                setState(() {
                                  showPass = !showPass;
                                });
                              },
                            ),
                          )),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      Text(
                        "Confirm Password",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 14, color: Color(0xff222222)),
                      ),
                      TextFormField(
                        style: TextStyle(fontSize: 15),
                        controller: _passConfirmController,
                        autocorrect: _autoValidate,
                        // style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                        // onSaved: (value) => _email = value.trim(),
                        validator: (value) {
                          if (value.trim().compareTo(_passController.text) !=
                                  0 ||
                              value.isEmpty) {
                            return 'Password mismatch';
                          }
                          return null;
                        },
                        obscureText: showPassConfirm, obscuringCharacter: '*',
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: showPassConfirm
                                ? SvgPicture.asset(
                                    "assets/images/feather_eye.svg")
                                : SvgPicture.asset(
                                    "assets/images/hide_feather_eye.svg"),
                            onPressed: () {
                              setState(() {
                                showPassConfirm = !showPassConfirm;
                              });
                            },
                          ),
                          hintStyle:
                              TextStyle(fontSize: 15, color: Color(0xff9D9D9D)),
                          hintText: '******',
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      Text(
                        "Shop or Company name",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 14, color: Color(0xff222222)),
                      ),
                      TextFormField(
                        style: TextStyle(fontSize: 14),
                        controller: _shopNameController,
                        autocorrect: _autoValidate,
                        // style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                        keyboardType: TextInputType.name,
                        // onSaved: (value) => _email = value.trim(),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter shop name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintStyle:
                              TextStyle(fontSize: 14, color: Color(0xff9D9D9D)),
                          hintText: 'eg: Spyro',
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      Text(
                        "Type of Business:",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 14, color: Color(0xff222222)),
                      ),
                      DropdownButton<String>(
                        style: TextStyle(color: Color(0xff9D9D9D)),
                        value: dropdownValue,
                        // style: TextStyle(color: Colors.deepPurple),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>[
                          'Proprietor',
                          'Partnership',
                          'LLP',
                          'Private Limited',
                          'Public Limited'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      Text(
                        "Owner Name",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 14, color: Color(0xff222222)),
                      ),
                      TextFormField(
                        controller: _ownerNameController,
                        autocorrect: _autoValidate,
                        // style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                        keyboardType: TextInputType.name,
                        // onSaved: (value) => _email = value.trim(),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter Owner Name';
                          }
                          return null;
                        },
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintStyle:
                              TextStyle(fontSize: 14, color: Color(0xff9D9D9D)),
                          hintText: 'eg: Sunit Chaudhari',
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      Text(
                        "Address",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 14, color: Color(0xff222222)),
                      ),
                      TextFormField(
                        // maxLines: 2,
                        controller: _addressController,
                        autocorrect: _autoValidate,
                        // style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                        keyboardType: TextInputType.name,
                        // onSaved: (value) => _email = value.trim(),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter Address';
                          }
                          return null;
                        },
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintStyle:
                              TextStyle(fontSize: 14, color: Color(0xff9D9D9D)),
                          hintText: 'eg. 920/A-wing, 2nd floor, Res...',
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      Text(
                        "Contact Number",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 14, color: Color(0xff222222)),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty || value.length < 10) {
                            return 'Enter valid phone number';
                          }
                          return null;
                        },
                        autocorrect: _autoValidate,
                        keyboardType: TextInputType.phone,
                        controller: _phoneController,
                        // initialValue: "+91 1234567890",
                        decoration: InputDecoration(
                          hintStyle:
                              TextStyle(fontSize: 14, color: Color(0xff9D9D9D)),
                          hintText: '+91 1234567890',
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      Text(
                        "Website",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 14, color: Color(0xff222222)),
                      ),
                      TextFormField(
                        controller: _websiteController,
                        autocorrect: _autoValidate,
                        // style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                        keyboardType: TextInputType.name,
                        // onSaved: (value) => _email = value.trim(),
                        // validator: (value) => _validateWebsite(value),
                        decoration: InputDecoration(
                          hintStyle:
                              TextStyle(fontSize: 14, color: Color(0xff9D9D9D)),
                          hintText: 'eg: www.abc.def',
                        ),
                      ),

                      // Container(
                      //   margin: EdgeInsets.symmetric(horizontal: 20),
                      //   height: 2,
                      //   color: Colors.black,
                      // ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      // GestureDetector(
                      //   onTap: () => _showPicker(context),
                      //   child: _image != null
                      //       ? ClipRRect(
                      //           borderRadius: BorderRadius.circular(50),
                      //           child: Image.file(
                      //             _image,
                      //             width: 100,
                      //             height: 100,
                      //             fit: BoxFit.fitHeight,
                      //           ),
                      //         )
                      //       : Container(
                      //           decoration: BoxDecoration(
                      //               color: Colors.grey[200],
                      //               borderRadius:
                      //                   BorderRadius.circular(50)),
                      //           width: 100,
                      //           height: 100,
                      //           child: Icon(
                      //             Icons.camera_alt,
                      //             color: Colors.grey[800],
                      //           ),
                      //         ),
                      // ),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            Map result = await AuthService().signUp(
                                'email', 'seller',
                                seller: Seller(
                                    address: _addressController.text,
                                    email: _emailController.text,
                                    ownerName: _ownerNameController.text,
                                    password: _passController.text,
                                    phone: _phoneController.text,
                                    shopName: _shopNameController.text,
                                    typeOfBusiness: dropdownValue,
                                    userType: TypeOfUser.seller,
                                    verified: false,
                                    website: _websiteController.text));
                            displayMessage(result);
                          }
                        },
                        child: Container(
                          // margin: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: MyColors.bg,
                              borderRadius: BorderRadius.circular(4)),
                          width: MediaQuery.of(context).size.width,
                          height: 48,
                          child: Center(
                            child: Text("Next",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
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

  void displayMessage(Map result) {
    if (result['success']) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Sign-Up Successful",
          style: TextStyle(color: Colors.white, fontFamily: 'Lato'),
        ),
        elevation: 0,
        duration: Duration(milliseconds: 500),
        backgroundColor: MyColors.primaryLight,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(5), topLeft: Radius.circular(5))),
      ));
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pop();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VerifyEmail(
                    _emailController.text.trim().toLowerCase(), 'seller')));
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Error : ${result['msg']}",
          style: TextStyle(color: Colors.white, fontFamily: 'Lato'),
        ),
        elevation: 0,
        duration: Duration(seconds: 2),
        backgroundColor: MyColors.primaryLight,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(5), topLeft: Radius.circular(5))),
      ));
    }
  }

  String _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  // String _validateWebsite(String value) {
  //   Pattern pattern =
  //       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  //   RegExp regex = new RegExp(pattern);
  //   if (!regex.hasMatch(value))
  //     return 'Enter Valid website';
  //   else
  //     return null;
  // }

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

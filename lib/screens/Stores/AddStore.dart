import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smackit/Styles.dart';

class AddStore extends StatefulWidget {
  @override
  _AddStoreState createState() => _AddStoreState();
}

class _AddStoreState extends State<AddStore> {
  final _shopNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _numberController = TextEditingController();
  final _websiteController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primary,
      appBar: AppBar(
        leading: Container(),
        elevation: 0,
        backgroundColor: MyColors.primaryLight,
        title: Container(
          margin:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.145),
          child: Text('Add Store',
              style: TextStyle(color: Colors.white, fontSize: 22)),
        ),
      ),
      body: Container(
        // padding: EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.width * 0.05,
                  top: MediaQuery.of(context).size.width * 0.03,
                  right: MediaQuery.of(context).size.width * 0.04,
                  left: MediaQuery.of(context).size.width * 0.04,
                ),
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Store Name",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff292929))),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.0001,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/images/bagForProfile.svg'),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Flexible(
                          child: TextFormField(
                            controller: _shopNameController,
                            // autocorrect: _autoValidate,
                            // style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                            keyboardType: TextInputType.name,
                            // onSaved: (value) => _email = value.trim(),
                            // validator: (value) => _validateWebsite(value),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  fontSize: 14, color: Color(0xff9D9D9D)),
                              hintText: 'Name of your Store',
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.width * 0.05,
                  // top: MediaQuery.of(context).size.width * 0.03,
                  right: MediaQuery.of(context).size.width * 0.04,
                  left: MediaQuery.of(context).size.width * 0.04,
                ),
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Category",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff292929))),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.0001,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/images/listForAddStore.svg'),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Flexible(
                          child: TextFormField(
                            // autocorrect: _autoValidate,
                            // style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                            keyboardType: TextInputType.name,
                            // onSaved: (value) => _email = value.trim(),
                            // validator: (value) => _validateWebsite(value),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  fontSize: 14, color: Color(0xff9D9D9D)),
                              hintText: 'Drop Down Here',
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.width * 0.05,
                  // top: MediaQuery.of(context).size.width * 0.03,
                  right: MediaQuery.of(context).size.width * 0.04,
                  left: MediaQuery.of(context).size.width * 0.04,
                ),
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Description",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff292929))),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.0001,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                            'assets/images/descriptionForAddStore.svg'),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Flexible(
                          child: TextFormField(
                            controller: _descriptionController,
                            // autocorrect: _autoValidate,
                            // style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                            keyboardType: TextInputType.name,
                            // onSaved: (value) => _email = value.trim(),
                            // validator: (value) => _validateWebsite(value),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  fontSize: 14, color: Color(0xff9D9D9D)),
                              hintText: 'Tell us about yourself',
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.width * 0.05,
                  // top: MediaQuery.of(context).size.width * 0.03,
                  right: MediaQuery.of(context).size.width * 0.04,
                  left: MediaQuery.of(context).size.width * 0.04,
                ),
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Timing",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff292929))),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.0001,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/images/clockForAddStore.svg'),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Flexible(
                          child: TextFormField(
                            // autocorrect: _autoValidate,
                            enabled: false,
                            // style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                            keyboardType: TextInputType.name,
                            // onSaved: (value) => _email = value.trim(),
                            // validator: (value) => _validateWebsite(value),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  fontSize: 14, color: Color(0xff9D9D9D)),
                              hintText: 'Tap to change Business Hours',
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.width * 0.05,
                  // top: MediaQuery.of(context).size.width * 0.03,
                  right: MediaQuery.of(context).size.width * 0.04,
                  left: MediaQuery.of(context).size.width * 0.04,
                ),
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Add Photos",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff292929))),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.0001,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                            'assets/images/galleryForAddStore.svg'),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Flexible(
                          child: TextFormField(
                            // autocorrect: _autoValidate,
                            enabled: false,
                            // style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                            keyboardType: TextInputType.name,
                            // onSaved: (value) => _email = value.trim(),
                            // validator: (value) => _validateWebsite(value),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  fontSize: 14, color: Color(0xff9D9D9D)),
                              hintText: 'Tap here',
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.width * 0.05,
                  // top: MediaQuery.of(context).size.width * 0.03,
                  right: MediaQuery.of(context).size.width * 0.04,
                  left: MediaQuery.of(context).size.width * 0.04,
                ),
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Location",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff292929))),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.0001,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/locationForProfile.svg',
                          color: MyColors.primaryLight,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Flexible(
                          child: TextFormField(
                            controller: _locationController,
                            // autocorrect: _autoValidate,
                            // enabled: false,
                            // style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                            keyboardType: TextInputType.name,
                            // onSaved: (value) => _email = value.trim(),
                            // validator: (value) => _validateWebsite(value),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  fontSize: 14, color: Color(0xff9D9D9D)),
                              hintText: 'Add Store Address',
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.width * 0.05,
                  // top: MediaQuery.of(context).size.width * 0.03,
                  right: MediaQuery.of(context).size.width * 0.04,
                  left: MediaQuery.of(context).size.width * 0.04,
                ),
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Contact",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff292929))),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.0001,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/phoneForProfile.svg',
                          color: MyColors.primaryLight,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Flexible(
                          child: TextFormField(
                            // autocorrect: _autoValidate,
                            // enabled: false,
                            // style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                            keyboardType: TextInputType.number,
                            controller: _numberController,
                            // onSaved: (value) => _email = value.trim(),
                            // validator: (value) => _validateWebsite(value),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  fontSize: 14, color: Color(0xff9D9D9D)),
                              hintText: 'Add Phone Number',
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.width * 0.05,
                  // top: MediaQuery.of(context).size.width * 0.03,
                  right: MediaQuery.of(context).size.width * 0.04,
                  left: MediaQuery.of(context).size.width * 0.04,
                ),
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Website",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff292929))),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.0001,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                            'assets/images/websiteForAddStore.svg'),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Flexible(
                          child: TextFormField(
                            // autocorrect: _autoValidate,
                            // enabled: false,
                            controller: _websiteController,
                            // style: TextStyle(fontSize: 20, fontFamily: 'Roboto'),
                            keyboardType: TextInputType.emailAddress,
                            // onSaved: (value) => _email = value.trim(),
                            // validator: (value) => _validateWebsite(value),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  fontSize: 14, color: Color(0xff9D9D9D)),
                              hintText: 'Add Website',
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "Not completed yet",
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
                },
                child: Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: MyColors.bg,
                      borderRadius: BorderRadius.circular(4)),
                  width: MediaQuery.of(context).size.width,
                  height: 48,
                  child: Center(
                    child: Text("Save",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/database.dart';
import '../../widgets/CustomButton.dart';
import '../../Styles.dart';

class EditProfile extends StatefulWidget {
  final String name, phone, photoUrl, location, about;
  const EditProfile(
      {Key key,
      this.name,
      this.phone,
      this.photoUrl,
      this.location,
      this.about})
      : super(key: key);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String edittedAbout;
  bool _updating = false;
  TextEditingController _nameController,
      _phoneController,
      _photoUrlController,
      _locationController,
      _aboutController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _phoneController = TextEditingController(text: widget.phone?.substring(3));
    _aboutController = TextEditingController(text: widget.about);
    _locationController = TextEditingController(text: widget.location);
    _photoUrlController = TextEditingController(text: widget.photoUrl);
    edittedAbout = widget.about;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _aboutController.dispose();
    _locationController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  void editAbout(BuildContext context) {
    showBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                      controller: _aboutController,
                      autofocus: true,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Tell us about Yourself',
                        hintStyle: Theme.of(context).textTheme.headline6,
                      )),
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.clear,
                        color: MyColors.secondary,
                      ),
                      label: Text('Cancel'),
                    ),
                    SizedBox(width: 20),
                    FlatButton.icon(
                      onPressed: () {
                        setState(() => edittedAbout = _aboutController.text);
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.check,
                        color: MyColors.secondary,
                      ),
                      label: Text('Save'),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  File _image;
  final picker = ImagePicker();
  Future getImage() async {
    try {
      final pickedFile = await picker.getImage(
          source: ImageSource.gallery,
          imageQuality: 50,
          maxHeight: 200,
          maxWidth: 200);
      setState(() {
        _image = File(pickedFile.path);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void _update() async {
    setState(() => _updating = true);
    Map data = {
      'name': _nameController.text,
      'phone': '+91' + _phoneController.text,
      'about': _aboutController.text,
      'location': _locationController.text
    };
    if (_image != null) data['image'] = _image;
    await DatabaseService().updateUserInfo(data);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const double radius = 50;
    return Form(
      key: _formKey,
      // autovalidate: _autovalidate,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Edit Profile'),
          centerTitle: true,
        ),
        body: AbsorbPointer(
          absorbing: _updating,
          child: Builder(
            builder: (ctx) => SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                Center(
                  child: Container(
                    width: radius * 2 + 3,
                    height: radius * 2 + 3,
                    alignment: Alignment.center,
                    child: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        CircleAvatar(
                            backgroundImage:
                                widget.photoUrl != null && _image == null
                                    ? NetworkImage(widget.photoUrl)
                                    : _image != null
                                        ? FileImage(_image)
                                        : null,
                            child: widget.photoUrl != null || _image != null
                                ? null
                                : Icon(Icons.person),
                            radius: radius),
                        Positioned(
                            bottom: 0,
                            right: -10,
                            child: GestureDetector(
                              onTap: getImage,
                              child: Container(
                                  height: radius - 10,
                                  width: radius - 10,
                                  decoration: BoxDecoration(
                                      color: MyColors.secondary,
                                      shape: BoxShape.circle),
                                  child: Icon(Icons.add_a_photo,
                                      color: MyColors.primaryLight)),
                            ))
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: MyColors.secondary, shape: BoxShape.circle),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 30),
                  child: TextFormField(
                    controller: _nameController,
                    style: TextStyle(fontFamily: 'Roboto'),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: 'Name',
                        labelStyle: TextStyle(color: MyColors.secondary),
                        hintText: 'Your Name',
                        errorText: _nameController.text.isEmpty
                            ? 'Name cannot be Empty'
                            : null),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 30),
                  child: TextFormField(
                    controller: _phoneController,
                    style: TextStyle(fontFamily: 'Roboto'),
                    // initialValue: widget.phone,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        labelText: 'Phone',
                        labelStyle: TextStyle(color: MyColors.secondary),
                        hintText: 'Your phone number',
                        errorText: _phoneController.text.length != 10
                            ? 'Must be a 10-digit number'
                            : null),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 30),
                  child: TextFormField(
                    controller: _locationController,
                    style: TextStyle(fontFamily: 'Roboto'),
                    // initialValue: widget.location,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_on),
                        labelText: 'Location',
                        labelStyle: TextStyle(color: MyColors.secondary),
                        hintText: 'Where do you Live ?'),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 20, left: 30),
                    child: Text(
                      'About:',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Roboto',
                          color: MyColors.secondary),
                    )),
                Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: FittedBox(
                            child: Text(
                              edittedAbout == null || edittedAbout == ""
                                  ? 'Add About'
                                  : edittedAbout,
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Roboto',
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        IconButton(
                            icon: Icon(Icons.edit, color: MyColors.secondary),
                            onPressed: () => editAbout(ctx))
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _updating
                          ? CircularProgressIndicator()
                          : MyButton(
                              text: 'Save',
                              action: _update,
                            ),
                    ],
                  ),
                )
              ],
            )),
          ),
        ),
      ),
    );
  }
}

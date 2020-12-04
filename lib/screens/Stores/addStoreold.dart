import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:smackit/models/Store.dart';
import 'package:smackit/services/add_location.dart';
import 'package:smackit/services/database.dart';
import 'package:smackit/widgets/DailogBox.dart';
import 'package:smackit/widgets/pickers.dart';
import '../../models/Categories.dart';
import '../../widgets/CustomButton.dart';
import '../../Styles.dart';
import 'additems.dart';

class AddStoreOld extends StatefulWidget {
  @override
  _AddStoreOldState createState() => _AddStoreOldState();
}

class _AddStoreOldState extends State<AddStoreOld> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _locationControler = TextEditingController();
  FocusNode _storeFocus = FocusNode();
  FocusNode _ownerFocus = FocusNode();
  FocusNode _descFocus = FocusNode();
  FocusNode _locationFocus = FocusNode();
  FocusNode _phoneFocus = FocusNode();
  FocusNode _websiteFocus = FocusNode();
  FocusNode _othertextfield = FocusNode();
  bool _autovalidate = false,
      _adding = false,
      _added = false,
      _fav = false,
      _isOwner = false,
      _showOtherTexttField = false;
  String _storename,
      _owner,
      _category,
      _subcategory,
      _description,
      _location,
      _phone,
      _website;
  Position _position;
  DateTime start1, end1, start2, end2;
  Pickers from = new Pickers();
  Pickers to = new Pickers();
  double _rating = 3;
  List<Asset> _images = List<Asset>();
  List<Uint8List> _imageBytes = List<Uint8List>();
  List<Map<String, dynamic>> _items = List<Map<String, dynamic>>();
  int _primary = 0;

  Future<void> _getImages() async {
    List<Asset> temp = List<Asset>();
    try {
      temp = await MultiImagePicker.pickImages(
          maxImages: 4,
          selectedAssets: temp,
          enableCamera: true,
          cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
          materialOptions: MaterialOptions(
            statusBarColor: '#fbc02d',
            actionBarColor: "#fbc02d",
            actionBarTitle: "Select Image",
            allViewTitle: "All Photos",
            useDetailsView: false,
            selectCircleStrokeColor: "#bf211e",
          ));
    } catch (e) {
      print('Error');
      print(e.toString());
    }
    if (!mounted) return;
    _images = temp;
    await _loadImageBytes(_images);
    setState(() {});
  }

  Future<void> _loadImageBytes(List<Asset> _images) async {
    _imageBytes = List<Uint8List>();
    for (var i = 0; i < _images.length; i++) {
      var bytes =
          (await _images[i].getByteData(quality: 50)).buffer.asUint8List();
      _imageBytes.add(bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _adding ? Future.value(false) : _onBackPressed(context),
      child: Form(
        key: _formKey,
        // autovalidate: _autovalidate,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Add Store'),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () => _onBackPressed(context),
            ),
          ),
          body: AbsorbPointer(
            absorbing: _adding,
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 30),
                      Text('Store Name', style: MyTextStyles.label),
                      TextFormField(
                        focusNode: _storeFocus,
                        validator: (value) =>
                            value.trim().isEmpty ? 'Enter Store Name' : null,
                        onEditingComplete: () =>
                            moveFocus(_storeFocus, _ownerFocus),
                        onChanged: (value) => _storename = value.trim(),
                        style: TextStyle(fontFamily: 'Roboto'),
                        decoration: InputDecoration(
                          prefixIcon:
                              Icon(Icons.store, color: MyColors.primary),
                          hintText: 'Name of your Store',
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Checkbox(
                              value: _isOwner,
                              onChanged: (checked) => setState(() {
                                    _isOwner = checked;
                                    _items = [];
                                  })),
                          Text('Are you Store Owner ?',
                              style: MyTextStyles.label),
                        ],
                      ),
                      if (_isOwner) SizedBox(height: 10),
                      if (_isOwner) Text('Owner', style: MyTextStyles.label),
                      if (_isOwner)
                        TextFormField(
                          focusNode: _ownerFocus,
                          onChanged: (value) => _owner = value.trim(),
                          style: TextStyle(fontFamily: 'Roboto'),
                          decoration: InputDecoration(
                            prefixIcon:
                                Icon(Icons.person, color: MyColors.primary),
                            hintText: 'Name of the Owner',
                          ),
                        ),
                      SizedBox(height: 20),
                      Text('Category', style: MyTextStyles.label),
                      Row(
                        children: <Widget>[
                          SizedBox(width: 10),
                          Icon(
                            FontAwesome.list,
                            color: MyColors.primary,
                            size: 20,
                          ),
                          SizedBox(width: 15),
                          Expanded(child: selectCategory()),
                          SizedBox(width: 10)
                        ],
                      ),
                      if (_category != null) SizedBox(height: 5),
                      if (_category != null)
                        Text('Sub-Category', style: MyTextStyles.label),
                      if (_category != null)
                        Row(
                          children: <Widget>[
                            SizedBox(width: 10),
                            Icon(
                              FontAwesome.list_ul,
                              color: MyColors.primary,
                              size: 20,
                            ),
                            SizedBox(width: 15),
                            Expanded(child: selectSubcategory(_category)),
                            SizedBox(width: 10),
                          ],
                        ),
                      Visibility(
                        visible: _showOtherTexttField,
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Others', style: MyTextStyles.label),
                              TextFormField(
                                focusNode: _othertextfield,
                                onChanged: (value) =>
                                    _subcategory = 'Others: ' + value.trim(),
                                style: TextStyle(fontFamily: 'Roboto'),
                                decoration: InputDecoration(
                                    hintText: 'Enter your subcategory'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Description', style: MyTextStyles.label),
                      TextFormField(
                        focusNode: _descFocus,
                        onChanged: (value) => _description = value.trim(),
                        minLines: 1,
                        maxLines: 3,
                        style: TextStyle(fontFamily: 'Roboto'),
                        decoration: InputDecoration(
                          prefixIcon:
                              Icon(Icons.subject, color: MyColors.primary),
                          hintText: 'Tell us about your store',
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: <Widget>[
                          Text('Timing', style: MyTextStyles.label),
                          SizedBox(width: 5),
                          Icon(
                            Icons.access_time,
                            color: MyColors.primary,
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: DateTimeField(
                              onShowPicker: (ctx, initialTIme) =>
                                  from.presentTimePicker(ctx, initialTIme),
                              format: DateFormat('hh:mm a'),
                              onChanged: (value) => start1 = value,
                              style: TextStyle(fontFamily: 'Roboto'),
                              decoration: InputDecoration(
                                prefix: Text('From: ',
                                    style:
                                        TextStyle(color: MyColors.secondary)),
                                hintText: 'From',
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: DateTimeField(
                              onShowPicker: (context, initialTIme) =>
                                  to.presentTimePicker(context, initialTIme),
                              format: DateFormat('hh:mm a'),
                              onChanged: (value) => end1 = value,
                              validator: (value) {
                                if (start1 != null) {
                                  if (end1 == null)
                                    return 'Select Closing Time';
                                  if (value.isBefore(start1))
                                    return 'Invalid Closing Time';
                                }
                                return null;
                              },
                              style: TextStyle(fontFamily: 'Roboto'),
                              decoration: InputDecoration(
                                hintText: 'To',
                                prefix: Text('To: ',
                                    style:
                                        TextStyle(color: MyColors.secondary)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: _getImages,
                        child: Row(
                          children: <Widget>[
                            Text('Add photos', style: MyTextStyles.label),
                            SizedBox(width: 10),
                            Icon(
                              Icons.add_a_photo,
                              color: MyColors.primary,
                            )
                          ],
                        ),
                      ),
                      if (_imageBytes.length != 0)
                        Container(
                          height: 100,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: _imageBytes.length,
                            itemBuilder: (context, i) {
                              var image = _imageBytes[i];
                              return GestureDetector(
                                onLongPress: () => showImage(context, image),
                                onTap: () => setState(() => _primary = i),
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      height: 100,
                                      width: 100,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: MemoryImage(image)),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: _primary == i
                                              ? Border.all(
                                                  color: MyColors.secondary,
                                                  width: 2)
                                              : null),
                                    ),
                                    Positioned(
                                        top: 5,
                                        right: 12,
                                        child: GestureDetector(
                                          onTap: () => setState(() {
                                            setState(() {
                                              _imageBytes.removeAt(i);
                                              _images.removeAt(i);
                                            });
                                          }),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle),
                                              child: Icon(Icons.remove,
                                                  color: Colors.white)),
                                        ))
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      if (_imageBytes.length != 0)
                        Text('Select one as Primary'),
                      SizedBox(height: 20),
                      Text('Location', style: MyTextStyles.label),
                      TextFormField(
                        focusNode: _locationFocus,
                        controller: _locationControler,
                        onTap: () async {
                          var result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) =>
                                      GetLocation(_position ?? null)));
                          if (result != null) {
                            setState(() {
                              _location = result['location'];
                              _locationControler.text = _location;
                              _position = result['position'];
                            });
                          }
                        },
                        validator: (value) => value.trim().isEmpty
                            ? 'Select Store Location'
                            : null,
                        onChanged: (value) => _location = value.trim(),
                        style: TextStyle(fontFamily: 'Roboto'),
                        decoration: InputDecoration(
                          prefixIcon:
                              Icon(Icons.location_on, color: MyColors.primary),
                          hintText: 'Store Address',
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('Contact', style: MyTextStyles.label),
                      TextFormField(
                        focusNode: _phoneFocus,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        validator: (value) => value.trim().isEmpty
                            ? 'Enter Contact No'
                            : value.trim().length != 10
                                ? 'Must be 10-digit Number'
                                : null,
                        onChanged: (value) => _phone = '+91' + value.trim(),
                        style: TextStyle(fontFamily: 'Roboto'),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.call, color: MyColors.primary),
                          hintText: 'Phone Number',
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('Website', style: MyTextStyles.label),
                      TextFormField(
                        focusNode: _websiteFocus,
                        keyboardType: TextInputType.text,
                        onChanged: (value) => _website = value.trim(),
                        style: TextStyle(fontFamily: 'Roboto'),
                        decoration: InputDecoration(
                          prefixIcon:
                              Icon(Icons.language, color: MyColors.primary),
                          hintText: 'Your Store Website',
                        ),
                      ),
                      if (_isOwner)
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 20),
                              Row(
                                children: <Widget>[
                                  Text('Item List', style: MyTextStyles.label),
                                  Spacer(),
                                  IconButton(
                                    icon: Icon(Icons.add,
                                        color: MyColors.secondary),
                                    onPressed: () async {
                                      var result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  AddItems(_items)));
                                      if (result != null)
                                        setState(() => _items = result);
                                    },
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              if (_items.length != 0)
                                ...List<Widget>.generate(_items.length, (i) {
                                  var item = _items[i];
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: i % 2 == 0
                                            ? MyColors.primary.withOpacity(0.3)
                                            : null,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: ListTile(
                                      title: Text(item['name']),
                                      trailing: Text(
                                        '₹${item['price']}',
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 20,
                                            color: MyColors.secondary),
                                      ),
                                    ),
                                  );
                                })
                            ]),
                      SizedBox(height: 10),
                      Text('Rating', style: MyTextStyles.label),
                      SizedBox(height: 10),
                      rating(),
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Checkbox(
                              value: _fav,
                              onChanged: (checked) =>
                                  setState(() => _fav = checked)),
                          Text('Mark as Favourite', style: MyTextStyles.label),
                        ],
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _adding
                                ? CircularProgressIndicator()
                                : MyButton(
                                    text: 'Save Store',
                                    action: () async {
                                      FocusScope.of(context).unfocus();
                                      if (_formKey.currentState.validate()) {
                                        if (_category == null ||
                                            _subcategory == null) {
                                          showDialog(
                                              context: context,
                                              builder: (_) => DialogBox(
                                                  title: 'Error :(',
                                                  description:
                                                      'Please select a Category and Subcategory',
                                                  buttonText1: 'Ok',
                                                  button1Func: () =>
                                                      Navigator.of(context)
                                                          .pop()));
                                          return;
                                        }
                                        if (_images.length == 0) {
                                          showDialog(
                                              context: context,
                                              builder: (_) => DialogBox(
                                                  title: 'Error :(',
                                                  description:
                                                      'Please add atleast one photo of store',
                                                  buttonText1: 'Ok',
                                                  button1Func: () =>
                                                      Navigator.of(context)
                                                          .pop()));
                                          return;
                                        }
                                        await _saveStore(context);
                                      } else
                                        setState(() => _autovalidate = true);
                                    },
                                  ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }

  Future<void> _saveStore(BuildContext context) async {
    setState(() => _added = _adding = true);
    await DatabaseService().addStore(Store(
        name: _storename,
        owner: _owner,
        category: _category,
        subcategory: _subcategory,
        description: _description,
        location: _location,
        items: _items,
        phone: _phone,
        position: GeoPoint(_position.latitude, _position.longitude),
        timing: {'from': start1, 'to': end1},
        website: _website,
        images: _imageBytes,
        primaryImage: _primary,
        rating: _rating));
    setState(() => _adding = false);
    showDialog(
        context: context,
        builder: (_) => WillPopScope(
              onWillPop: () =>
                  _adding || _added ? Future.value(false) : Future.value(true),
              child: DialogBox(
                  title: 'Done !',
                  description: 'Store saved Successfully',
                  buttonText1: 'Ok',
                  button1Func: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }),
            ));
  }

  void moveFocus(FocusNode current, FocusNode next) {
    current.unfocus();
    FocusScope.of(context).requestFocus(next);
  }

  Widget rating() {
    return SizedBox(
      height: 30,
      child: FittedBox(
        child: RatingBar(
          initialRating: _rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
            size: 10,
          ),
          onRatingUpdate: (rating) => setState(() => _rating = rating),
        ),
      ),
    );
  }

  DropdownButton selectCategory() {
    return DropdownButton<String>(
      dropdownColor: Colors.white,
      iconEnabledColor: MyColors.primary,
      items: Categories.categoriesList.map((category) {
        return DropdownMenuItem<String>(
          value: category[0],
          child: Container(
            child: ListTile(
                title: Text(
                  category[0],
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: MyColors.primary),
                ),
                trailing: _category == category[0]
                    ? Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    : null),
          ),
        );
      }).toList(),
      underline: Container(),
      onChanged: (value) {
        setState(() {
          _category = value;
        });
      },
      hint: Text(
        _category ?? 'Choose a Category',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      elevation: 15,
      isExpanded: true,
    );
  }

  DropdownButton selectSubcategory(String category) {
    return DropdownButton<String>(
      dropdownColor: Colors.white,
      iconEnabledColor: MyColors.primary,
      items: Categories.subCategoriesList[category]
          .map((subcategory) => DropdownMenuItem<String>(
              value: subcategory,
              child: Container(
                child: ListTile(
                    title: Text(subcategory,
                        style: TextStyle(color: MyColors.primary)),
                    trailing: _subcategory == subcategory
                        ? Icon(
                            Icons.check,
                            color: Colors.green,
                          )
                        : null),
              )))
          .toList(),
      underline: Container(),
      onChanged: (value) {
        setState(() {
          _subcategory = value;
          _showOtherTexttField = value == 'Others' ? true : false;
          if (_showOtherTexttField)
            FocusScope.of(context).requestFocus(_othertextfield);
        });
      },
      hint: Text(
        _subcategory ?? 'Choose a Subcategory',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      elevation: 15,
      isExpanded: true,
    );
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    bool pop = await showDialog<bool>(
        context: context,
        builder: (_) => DialogBox(
              title: 'Cancel',
              description: 'Are you sure you want to cancel adding store ?',
              buttonText1: 'No',
              button1Func: () => Navigator.of(context).pop(false),
              buttonText2: 'Yes',
              button2Func: () {
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop(true);
                Navigator.pop(context);
              },
            ));
    return Future.value(pop);
  }
}

showImage(BuildContext context, Uint8List image) {
  showDialog(
      context: context,
      builder: (_) => Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Image.memory(image)));
}

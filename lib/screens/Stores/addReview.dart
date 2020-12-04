import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:smackit/models/Review.dart';
import 'package:smackit/models/User.dart';
import 'package:smackit/screens/Stores/addStoreold.dart';
import 'package:smackit/services/database.dart';
import 'package:smackit/widgets/CustomButton.dart';
import 'package:smackit/widgets/DailogBox.dart';

import '../../Styles.dart';

class AddReview extends StatefulWidget {
  final String store;
  AddReview({@required this.store}) : assert(store != null);
  @override
  _AddReviewState createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview>
    with SingleTickerProviderStateMixin {
  final chipController = TextEditingController();
  final reviewController = TextEditingController();
  bool _adding = false;
  int _rating = 0;
  String _review, tag;
  TextStyle _label;
  Map<String, dynamic> _tags;
  List<String> _likes = [], _dislikes = [];
  List<Asset> _images = [];
  List<Uint8List> _imageBytes = [];
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    _tags = {'likes': Review.likeTags, 'dislikes': Review.dislikeTags};
    _label = TextStyle(fontSize: 20, color: MyColors.secondary);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Review'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Form(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10),
                    FittedBox(
                        child: Text(widget.store,
                            style: TextStyle(
                                fontSize: 30, color: MyColors.primary))),
                    SizedBox(height: 10),
                    Text(
                      'Rate your experience',
                      style: _label,
                    ),
                    SizedBox(height: 10),
                    rating(),
                    SizedBox(height: 20),
                    _rating == 0
                        ? Container(child: Image.asset('images/review.jpg'))
                        : _reviewBody(_rating)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _reviewBody(int rating) {
    return FadeTransition(
      opacity: animation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _rating == 0
            ? []
            : [
                ..._reviewFields(rating),
                GestureDetector(
                  onTap: _getImages,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text('Add photos', style: _label),
                  ),
                ),
                _imageBytes.length == 0
                    ? GestureDetector(
                        onTap: _getImages,
                        child: Container(
                            height: 100,
                            width: 100,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                                child: Icon(Icons.add_a_photo,
                                    size: 45, color: Colors.grey))),
                      )
                    : Container(
                        height: 100,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: _imageBytes.length,
                          itemBuilder: (context, i) {
                            var image = _imageBytes[i];
                            return GestureDetector(
                              onTap: () => showImage(context, image),
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
                                      borderRadius: BorderRadius.circular(20),
                                    ),
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
                SizedBox(height: 20),
                Text('Write a review', style: _label),
                TextFormField(
                    keyboardType: TextInputType.text,
                    controller: reviewController,
                    minLines: 1,
                    maxLines: 10,
                    maxLength: 150,
                    onChanged: (value) => _review = value.trim()),
                SizedBox(height: 50),
                _adding
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                            Center(child: CircularProgressIndicator()),
                            SizedBox(height: 10),
                            Text(
                              'Adding Review...',
                              style: MyTextStyles.label,
                              textAlign: TextAlign.center,
                            )
                          ])
                    : Row(
                        children: <Widget>[
                          MyButton(
                              text: 'Submit Review', action: _handleAddReview),
                        ],
                      ),
                SizedBox(height: 30),
              ],
      ),
    );
  }

  List<Widget> _reviewFields(int rating) {
    switch (rating) {
      case 1:
        return [
          Text('What did you not like? 🙁', style: _label),
          chipsTextField(_tags['dislikes'], dislike: true)
        ];
        break;
      case 2:
        return [
          Text('What was not upto the mark? 😐', style: _label),
          chipsTextField(_tags['dislikes'], dislike: true),
          SizedBox(height: 10),
          Text('Is there anything you liked? 👍', style: _label),
          chipsTextField(_tags['likes'])
        ];
        break;
      case 3:
        return [
          Text('What was not upto the mark? 😐', style: _label),
          chipsTextField(_tags['dislikes'], dislike: true),
          SizedBox(height: 10),
          Text('What did you like? 🙂', style: _label),
          chipsTextField(_tags['likes'])
        ];
        break;
      case 4:
        return [
          Text('What did you like? 😃', style: _label),
          chipsTextField(_tags['likes']),
          SizedBox(height: 10),
          Text('What did you not like? 🤔', style: _label),
          chipsTextField(_tags['dislikes'], dislike: true)
        ];
        break;
      case 5:
        return [
          Text('What did you love? 🤩', style: _label),
          chipsTextField(_tags['likes'])
        ];
        break;
      default:
        return [];
    }
  }

  Widget chipsTextField(List initial, {bool dislike = false}) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 5),
          Text('Select a tag or Add your own',
              style: TextStyle(color: MyColors.secondary),
              textAlign: TextAlign.start),
          Wrap(
            spacing: 8,
            children: List<Widget>.generate(
              initial.length,
              (index) {
                var item = initial[index];
                bool isSelected =
                    dislike ? _dislikes.contains(item) : _likes.contains(item);
                return InputChip(
                  label: Text(item),
                  labelStyle: TextStyle(color: Colors.black),
                  deleteIcon: Icon(Icons.clear),
                  onDeleted: isSelected
                      ? () => setState(() => dislike
                          ? _dislikes.remove(item)
                          : _likes.remove(item))
                      : null,
                  showCheckmark: false,
                  disabledColor: Colors.white,
                  selectedColor: MyColors.primary,
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected)
                        dislike ? _dislikes.add(item) : _likes.add(item);
                      else
                        dislike ? _dislikes.remove(item) : _likes.remove(item);
                    });
                  },
                );
              },
            ),
          ),
          TextField(
            controller: chipController,
            onChanged: (value) => setState(() => tag = chipController.text),
            decoration: InputDecoration(
              hintText: 'Anything Else you didn\'t like',
              suffixIcon: IconButton(
                  icon: Icon(Icons.add,
                      color: chipController.text.isEmpty
                          ? Colors.grey
                          : MyColors.primary),
                  onPressed: chipController.text.isEmpty
                      ? null
                      : () {
                          chipController.clear();
                          setState(
                            () {
                              if (dislike && !_dislikes.contains(tag))
                                _dislikes.add(tag);
                              else if (!dislike && !_likes.contains(tag))
                                _likes.add(tag);

                              if (!initial.contains(tag)) initial.add(tag);
                            },
                          );
                          print(_likes);
                        }),
            ),
          )
        ]);
  }

  Widget rating() {
    return SizedBox(
      height: 30,
      child: FittedBox(
        child: RatingBar(
          initialRating: 0,
          minRating: 1,
          direction: Axis.horizontal,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
            size: 10,
          ),
          onRatingUpdate: (rating) {
            setState(() => _rating = rating.toInt());
            controller.forward();
          },
        ),
      ),
    );
  }

  Future<void> _handleAddReview() async {
    setState(() => _adding = true);
    Review review = Review(
        rating: _rating.toDouble(),
        reviewerId: CurrentUser.user.email,
        reviewerName: CurrentUser.user.username,
        description: _review,
        dislikes: _dislikes,
        likes: _likes,
        images: _imageBytes);
    await DatabaseService().addReview(widget.store, review);
    setState(() => _adding = false);
    showDialog(
        context: context,
        builder: (_) => WillPopScope(
              onWillPop: () {
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.of(context, rootNavigator: true).pop();
                return Future.value(true);
              },
              child: DialogBox(
                title: 'Done!',
                description: 'Review Added Successfully',
                buttonText1: 'Ok',
                button1Func: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ));
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    bool pop = await showDialog<bool>(
        context: context,
        builder: (_) => DialogBox(
              title: 'Cancel',
              description: 'Are you sure you want to cancel adding review ?',
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

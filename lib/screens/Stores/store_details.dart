import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import '../../Styles.dart';
import 'addReview.dart';
import 'reviews.dart';

class StoreDetails extends StatefulWidget {
  final DocumentSnapshot doc;
  StoreDetails(this.doc);
  @override
  _StoreDetailsState createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  Map<String, dynamic> data;
  int _currentPhoto = 0;
  List _images, _items;
  String from, to;
  @override
  void initState() {
    super.initState();
    data = widget.doc.data();
    _images = data['images'];
    _items = data['items'];
    if (data['timing'] != null) {
      from = DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(
          data['timing']['from'].seconds * 1000));
      to = DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(
          data['timing']['to'].seconds * 1000));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  //slider
                  Stack(
                    children: <Widget>[
                      Container(
                        child: CarouselSlider(
                            carouselController: CarouselController(),
                            options: CarouselOptions(
                              height: MediaQuery.of(context).size.height * 0.35,
                              viewportFraction: 4 / 3,
                              onPageChanged: (page, _) => _currentPhoto = page,
                              autoPlay: false,
                              disableCenter: true,
                              enableInfiniteScroll: !(_images.length == 1),
                            ),
                            items: _images
                                .map((image) => Container(
                                      child: Center(
                                        child: Image.network(image,
                                            fit: BoxFit.cover,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width),
                                      ),
                                    ))
                                .toList()),
                      ),
                      Positioned(
                          top: 2,
                          left: 2,
                          child: IconButton(
                              icon: Icon(Icons.arrow_back),
                              color: MyColors.secondary,
                              onPressed: () => Navigator.of(context).pop()))
                    ],
                  ),
                  // detaiils
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  data['name'],
                                  softWrap: true,
                                  style: TextStyle(
                                      letterSpacing: 1,
                                      color: MyColors.secondary,
                                      fontSize: 30),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: FittedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        data['category'],
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      if (!data['subcategory']
                                          .toString()
                                          .startsWith('Others'))
                                        Text(
                                          ', ${data['subcategory']}',
                                          style: TextStyle(fontSize: 18),
                                        )
                                      else
                                        Text(
                                            ', ${data['subcategory'].toString().split(' ').last}',
                                            style: TextStyle(fontSize: 18)),
                                    ],
                                  ),
                                  SizedBox(width: 10),
                                  InkWell(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Text('See Reviews',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: MyColors.secondary)),
                                    ),
                                    onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => AllReviews(
                                            storeName: data['name'],
                                            store: widget.doc.reference),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                  height: 25,
                                  child: FittedBox(
                                    child: AbsorbPointer(
                                      absorbing: true,
                                      child: RatingBar(
                                        onRatingUpdate: null,
                                        initialRating: double.parse(
                                            data['rating'].toString()),
                                        allowHalfRating: true,
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                  )),
                              SizedBox(width: 10),
                              Text(data['rating'].toString(),
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(width: 10),
                              Text('200 reviews',
                                  style: TextStyle(fontSize: 15))
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: MyColors.secondary,
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                child: Text(data['location'],
                                    style: TextStyle(
                                        letterSpacing: 1,
                                        fontFamily: 'Roboto')),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          if (data['phone'] != null)
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.phone,
                                  color: MyColors.secondary,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                    child: Text(
                                  data['phone'],
                                  style: TextStyle(fontFamily: 'Roboto'),
                                )),
                              ],
                            ),
                          SizedBox(height: 10),
                          if (data['timing'] != null)
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  color: MyColors.secondary,
                                ),
                                SizedBox(width: 10),
                                Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: Text(
                                      '$from - $to',
                                      style: TextStyle(fontFamily: 'Roboto'),
                                    )),
                              ],
                            ),
                          SizedBox(height: 10),
                          Divider(color: Colors.grey),
                          // actions
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              OptionButton(
                                text: 'Review',
                                icon: Icons.rate_review,
                                action: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (_) =>
                                        AddReview(store: data['name']),
                                  ),
                                ),
                              ),
                              OptionButton(
                                  text: 'Favourite',
                                  icon: Icons.favorite,
                                  action: () {}),
                              OptionButton(
                                  text: 'Report',
                                  icon: Icons.flag,
                                  action: () {}),
                              OptionButton(
                                  text: 'Share',
                                  icon: Icons.share,
                                  action: () {})
                            ],
                          ),
                          Divider(color: Colors.grey)
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 10),
                    child: Text('Items:', style: MyTextStyles.label),
                  ),
                  ItemList(_items),
                  SizedBox(height: 50)
                ]),
          ),
        ),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List items;
  ItemList(this.items);
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(
          items.length,
          (index) {
            var item = items[index];
            return Container(
              color: index % 2 == 0 ? MyColors.primary.withOpacity(0.3) : null,
              child: ListTile(
                title: Text(item['name']),
                trailing: Text('₹${item['price']}',
                    style: TextStyle(
                        fontFamily: 'Roboto', color: MyColors.secondary)),
              ),
            );
          },
        ));
  }
}

class OptionButton extends StatelessWidget {
  const OptionButton({
    @required this.action,
    @required this.text,
    @required this.icon,
    Key key,
  }) : super(key: key);
  final String text;
  final IconData icon;
  final Function action;
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
              icon: Icon(
                icon,
                color: MyColors.secondary,
              ),
              onPressed: action),
          Text(text, style: TextStyle(color: MyColors.secondary))
        ],
      ),
    );
  }
}

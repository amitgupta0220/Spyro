import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import '../../Styles.dart';
import 'addReview.dart';

class AllReviews extends StatefulWidget {
  final DocumentReference store;
  final String storeName;
  const AllReviews({@required this.store, @required this.storeName})
      : assert(store != null && storeName != null);
  @override
  _AllReviewsState createState() => _AllReviewsState();
}

class _AllReviewsState extends State<AllReviews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reviews'), centerTitle: true),
      body: FutureBuilder<QuerySnapshot>(
        future: widget.store
            .collection('reviews')
            .orderBy('timestamp', descending: true)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          List<DocumentSnapshot> reviews = snapshot.data.docs;
          if (reviews.length == 0)
            return Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('No Reviews yet :(', style: MyTextStyles.label),
                  SizedBox(height: 20),
                  RaisedButton(
                      onPressed: () => Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (_) => AddReview(store: widget.storeName),
                          )),
                      color: MyColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 30.0),
                        child:
                            Text('Add Review', style: TextStyle(fontSize: 15)),
                      ))
                ],
              ),
            );
          return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (_, i) {
                var review = reviews[i].data();
                return ReviewCard(review);
              });
        },
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;
  final bool showStorename;
  const ReviewCard(this.review, {Key key, this.showStorename = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    DateTime time =
        DateTime.fromMillisecondsSinceEpoch(review['timestamp'].seconds * 1000);
    List tags = review['likes'];
    tags.addAll(review['dislikes']);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Card(
        color: MyColors.primaryLight,
        elevation: 5,
        shadowColor: Colors.grey[900],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
                leading: CircleAvatar(
                    child: Icon(
                        showStorename ? Icons.store : Icons.account_circle)),
                title: Text(review['store'], style: MyTextStyles.label),
                trailing: Text(DateFormat('d MMM yyyy').format(time),
                    style: TextStyle(fontFamily: 'Roboto'))),
            SizedBox(height: 5),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      height: 25,
                      child: FittedBox(
                        child: AbsorbPointer(
                          absorbing: true,
                          child: RatingBar(
                            onRatingUpdate: null,
                            initialRating:
                                double.parse(review['rating'].toString()),
                            allowHalfRating: true,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                          ),
                        ),
                      )),
                ),
                SizedBox(width: 10),
                Text(review['rating'].toString(),
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 5),
            if (tags.length != 0)
              Wrap(
                spacing: 8,
                children: List<Widget>.generate(
                  tags.length,
                  (index) => Chip(
                    label: Text(tags[index]),
                    backgroundColor: MyColors.primary,
                  ),
                ),
              ),
            if (review['review'] != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(review['review'],
                    style: MyTextStyles.label,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis),
              )
          ],
        ),
      ),
    );
  }
}

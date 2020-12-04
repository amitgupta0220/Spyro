import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smackit/models/User.dart';
import 'package:smackit/screens/Stores/reviews.dart';

import '../../Styles.dart';

class MyReviews extends StatefulWidget {
  @override
  _MyReviewsState createState() => _MyReviewsState();
}

class _MyReviewsState extends State<MyReviews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Reviews'),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(CurrentUser.user.email)
            .collection('my_reviews')
            .orderBy('timestamp', descending: true)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          List<DocumentSnapshot> reviews = snapshot.data.docs;
          if (reviews.length == 0)
            return Center(
                child: Text('You haven\'t reviewed anything :(',
                    style: MyTextStyles.label));
          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (_, i) {
              var review = reviews[i].data;
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('stores')
                    .doc(review()['store'])
                    .collection('reviews')
                    .doc(review()['review_id'])
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Container(
                        height: 100,
                        child: Center(child: CircularProgressIndicator()));
                  Map<String, dynamic> review = snapshot.data.data();
                  return ReviewCard(review, showStorename: true);
                },
              );
            },
          );
        },
      ),
    );
  }
}

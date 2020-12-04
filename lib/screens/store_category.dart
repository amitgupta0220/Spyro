import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Home.dart';

class StoreCategory extends StatefulWidget {
  final String category;
  StoreCategory(this.category);
  @override
  _StoreCategoryState createState() => _StoreCategoryState();
}

class _StoreCategoryState extends State<StoreCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.category),
          centerTitle: true,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Stores(
              stream: FirebaseFirestore.instance
                  .collection('stores')
                  .where('category', isEqualTo: widget.category)
                  .snapshots(),
              isSliver: false),
        ));
  }
}

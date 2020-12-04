import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smackit/models/User.dart';
import '../../Styles.dart';
import '../Home.dart';

class MyStores extends StatefulWidget {
  @override
  _MyStoresState createState() => _MyStoresState();
}

class _MyStoresState extends State<MyStores> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Stores'),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('stores')
            .where('added_by', isEqualTo: CurrentUser.user.email)
            .orderBy('timestamp', descending: true)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          List<DocumentSnapshot> stores = snapshot.data.docs;
          if (stores.length == 0)
            return Center(
                child: Text('You haven\'t added any store :(',
                    style: MyTextStyles.label));
          return ListView.builder(
              itemCount: stores.length,
              itemBuilder: (_, i) => StoreCard(store: stores[i]));
        },
      ),
    );
  }
}

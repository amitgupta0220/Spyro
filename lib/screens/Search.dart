import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Stores/store_details.dart';
import '../Styles.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  // final _searchFocus = FocusNode();
  // bool _isSearch = false;
  String _query = '';
  Timer _debounce;
  var strFrontCode, strEndCode, startCode, endCode;
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        if (_searchController.text.isNotEmpty) {
          _query = _searchController.text.toLowerCase();
          //for one word
          _query = _query.length == 1
              ? _query.toUpperCase()
              : _query.substring(0, 1).toUpperCase() + _query.substring(1);
          // for multiple words
          List<String> words = _query.split(' ');
          if (words.length > 1) {
            for (var i = 1; i < words.length; i++)
              words[i] = words[i].length == 1
                  ? words[i].toUpperCase()
                  : words[i].substring(0, 1).toUpperCase() +
                      words[i].substring(1);
            _query = words.join(' ');
          }
        } else {
          _query = '';
          return;
        }
        var len = _query.length;
        strFrontCode = _query.substring(0, len - 1);
        strEndCode = _query.substring(len - 1, len);
        startCode = _query;
        endCode =
            strFrontCode + String.fromCharCode(strEndCode.codeUnitAt(0) + 1);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    try {
      _debounce.cancel();
    } catch (e) {
      print(e.toString());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: TextStyle(fontSize: 18),
          decoration: InputDecoration(
              hintText: 'Search Stores',
              fillColor: MyColors.primaryLight,
              filled: true,
              suffixIcon: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.clear)),
              contentPadding: const EdgeInsets.only(left: 15),
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 0, style: BorderStyle.none),
                  borderRadius: BorderRadius.circular(25))),
        ),
      ),
      body: SafeArea(
          child: _query.length == 0
              ? Center(child: Text('Find your Nearby Stores'))
              : FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('stores')
                      .where('name', isGreaterThanOrEqualTo: startCode)
                      .where('name', isLessThan: endCode)
                      .get(),
                  builder: (_, snapshot) {
                    if (!snapshot.hasData)
                      return Center(child: CircularProgressIndicator());
                    List<DocumentSnapshot> stores = snapshot.data.documents;
                    if (snapshot.data == null || stores.length == 0)
                      return Center(
                        child: Text('No such Store'),
                      );
                    return ListView.builder(
                        itemCount: stores.length,
                        itemBuilder: (_, index) {
                          var store = stores[index].data;
                          return Card(
                            color: MyColors.primary,
                            child: ListTile(
                              onTap: () => Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (ctx) =>
                                          StoreDetails(stores[index]))),
                              title: Text(store()['name']),
                              subtitle: Text(store()['category']),
                              leading: CircleAvatar(
                                  child: Icon(Icons.store,
                                      color: MyColors.secondary)),
                            ),
                          );
                        });
                  })),
    );
  }
}

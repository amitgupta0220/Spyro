import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smackit/Styles.dart';
import 'package:smackit/screens/Stores/ViewStores.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  Stream streamQuery;

  searchQuery(String query) {
    Stream<QuerySnapshot> queryResult = FirebaseFirestore.instance
        .collection('stores_new')
        .where('name'.toLowerCase(),
            isGreaterThanOrEqualTo: query.toLowerCase())
        .snapshots();
    setState(() {
      streamQuery = queryResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            Container(
              color: MyColors.primaryLight,
              height: MediaQuery.of(context).size.height * 0.13,
              width: MediaQuery.of(context).size.width,
              child: Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05,
                  top: MediaQuery.of(context).size.width * 0.1,
                  bottom: MediaQuery.of(context).size.width * 0.03,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.03,
                          right: MediaQuery.of(context).size.width * 0.03),
                      child:
                          SvgPicture.asset('assets/images/searchForHome.svg'),
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: _searchController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintStyle:
                              TextStyle(fontSize: 14, color: Color(0xff9D9D9D)),
                          hintText: 'Search for food, hardware, pets...',
                        ),
                        onChanged: (value) {
                          searchQuery(value);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            _searchController.text == ""
                ? Container(
                    alignment: Alignment.center,
                    child: Center(child: Text("Type something to search")),
                  )
                : Flexible(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: streamQuery,
                      builder: (context, snapshot) {
                        List<Widget> listOfStores = [];
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasData) {
                          final datas = snapshot.data.docs;
                          for (var data in datas) {
                            String location = data.data()['Address'];
                            var category = data.data()['category'];
                            var name = data.data()['name'];
                            // var rating = data.data()['rating'];
                            var phoneNo = data.data()['Phone No'];
                            var rating = 3.0;
                            var uid = data.data()['uid'];
                            // var email = data.data()['email'];
                            listOfStores.add(ListOfStoreDisplay(
                              // email: email,
                              phoneNo: phoneNo ?? "2222222222",
                              timing: '09:00AM-06:00PM',
                              uid: uid,
                              address: location,
                              category: category,
                              name: name,
                              rating: rating,
                            ));
                          }
                          return ListView(
                              // physics: NeverScrollableScrollPhysics(),
                              primary: false,
                              children: listOfStores);
                        }
                        return Center(child: Text("Type something to search"));
                      },
                    ),
                  )
          ])),
    );
  }
}

class ListOfStoreDisplay extends StatelessWidget {
  final String name, category, address, uid, email, timing, phoneNo;
  final rating;
  ListOfStoreDisplay(
      {this.name,
      this.phoneNo,
      this.timing,
      this.address,
      this.category,
      this.rating,
      this.uid,
      this.email});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ViewStores(
                name, phoneNo, timing, address, category, rating, uid)));
      },
      child: Container(
        margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.height * 0.02,
          right: MediaQuery.of(context).size.height * 0.02,
          bottom: MediaQuery.of(context).size.height * 0.02,
        ),
        child: Container(
            margin: EdgeInsets.only(bottom: 8),
            height: 20,
            color: Colors.white,
            child: Text(name)),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:smackit/Styles.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width * 0.138,
        leading: Container(
          margin:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
          child: SvgPicture.asset(
            'assets/images/SplashLogo.svg',
          ),
        ),
        title: Text(
          "Location",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            decoration: TextDecoration.underline,
            // decorationStyle: TextDecorationStyle.dashed
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.05),
            child: SvgPicture.asset('assets/images/rewardForHome.svg'),
          ),
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.05),
            child: SvgPicture.asset('assets/images/bellForHome.svg'),
          ),
        ],
        elevation: 0,
        backgroundColor: MyColors.primaryLight,
      ),
      backgroundColor: MyColors.primary,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: MyColors.primaryLight,
                height: MediaQuery.of(context).size.height * 0.085,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: MediaQuery.of(context).size.width * 0.05,
                    bottom: MediaQuery.of(context).size.width * 0.03,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4)),
                  child: Row(
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
                            hintStyle: TextStyle(
                                fontSize: 14, color: Color(0xff9D9D9D)),
                            hintText: 'Search for food, hardware, pets...',
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.03,
                    left: MediaQuery.of(context).size.width * 0.03,
                    right: MediaQuery.of(context).size.width * 0.03),
                decoration: BoxDecoration(
                    color: MyColors.primaryLight,
                    borderRadius: BorderRadius.circular(4)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.037,
                        top: MediaQuery.of(context).size.width * 0.04,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("New Discounts",
                              style: TextStyle(
                                color: Color(0xffFFCE47),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              )),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015,
                          ),
                          Text("20% Off on All\nProducts",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ))
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * 0.04,
                      ),
                      alignment: Alignment.bottomRight,
                      child:
                          SvgPicture.asset('assets/images/ellipseForHome.svg'),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.01,
              ),
              Container(
                height: MediaQuery.of(context).size.width * 0.8,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('stores')
                      .where('location', isEqualTo: 'Mumbai')
                      .limit(4)
                      .snapshots(),
                  builder: (context, snapshot) {
                    List<Widget> storeList = [];
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData) {
                      final datas = snapshot.data.docs;
                      for (var data in datas) {
                        print(data);
                        var location = data.data()['address'];
                        var category = data.data()['category'];
                        var name = data.data()['name'];
                        var rating = data.data()['rating'];
                        storeList.add(StoreDisplay(
                          address: location,
                          category: category,
                          name: name,
                          rating: rating,
                        ));
                      }
                      return ListView(
                        children: storeList,
                      );
                    }
                    return Container();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class StoreDisplay extends StatelessWidget {
  final String name, category, address;
  final int rating;
  StoreDisplay({this.name, this.address, this.category, this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.028),
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.height * 0.02,
        right: MediaQuery.of(context).size.height * 0.02,
        top: MediaQuery.of(context).size.height * 0.02,
      ),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.01),
          blurRadius: 4.0,
          spreadRadius: 5.0,
          offset: Offset(
            0.0,
            0.0,
          ),
        ),
      ], color: Colors.white, borderRadius: BorderRadius.circular(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Color(0xffc5c5c5),
            ),
            height: MediaQuery.of(context).size.height * 0.17,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Column(
            children: [
              Text(
                name,
                style: TextStyle(
                    color: Color(0xff292929),
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              )
            ],
          )
        ],
      ),
    );
  }
}

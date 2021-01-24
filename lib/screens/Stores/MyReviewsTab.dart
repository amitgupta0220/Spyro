import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smackit/Styles.dart';

class MyReviewsTab extends StatefulWidget {
  @override
  _MyReviewsTabState createState() => _MyReviewsTabState();
}

class _MyReviewsTabState extends State<MyReviewsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: MediaQuery.of(context).size.width * 0.15,
        leading: Container(
          margin:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: SvgPicture.asset(
              'assets/images/arrowWhite.svg',
            ),
          ),
        ),
        title: Container(
          margin:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.134),
          child: Text(
            'My Reviews ',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
        ),
        elevation: 0,
        backgroundColor: MyColors.primaryLight,
      ),
      backgroundColor: MyColors.background,
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [],
            ),
          )),
    );
  }
}

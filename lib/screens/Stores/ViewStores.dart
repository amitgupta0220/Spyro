import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smackit/Styles.dart';

class ViewStores extends StatefulWidget {
  final String timing, phoneNo, name, address, category, uid;
  final double rating;
  ViewStores(
    this.name,
    this.phoneNo,
    this.timing,
    this.address,
    this.category,
    this.rating,
    this.uid,
  );
  @override
  _ViewStoresState createState() => _ViewStoresState();
}

class _ViewStoresState extends State<ViewStores> {
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
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.2),
          child: Text(
            'Stores ',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
        ),
        elevation: 0,
        backgroundColor: MyColors.primaryLight,
      ),
      backgroundColor: MyColors.background,
      body: Container(
          // height: MediaQuery.of(context).size.height,
          // width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width,
              color: Color(0xffc5c5c5),
            ),
            Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.028),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                        color: Color(0xff292929),
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  Text(
                    widget.category,
                    style: TextStyle(
                        color: Color(0xff858585),
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  Row(
                    children: [
                      RatingBar(
                          itemSize: 25,
                          onRatingUpdate: null,
                          initialRating: widget.rating.toDouble(),
                          allowHalfRating: true,
                          itemBuilder: (context, _) => SvgPicture.asset(
                                'assets/images/starForHome.svg',
                              )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Text(widget.rating.toString())
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/locationForProfile.svg',
                        color: MyColors.primaryLight,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Flexible(
                          child: Text(
                        widget.address,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff858585)),
                      ))
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/phoneForProfile.svg',
                        color: MyColors.primaryLight,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Flexible(
                          child: Text(
                        widget.phoneNo.isEmpty ? "2222222222" : widget.phoneNo,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff858585)),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset('assets/images/clockForAddStore.svg'),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Flexible(
                          child: Text(
                        widget.timing,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff858585)),
                      )),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              color: MyColors.primaryLight,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    // padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/images/reviewStore.svg",
                          height: MediaQuery.of(context).size.height * 0.025,
                        ),
                        Text(
                          "Review",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                  Container(
                    // padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/images/favouriteStore.svg",
                          height: MediaQuery.of(context).size.height * 0.025,
                        ),
                        Text(
                          "Favourite",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                  Container(
                    // padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/images/reportStore.svg",
                          height: MediaQuery.of(context).size.height * 0.025,
                        ),
                        Text(
                          "Report",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                  Container(
                    // padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/images/shareStore.svg",
                          height: MediaQuery.of(context).size.height * 0.025,
                        ),
                        Text(
                          "Share",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}

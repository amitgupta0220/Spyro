import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smackit/Styles.dart';
import 'package:smackit/LoginRegister/CustomerRegistrationPage.dart';
import 'package:smackit/LoginRegister/SellerRegistrationPage.dart';

class NavPageRegistration extends StatefulWidget {
  @override
  _NavPageRegistrationState createState() => _NavPageRegistrationState();
}

class _NavPageRegistrationState extends State<NavPageRegistration>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    tabController = new TabController(vsync: this, length: 2);
    tabController.addListener(_tabSelect);
  }

  void _tabSelect() {
    setState(() {
      _currentIndex = tabController.index;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.background,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // alignment: Alignment.center,
          child: Column(
            children: [
              Center(
                  child: Column(children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.055,
                    width: MediaQuery.of(context).size.width * 0.08,
                    margin: EdgeInsets.only(
                        bottom: 5,
                        top: MediaQuery.of(context).size.height * 0.05),
                    child: Image.asset('assets/images/onboardingLogo.png')),
                Text(
                  "Explore your favorites\n around you.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Color(0xff858585)),
                )
              ])),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              // TabBar(
              //   onTap: (number) {
              //     setState(() {});
              //   },
              //   indicatorWeight: 0.1,
              //   controller: tabController,
              //   indicatorColor: MyColors.bg,
              //   tabs: <Widget>[
              //     Container(
              //       color: tabController.index == 0
              //           ? MyColors.bg
              //           : MyColors.background,
              //       // margin: EdgeInsets.only(left: 20, right: 0),
              //       child: Tab(child: Text("Customer")),
              //     ),
              //     Container(
              //       color: tabController.index == 1
              //           ? MyColors.bg
              //           : MyColors.background,
              //       // margin: EdgeInsets.only(right: 20, left: 0),
              //       child: Tab(child: Text("Seller")),
              //     )
              //   ],
              // ),
              Container(
                  // decoration: BoxDecoration(
                  //     color: MyColors.background,
                  //     // color: tabController.index == 1
                  //     //     ? MyColors.bg
                  //     //     : MyColors.background,
                  //     borderRadius: BorderRadius.circular(2),
                  //     border: Border.all(width: 1, color: Color(0xffc8c8c8))),
                  height: MediaQuery.of(context).size.height * 0.055,
                  // color: MyColors.bg,
                  width: MediaQuery.of(context).size.width / 1.58,
                  child: Stack(children: [
                    tabController.index == 0
                        ? SvgPicture.asset('assets/images/leftBox.svg')
                        : SvgPicture.asset('assets/images/rightBox.svg'),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          tabController.index = 0;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3.15,
                        color: Colors.transparent,
                        // child: Row(children: [
                        //   Container(
                        //     color: Colors.black,
                        //   )
                        // ]),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          tabController.index = 1;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 3.15),
                        width: MediaQuery.of(context).size.width / 3.15,
                        color: Colors.transparent,
                        // child: Row(children: [
                        //   Container(
                        //     color: Colors.black,
                        //   )
                        // ]),
                      ),
                    ),
                  ])),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    CustomerRegistrationPage(),
                    SellerRegistrationPage()
                  ],
                  controller: tabController,
                ),
              )
            ],
          ),
        ));
  }
}

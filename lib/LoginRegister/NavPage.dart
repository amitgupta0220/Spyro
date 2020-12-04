import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smackit/Styles.dart';
import 'package:smackit/LoginRegister/CustomerLogin.dart';
import 'package:smackit/LoginRegister/SellerLogin.dart';

class NavPage extends StatefulWidget {
  @override
  _NavPageState createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> with SingleTickerProviderStateMixin {
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
                  //   color: MyColors.background,
                  //   // color: tabController.index == 1
                  //   //     ? MyColors.bg
                  //   //     : MyColors.background,
                  //   borderRadius: BorderRadius.circular(4),
                  // ),
                  // color: MyColors.background,
                  height: MediaQuery.of(context).size.height * 0.055,
                  // color: MyColors.bg,
                  width: MediaQuery.of(context).size.width / 1.58,
                  // child: Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     GestureDetector(
                  //         onTap: () {
                  //           setState(() {
                  //             tabController.index = 0;
                  //             _currentIndex = 0;
                  //           });
                  //         },
                  //         child: Container(
                  //           // margin: EdgeInsets.only(
                  //           //     left: tabController.index == 0
                  //           //         ? MediaQuery.of(context).size.width * 0.008
                  //           //         : MediaQuery.of(context).size.width * 0.001),
                  //           decoration: BoxDecoration(
                  //               color: _currentIndex == 0
                  //                   ? MyColors.bg
                  //                   : MyColors.background,
                  //               borderRadius:
                  //                   BorderRadius.all(Radius.circular(4)),
                  //               border: Border(
                  //                   right: BorderSide(
                  //                       width: 1,
                  //                       color: tabController.index == 0
                  //                           ? MyColors.bg
                  //                           : Color(0xffc8c8c8)),
                  //                   bottom: BorderSide(
                  //                       width: 1,
                  //                       color: tabController.index == 0
                  //                           ? MyColors.bg
                  //                           : Color(0xffc8c8c8)),
                  //                   left: BorderSide(
                  //                       width: 1,
                  //                       color: tabController.index == 0
                  //                           ? MyColors.bg
                  //                           : Color(0xffc8c8c8)),
                  //                   top: BorderSide(
                  //                       width: 1,
                  //                       color: tabController.index == 0
                  //                           ? MyColors.bg
                  //                           : Color(0xffc8c8c8)))),
                  //           child: Center(
                  //               child: Text(
                  //             "Customer",
                  //             style: TextStyle(
                  //                 fontSize: 16,
                  //                 color: _currentIndex == 0
                  //                     ? Colors.white
                  //                     : Color(0xffc8c8c8)),
                  //           )),
                  //           height: 100,
                  //           width: MediaQuery.of(context).size.width / 3.2,
                  //         )),
                  //     GestureDetector(
                  //       onTap: () {
                  //         setState(() {
                  //           tabController.index = 1;
                  //           _currentIndex = 1;
                  //         });
                  //       },
                  //       child: Container(
                  //         // margin: EdgeInsets.only(
                  //         //     left: tabController.index == 0
                  //         //         ? MediaQuery.of(context).size.width / 3.1
                  //         //         : MediaQuery.of(context).size.width / 3.2),
                  //         decoration: BoxDecoration(
                  //             color: _currentIndex == 1
                  //                 ? MyColors.bg
                  //                 : Colors.transparent,
                  //             borderRadius: tabController.index == 1
                  //                 ? BorderRadius.all(Radius.circular(4))
                  //                 : BorderRadius.only(
                  //                     topRight: Radius.circular(4),
                  //                     bottomRight: Radius.circular(4)),
                  //             border: Border(
                  //                 left: BorderSide(
                  //                     width: 1,
                  //                     color: tabController.index == 1
                  //                         ? MyColors.bg
                  //                         : Color(0xffc8c8c8)),
                  //                 bottom: BorderSide(
                  //                     width: 1,
                  //                     color: tabController.index == 1
                  //                         ? MyColors.bg
                  //                         : Color(0xffc8c8c8)),
                  //                 right: BorderSide(
                  //                     width: 1,
                  //                     color: tabController.index == 1
                  //                         ? MyColors.bg
                  //                         : Color(0xffc8c8c8)),
                  //                 top: BorderSide(
                  //                     width: 1,
                  //                     color: tabController.index == 1
                  //                         ? MyColors.bg
                  //                         : Color(0xffc8c8c8)))),
                  //         child: Center(
                  //             child: Text(
                  //           "Seller",
                  //           style: TextStyle(
                  //               fontSize: 16,
                  //               color: _currentIndex == 1
                  //                   ? Colors.white
                  //                   : Color(0xffc8c8c8)),
                  //         )),
                  //         height: 100,
                  //         width: MediaQuery.of(context).size.width / 3.2,
                  //       ),
                  //     )
                  //   ],
                  // ),
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
                  children: <Widget>[CustomerLogin(), SellerLogin()],
                  controller: tabController,
                ),
              )
            ],
          ),
        ));
  }
}

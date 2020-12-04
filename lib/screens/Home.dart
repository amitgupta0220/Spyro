import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:smackit/services/database.dart';
import 'package:smackit/widgets/DailogBox.dart';
import '../models/Categories.dart';
import '../models/User.dart';
import '../models/Screen.dart';
import '../Styles.dart';
import 'Search.dart';
import 'Stores/addStoreold.dart';
import 'Stores/store_details.dart';
import 'store_category.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String email;
  String username;

  @override
  void initState() {
    super.initState();
    UserData.getUser().then((userInfo) => setState(() {
          email = userInfo['email'];
          username = userInfo['uname'];
        }));
  }

  int _currentindex = 0;
  bool showDot3 = true, showDot4 = true;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentindex == 0) {
          bool exit = await showDialog<bool>(
              context: context,
              builder: (_) => DialogBox(
                    title: 'Exit',
                    description: 'Are you sure you want to Exit ?',
                    buttonText1: 'No',
                    button1Func: () => Navigator.of(context).pop(false),
                    buttonText2: 'Yes',
                    button2Func: () => Navigator.of(context).pop(true),
                  ));
          return exit;
        } else
          setState(() {
            _currentindex = 0;
          });
        return Future.value(false);
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentindex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: MyColors.primaryLight,
            selectedItemColor: MyColors.secondary,
            selectedIconTheme: IconThemeData(color: MyColors.secondary),
            unselectedIconTheme: IconThemeData(color: MyColors.primary),
            onTap: (index) {
              switch (index) {
                case 2:
                  Navigator.of(context).push(MaterialPageRoute(
                      fullscreenDialog: true, builder: (_) => AddStoreOld()));
                  break;
                case 3:
                  setState(() {
                    showDot3 = false;
                    _currentindex = index;
                  });
                  break;
                case 4:
                  setState(() {
                    showDot4 = false;
                    _currentindex = index;
                  });
                  break;
                default:
                  setState(() => _currentindex = index);
              }
            },
            items: Screen.pages.map((p) {
              return BottomNavigationBarItem(
                  icon: Stack(
                    // clipBehavior: Clip.hardEdge,
                    children: <Widget>[
                      Icon(
                        p.icon,
                        color: MyColors.primary,
                      ),
                      if ((p == Screen.pages[3] && showDot3) ||
                          (p == Screen.pages[4] && showDot4))
                        Positioned(
                            right: 0,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: MyColors.secondary),
                            ))
                    ],
                  ),
                  activeIcon: Column(
                    children: <Widget>[
                      if (_currentindex == p.index)
                        Container(
                            height: 2, width: 50, color: MyColors.secondary),
                      SizedBox(height: 5),
                      Icon(p.activeIcon),
                    ],
                  ),
                  label: p.title);
            }).toList()),
        body: SafeArea(
          top: false,
          child: IndexedStack(
              index: _currentindex,
              children: Screen.pages.map((p) => p.page).toList()),
        ),
      ),
    );
  }
}

// class ScreenView extends StatelessWidget {
//   final Screen screen;
//   ScreenView(this.screen);
//   final screens = Screen.pages;
//   @override
//   Widget build(BuildContext context) {
//     return Navigator(
//       onGenerateRoute: (setting) {
//         return MaterialPageRoute(builder: (_) {
//           switch (screen.route) {
//             case '/home':
//               return screens[0].page;
//             case '/map':
//               return screens[1].page;
//             case '/add_store':
//               return screens[2].page;
//             case '/chats':
//               return screens[3].page;
//             case '/profile':
//               return screens[4].page;
//             default:
//               return Container();
//           }
//         });
//       },
//     );
//   }
// }

class HomePageOld extends StatefulWidget {
  @override
  _HomePageOldState createState() => _HomePageOldState();
}

class _HomePageOldState extends State<HomePageOld> {
  // final _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    FirebaseMessaging fcm = FirebaseMessaging();
    if (Platform.isIOS)
      fcm.requestNotificationPermissions(IosNotificationSettings());
    fcm.configure(
      onMessage: (message) {
        print(message);
        return;
      },
      onResume: (message) {
        print(message);
        return;
      },
      onLaunch: (message) {
        print(message);
        return;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                child: Image(
                    image: AssetImage('images/logo.png'),
                    fit: BoxFit.contain,
                    height: 40)),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Spyro'),
                Row(
                  children: <Widget>[
                    Icon(Icons.location_on, size: 15),
                    SizedBox(width: 5),
                    Text(
                      'Mumbai',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
              splashColor: Colors.yellow,
              icon: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Icon(Feather.gift),
                  Positioned(
                      right: -5,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: MyColors.secondary),
                      ))
                ],
              ),
              onPressed: () {}),
          IconButton(
              splashColor: Colors.yellow,
              icon: Stack(
                children: <Widget>[
                  Icon(Icons.notifications),
                  Positioned(
                      right: 2,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: MyColors.secondary),
                      ))
                ],
              ),
              onPressed: () {})
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          return Future.value(true);
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              title: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => SearchScreen())),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: MyColors.primaryLight),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text('Search',
                                  style: TextStyle(color: Colors.grey)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child:
                                  Icon(Icons.search, color: MyColors.secondary),
                            )
                          ],
                        )),
                  )),
              centerTitle: true,
              elevation: 2,
              floating: true,
            ),
            SliverToBoxAdapter(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    PromoSlider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10),
                      child: Text(
                        'So, What are you looking for ?',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                  ]),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: CategoryTiles(),
            ),
            Stores()
          ],
        ),
      ),
    );
  }
}

class CategoryTiles extends StatelessWidget {
  CategoryTiles({
    Key key,
  }) : super(key: key);

  final List<List<String>> categories = Categories.categoriesList;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 100.0,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 1.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => StoreCategory(categories[index][0]))),
            child: Container(
              decoration: BoxDecoration(
                color: MyColors.primary,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter:
                        ColorFilter.mode(Colors.black38, BlendMode.darken),
                    image: NetworkImage(categories[index][1])),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(categories[index][0],
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          );
        },
        childCount: categories.length,
      ),
    );
  }
}

class PromoSlider extends StatefulWidget {
  const PromoSlider({
    Key key,
  }) : super(key: key);

  @override
  _PromoSliderState createState() => _PromoSliderState();
}

class _PromoSliderState extends State<PromoSlider> {
  int _currentPromo = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DatabaseService().getPromos().asStream(),
        builder: (_, AsyncSnapshot<List> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) return Container();
          return Container(
            padding: const EdgeInsets.only(top: 10),
            child: CarouselSlider(
              options: CarouselOptions(
                  onPageChanged: (page, _) => _currentPromo = page,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 500),
                  autoPlayInterval: Duration(seconds: 3)),
              items: snapshot.data
                  .map((item) => Container(
                        child:
                            Image.network(item, fit: BoxFit.cover, width: 1000),
                      ))
                  .toList(),
            ),
          );
        });
  }
}

class Stores extends StatefulWidget {
  final Stream<QuerySnapshot> stream;
  final bool isSliver;
  const Stores({Key key, this.stream, this.isSliver = true}) : super(key: key);
  @override
  _StoresState createState() => _StoresState();
}

class _StoresState extends State<Stores> {
  Stream<QuerySnapshot> _stream;
  @override
  void initState() {
    super.initState();
    _stream = widget.stream ??
        FirebaseFirestore.instance.collection('stores').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return widget.isSliver
                ? SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  );
          List<DocumentSnapshot> stores = snapshot.data.docs;
          if (stores.length == 0)
            return Center(child: Text('No Stores in This Category'));
          return widget.isSliver
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    var store = stores[index];
                    return StoreCard(store: store);
                  }, childCount: stores.length),
                )
              : ListView.builder(
                  itemCount: stores.length,
                  itemBuilder: (_, index) {
                    var store = stores[index];
                    return StoreCard(store: store);
                  },
                );
        });
  }
}

class StoreCard extends StatelessWidget {
  const StoreCard({Key key, @required this.store, this.showDetails = false})
      : super(key: key);

  final DocumentSnapshot store;
  final bool showDetails;
  @override
  Widget build(BuildContext context) {
    String from, to;
    if (store.data()['timing'] != null) {
      from = DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(
          store.data()['timing']['from'].seconds * 1000));
      to = DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(
          store.data()['timing']['to'].seconds * 1000));
    }
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => StoreDetails(store))),
      child: Card(
        margin: EdgeInsets.all(showDetails ? 15 : 10),
        color: Colors.yellow[600],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 180,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  image: DecorationImage(
                      image: NetworkImage(store.data()['images']
                          [store.data()['primary_image']]),
                      fit: BoxFit.cover)),
            ),
            Padding(
              padding: showDetails
                  ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
                  : const EdgeInsets.only(left: 8, top: 4),
              child: Text(
                store.data()['name'],
                style: MyTextStyles.label,
              ),
            ),
            Padding(
              padding: showDetails
                  ? const EdgeInsets.symmetric(horizontal: 8)
                  : const EdgeInsets.only(left: 8.0),
              child: Row(
                children: <Widget>[
                  Text(store.data()['category']),
                  if (!store
                      .data()['subcategory']
                      .toString()
                      .startsWith('Others'))
                    Text(', ${store.data()['subcategory']}')
                  else
                    Text(
                        ', ${store.data()['subcategory'].toString().split(' ').last}'),
                ],
              ),
            ),
            Padding(
              padding: showDetails
                  ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
                  : const EdgeInsets.only(left: 8.0),
              child: Row(
                children: <Widget>[
                  SizedBox(
                      height: 25,
                      child: FittedBox(
                        child: AbsorbPointer(
                          absorbing: true,
                          child: RatingBar(
                            onRatingUpdate: null,
                            initialRating:
                                double.parse(store.data()['rating'].toString()),
                            allowHalfRating: true,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 15,
                            ),
                          ),
                        ),
                      )),
                  SizedBox(width: 10),
                  Text(store.data()['rating'].toString(),
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  Text('200 reviews', style: TextStyle(fontSize: 15))
                ],
              ),
            ),
            Padding(
              padding: showDetails
                  ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
                  : const EdgeInsets.only(left: 8.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.location_on,
                    color: MyColors.secondary,
                  ),
                  SizedBox(width: 5),
                  Flexible(
                      child: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            store.data()['location'],
                            overflow:
                                showDetails ? null : TextOverflow.ellipsis,
                          ))),
                ],
              ),
            ),
            if (showDetails)
              Column(
                children: <Widget>[
                  if (store.data()['phone'] != null)
                    Padding(
                      padding: showDetails
                          ? const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4)
                          : const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.phone,
                            color: MyColors.secondary,
                          ),
                          SizedBox(width: 5),
                          Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Text(
                                store.data()['phone'],
                                style: TextStyle(fontFamily: 'Roboto'),
                              )),
                        ],
                      ),
                    ),
                  if (store.data()['timing'] != null)
                    Padding(
                      padding: showDetails
                          ? const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8)
                          : const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.access_time,
                            color: MyColors.secondary,
                          ),
                          SizedBox(width: 5),
                          Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Text(
                                '$from - $to',
                                style: TextStyle(fontFamily: 'Roboto'),
                              )),
                        ],
                      ),
                    ),
                ],
              ),
            SizedBox(height: 8),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}

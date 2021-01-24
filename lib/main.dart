import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smackit/LoginRegister/Onboarding.dart';
import 'package:smackit/screens/HomePage.dart';
import 'LoginRegister/PhoneVerification.dart';
import 'LoginRegister/CustomerLogin.dart';
// import 'screens/Home.dart';
import 'screens/profile/my_reviews.dart';
import 'screens/profile/my_stores.dart';
import 'services/authentication.dart';
import 'Styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences.setMockInitialValues({});
  runApp(MyApp());
}

// check or confirm that do we need to verify google or facebook sign in emails
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spyro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primarySwatch: Colors.yellow,
        primaryColor: MyColors.primaryLight,
        accentColor: MyColors.secondary,
        cursorColor: MyColors.secondary,
        splashColor: MyColors.primaryLight,
        highlightColor: MyColors.secondary,
        textSelectionHandleColor: MyColors.primary,
        scaffoldBackgroundColor: MyColors.primaryLight,
        fontFamily: 'Lato',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/auth': (context) => CustomerLogin(),
        // '/main': (context) => MainScreen(),
        // '/forgot': (context) => ForgotPassword(),
        '/reviews': (context) => MyReviews(),
        '/stores': (context) => MyStores(),
        '/phone_verification': (context) => PhoneVerification()
      },
      // onGenerateRoute: (settings) {
      //   return MaterialPageRoute(
      //     settings: settings,
      //       builder: (_) {
      //         switch (settings.name) {
      //           case '/home':
      //             return Screen.pages[0].page;
      //           case '/map':
      //             return Screen.pages[1].page;
      //           case '/add_store':
      //             return Screen.pages[2].page;
      //           case '/chats':
      //             return Screen.pages[3].page;
      //           case '/profile':
      //             return Screen.pages[4].page;
      //           default:
      //             return Container();
      //         }
      //       });
      // },
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  // bool _splash = false;
  // String _name;
  bool _visible = true;
  AnimationController _animationController;
  Animation _animation;

  // void initialize(SharedPreferences prefs) {
  //   // _email = prefs.getString('email');
  //   _name = prefs.getString('uname');
  // }

  // Future<bool> _showOnBoardingSlides() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // initialize(prefs);
  //   if (prefs.containsKey('onboarding')) {
  //     return false;
  //   } else {
  //     prefs.setBool('onboarding', false);
  //     return true;
  //   }
  // }

  void splash() async {
    var _showOnBoarding = await AuthService().handleAuth();
    // print(_showOnBoarding);
    if (!_showOnBoarding) {
      // setState(() => _splash = true);
      await Future.delayed(Duration(milliseconds: 2000));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => OnBoarding()));
    } else {
      await Future.delayed(Duration(milliseconds: 2000));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomePage()));
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // configOneSignal();
    splash();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _animation = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, -2.5))
        .animate(_animationController);

    Future.delayed(
        Duration(milliseconds: 1500),
        () => {
              setState(() {
                _visible = false;
              }),
              _animationController.forward().whenComplete(() {
                // put here the stuff you wanna do when animation completed!
              }),
            });
  }

//   void configOneSignal() async {
//     // //Remove this method to stop OneSignal Debugging
//     // OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

//     await OneSignal.shared.init("5886b6c1-a0c4-40a8-af25-c6e711c6a56d",
//         iOSSettings: {
//           OSiOSSettings.autoPrompt: true,
//           OSiOSSettings.inAppLaunchUrl: true
//         });
//     OneSignal.shared
//         .setInFocusDisplayType(OSNotificationDisplayType.notification);

// // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
//     await OneSignal.shared
//         .promptUserForPushNotificationPermission(fallbackToSettings: true);
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        body: Stack(children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedOpacity(
                  opacity: _visible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 800),
                  child: SlideTransition(
                    position: _animation,
                    child: SvgPicture.asset('assets/images/SplashLogo.svg',
                        height: MediaQuery.of(context).size.height * 0.1),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "SPYRO",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Raleway',
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "Always Online.",
                  style: TextStyle(
                      fontFamily: 'Lato', color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          // if (_splash)
          //   Center(
          //       child: ControlledAnimation(
          //     tween: MultiTrackTween([
          //       Track('width').add(Duration(milliseconds: 200),
          //           Tween(begin: 0.0, end: MediaQuery.of(context).size.width)),
          //       Track('height').add(Duration(milliseconds: 200),
          //           Tween(begin: 0.0, end: MediaQuery.of(context).size.height)),
          //     ]),
          //     delay: Duration(seconds: 7),
          //     duration: Duration(milliseconds: 200),
          //     builder: (context, animation) {
          //       return Container(
          //         width: animation['width'],
          //         height: animation['height'],
          //         decoration: BoxDecoration(
          //             color: MyColors.primary, shape: BoxShape.rectangle),
          //       );
          //     },
          //   ))
        ]));
  }
}

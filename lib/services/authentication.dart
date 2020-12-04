import 'dart:async';
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:firebase_auth/firebase_auth.dart' as u;
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:smackit/widgets/SignUp.dart';
import '../models/User.dart';
import '../services/database.dart';

abstract class BaseAuth {
  Future signUp(String method, String type, {User user, Seller seller});
  Future signIn(String emai, String password, String typeOfUser);
  Future facebookSignIn();
  Future googleSignIn();
  Future signOut();
  Future resetPassword(String email);
  Future getCurrentUser();
  Future deleteUser(u.User user);
}

class AuthService implements BaseAuth {
  static final u.FirebaseAuth _auth = u.FirebaseAuth.instance;

  @override
  Future<Map> signUp(String method, String type,
      {User user, Seller seller}) async {
    try {
      u.User firebaseUser;
      u.AuthCredential creds;
      String password;
      DatabaseService db = DatabaseService();
      switch (method) {
        case 'email':
          if (type == 'customer') {
            final userDoc = await DatabaseService().getUserDoc(user.email);
            if (userDoc != null) {
              return {
                "success": false,
                'msg': 'This email is already in use by another account.'
              };
            }
            creds = null;
            password = user.password;
            firebaseUser = (await _auth.createUserWithEmailAndPassword(
                    email: user.email, password: user.password))
                .user;
            user.setUid(firebaseUser.uid);
            // UserUpdateInfo userInfo = UserUpdateInfo();
            // userInfo.displayName = user.username;
            // firebaseUser.updateProfile(displayName: user.username);
            // await firebaseUser.sendEmailVerification();
            await db.createUser(user, false);
          } else {
            final userDoc = await DatabaseService().getUserDoc(seller.email);
            if (userDoc != null) {
              return {
                "success": false,
                'msg': 'This email is already in use by another account.'
              };
            }
            creds = null;
            password = seller.password;
            firebaseUser = (await _auth.createUserWithEmailAndPassword(
                    email: seller.email, password: seller.password))
                .user;
            seller.setUid(firebaseUser.uid);
            // UserUpdateInfo userInfo = UserUpdateInfo();
            // userInfo.displayName = user.username;
            // firebaseUser.updateProfile(displayName: user.username);
            // await firebaseUser.sendEmailVerification();
            await db.createSeller(seller, false);
          }
          break;
        case 'google':
          try {
            print("1");
            final GoogleSignIn googleSignIn = new GoogleSignIn();
            GoogleSignInAccount googleUser;
            GoogleSignInAuthentication googleAuth;
            print('2');
            googleUser = await googleSignIn.signIn();
            print('3');
            googleAuth = await googleUser.authentication;

            final userDoc =
                await DatabaseService().getUserDoc(googleUser.email);
            if (userDoc != null) {
              return {
                "success": false,
                'msg':
                    'This email is already in use by another account.\nTry with another email'
              };
            } else {
              password = null;
              creds = u.GoogleAuthProvider.credential(
                accessToken: googleAuth.accessToken,
                idToken: googleAuth.idToken,
              );
              firebaseUser = (await _auth.signInWithCredential(creds)).user;
              db.createUser(
                  User(
                      email: googleUser.email,
                      username: googleUser.displayName,
                      uid: firebaseUser.uid,
                      photoUrl: googleUser.photoUrl,
                      userType: TypeOfUser.customer),
                  true);
              // u.UserUpdateInfo userInfo = u.UserUpdateInfo();
              // userInfo.displayName = googleUser.displayName;
              firebaseUser.updateProfile(displayName: googleUser.displayName);
              return {'success': true, 'msg': 'Success'};
            }
          } catch (e) {
            print(e.toString());
            if (e.code == 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL') {
              return {
                'success': false,
                'msg':
                    'Unable to perform Google Signin. Try other Signin Methods'
              };
            }
            return {
              'success': false,
              'msg': 'Something went wrong. Try again later'
            };
          }
          break;
        case 'facebook':
          final facebookLogin = FacebookLogin();
          facebookLogin.loginBehavior = FacebookLoginBehavior.webOnly;
          final result = await facebookLogin
              .logInWithReadPermissions(['email', 'public_profile']);
          switch (result.status) {
            case FacebookLoginStatus.loggedIn:
              Response graphResponse = await get(
                  'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${result.accessToken.token}');
              Map profile = jsonDecode(graphResponse.body);
              final userDoc =
                  await DatabaseService().getUserDoc(profile['email']);
              if (userDoc != null)
                return {
                  "success": false,
                  'msg':
                      'This email is already in use by another account.\nTry with another email'
                };
              try {
                password = null;
                creds =
                    u.FacebookAuthProvider.credential(result.accessToken.token);
                firebaseUser = (await _auth.signInWithCredential(creds)).user;
                db.createUser(
                    User(
                        email: profile['email'],
                        username: profile['name'],
                        uid: firebaseUser.uid,
                        photoUrl: profile['picture']['data']['url'],
                        userType: TypeOfUser.customer),
                    true);
                // u.UserUpdateInfo userInfo = u.UserUpdateInfo();
                // userInfo.displayName = profile['name'];
              } catch (e) {
                print(e.toString());
                if (e.code == 'account-exists-with-different-credential') {
                  return {
                    'success': false,
                    'msg': 'This email is already in use by another account.'
                  };
                }
                return {
                  'success': false,
                  'msg': 'Something went wrong. Try again later'
                };
              }
              break;
            case FacebookLoginStatus.cancelledByUser:
              return {'success': false, 'msg': 'Login was Cancelled'};
              break;
            case FacebookLoginStatus.error:
              return {'success': false, 'msg': result.errorMessage};
              break;
            default:
          }
          break;
        default:
      }
      return {
        "success": true,
        'user': firebaseUser,
        'creds': creds,
        'password': password,
        'type': method
      };
    } catch (e) {
      print(e.toString() + "this is error");
      if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE')
        return {
          "success": false,
          'msg':
              'This email is already in use by another account.\nTry with another email'
        };
      return {"success": false, 'msg': 'Something went wrong. Try again Later'};
    }
  }

  @override
  Future<Map> signIn(String email, String password, String typeOfUser) async {
    if (typeOfUser == 'customer') {
      try {
        u.User user = (await _auth.signInWithEmailAndPassword(
                email: email, password: password))
            .user;
        // if (user.emailVerified) await DatabaseService().verifyEmail(email);
        final userDoc = await DatabaseService().getUserDoc(user.email);
        // if (userDoc == null) {
        //   await _auth.signOut();
        //   return {"success": false, 'msg': 'Unregistered account'};
        // }
        await UserData.setData(userDoc.data());
        return {'success': true, 'msg': 'Sign in successful'};
      } catch (e) {
        print("hi ${e.code.toString()}");
        if (e.code == 'wrong-password') {
          print(e.toString());
          final methods = await _auth.fetchSignInMethodsForEmail(email);
          return methods.contains('password')
              ? {"success": false, 'msg': 'Incorrect password'}
              : {
                  "success": false,
                  'msg':
                      'Please use your social media Login i.e. \"Google or Facebook\"'
                };
        }
        if (e.code == 'user-not-found')
          return {"success": false, 'msg': 'Unregistered account'};
        return {
          "success": false,
          'msg': 'Something went wrong. Try again Later'
        };
      }
    } else {
      try {
        u.User user = (await _auth.signInWithEmailAndPassword(
                email: email, password: password))
            .user;
        // if (user.emailVerified) await DatabaseService().verifyEmail(email);
        final userDoc = await DatabaseService().getUserDocSeller(user.email);
        // if (userDoc == null) {
        //   await _auth.signOut();
        //   return {"success": false, 'msg': 'Unregistered account'};
        // }
        await UserData.setData(userDoc.data());
        return {'success': true, 'msg': 'Sign in successful'};
      } catch (e) {
        print("hi ${e.code.toString()}");
        if (e.code == 'wrong-password') {
          print(e.toString());
          final methods = await _auth.fetchSignInMethodsForEmail(email);
          return methods.contains('password')
              ? {"success": false, 'msg': 'Incorrect password'}
              : {
                  "success": false,
                  'msg':
                      'Please use your social media Login i.e. \"Google or Facebook\"'
                };
        }
        if (e.code == 'user-not-found')
          return {"success": false, 'msg': 'Unregistered account'};
        return {
          "success": false,
          'msg': 'Something went wrong. Try again Later'
        };
      }
    }
  }

  @override
  Future facebookSignIn() async {
    final facebookLogin = FacebookLogin();
    facebookLogin.loginBehavior = FacebookLoginBehavior.webOnly;
    final result = await facebookLogin
        .logInWithReadPermissions(['email', 'public_profile']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        String token = result.accessToken.token;
        print(result.accessToken.isValid());
        Response graphResponse = await get(
            'https://graph.facebook.com/v7.0/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=$token');
        Map profile = jsonDecode(graphResponse.body);
        // print('profile: $profile');
        final userDoc = await DatabaseService().getUserDoc(profile['email']);
        if (userDoc == null) {
          await facebookLogin.logOut();
          return {"success": false, 'msg': 'Unregistered account'};
        }
        try {
          final user = (await _auth.signInWithCredential(
                  u.FacebookAuthProvider.credential(result.accessToken.token)))
              .user;
          await UserData.setData(userDoc.data());
          return {'success': true, 'user': user};
        } catch (e) {
          print(e.toString());
          if (e.code == 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL') {
            return {
              'success': false,
              'msg':
                  'Unable to perform Facebook Signin. Try other Signin Methods'
            };
          }
          return {
            'success': false,
            'msg': 'Something went wrong. Try again later'
          };
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        return {'success': false, 'msg': 'Login was Cancelled'};
        break;
      case FacebookLoginStatus.error:
        return {'success': false, 'msg': result.errorMessage};
        break;
      default:
    }
  }

  Future googleSignIn() async {
    final GoogleSignIn googleSignIn = new GoogleSignIn();
    GoogleSignInAccount googleUser;
    GoogleSignInAuthentication googleAuth;
    await googleSignIn.signOut();
    try {
      googleUser = await googleSignIn.signIn();
      googleAuth = await googleUser.authentication;

      // print(e.toString() + "this is error");
      // return {"success": false, 'msg': 'Google Signin Cancelled'};

      final userDoc = await DatabaseService().getUserDoc(googleUser.email);
      if (userDoc == null) {
        await googleSignIn.signOut();
        return {"success": false, 'msg': 'Unregistered account'};
      }
      final user =
          (await _auth.signInWithCredential(u.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      )))
              .user;
      await UserData.setData(userDoc.data());
      return {'success': true, 'msg': 'Successful sign in'};
    } catch (e) {
      print(e.toString() + "hi");
      return {"success": false, 'msg': 'Something went wrong. Try again later'};
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await UserData.removeData();
      await GoogleSignIn().signOut();
      await FacebookLogin().logOut();
      await _auth.signOut();
      print('Signed Out');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  @override
  Future<u.User> getCurrentUser() async {
    u.User user = _auth.currentUser;
    return user;
  }

  @override
  Future<void> deleteUser(u.User user) async {
    try {
      await user.delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<u.User> credentialSignIn(u.AuthCredential creds) async {
    final user = (await _auth.signInWithCredential(creds)).user;
    return user;
  }

  Future phoneVerification(
      {String phone,
      Function(u.AuthCredential) verificationCompleted,
      Function(u.FirebaseAuthException) verificationFailed,
      Function(String, [int]) codeSent,
      Function(String) codeAutoRetrievalTimeout}) async {
    phone = "+91" + phone;
    await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  handleAuth() {
    try {
      if (u.FirebaseAuth.instance.currentUser.uid == null) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
      // print(e.toString() + "error");
    }

    // return StreamBuilder(
    //   stream: u.FirebaseAuth.instance.authStateChanges(),
    //   builder: (BuildContext context, snapshot) {
    //     if (snapshot.hasData) {
    //       return HomePage();
    //       // return AdminHome();
    //     } else {
    //       return RedirectingPage();
    //       // return AdminHome();
    //     }
    //   },
    // );
  }
}

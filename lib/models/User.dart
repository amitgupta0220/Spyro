import 'package:shared_preferences/shared_preferences.dart';
import 'package:smackit/widgets/SignUp.dart';

class Seller {
  String uid;
  String email;
  String password;
  String phone;
  bool verified;
  TypeOfUser userType;
  String shopName, address,website,ownerName,typeOfBusiness;
  Seller(
      {this.email,
      this.password,
      this.phone,
      this.uid,
      this.verified,
      this.userType,
      this.shopName,
      this.address,
      this.website,
      this.ownerName,
      this.typeOfBusiness});
  void setEmail(String email) => this.email = email;
  void setPassword(String password) => this.password = password;
  void setUid(String uid) => this.uid = uid;
  void setShopName(String shopName) => this.shopName = shopName;
  void setAddress(String address) => this.shopName = address;
  void setWebsite(String website) => this.website = website;
}

class User {
  String uid;
  String email;
  String password;
  String username;
  String photoUrl;
  String phone;
  bool verified;
  TypeOfUser userType;
  User(
      {this.email,
      this.password,
      this.phone,
      this.username,
      this.photoUrl,
      this.uid,
      this.verified,
      this.userType});
  void setEmail(String email) => this.email = email;
  void setPassword(String password) => this.password = password;
  void setUname(String uname) => this.username = uname;
  void setPhototUrl(String url) => this.photoUrl = url;
  void setUid(String uid) => this.uid = uid;
}

class CurrentUser extends User {
  static CurrentUser user = CurrentUser();
  static void initialize(String email, String uid) {
    user.uid = uid;
    user.email = email;
  }
}

class UserData {
  static SharedPreferences prefs;

  static Future<void> setData(Map userDoc) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('email', userDoc['email']);
    // prefs.setString('uname', userDoc['username']);
    prefs.setString('uid', userDoc['uid']);
    prefs.setString('phone', userDoc['phone']);
    prefs.setString('photo', userDoc['photoUrl']);
    prefs.setString('location', userDoc['location']);
    prefs.setString('about', userDoc['about']);
    prefs.setBool('email_verified', userDoc['email_verified']);
    prefs.setBool('phone_verified', userDoc['phone_verified']);
    CurrentUser.initialize(userDoc['email'], userDoc['uid']);
  }

  static Future<void> removeData() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('uname');
    prefs.remove('uid');
    prefs.remove('phone');
    prefs.remove('location');
    prefs.remove('about');
    prefs.remove('photo');
    prefs.remove('email_verified');
    prefs.remove('phone_verified');
  }

  static Future<Map<String, dynamic>> getUser() async {
    prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString('email'),
      'uname': prefs.getString('uname'),
      'uid': prefs.getString('uid')
    };
  }

  static Future<Map<String, dynamic>> getAdditionalInfo() async {
    prefs = await SharedPreferences.getInstance();
    return {
      'phone': prefs.getString('phone'),
      'photo_url': prefs.getString('photo'),
      'location': prefs.getString('location'),
      'about': prefs.getString('about'),
    };
  }
}

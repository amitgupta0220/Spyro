import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smackit/models/Review.dart';
import 'package:smackit/models/Store.dart';
import 'package:smackit/models/User.dart';
import 'package:smackit/services/storage.dart';
import 'package:steel_crypt/steel_crypt.dart';

abstract class DataBase {
  Future getPromos();
  Future createUser(User user, bool verified);
  Future createSeller(Seller user, bool verified);
  Future updateUserInfo(Map userInfo);
  Future getUserDoc(String email);
  Future getUserDocSeller(String email);
  Future checkPhoneExists(String phone);
  Future verifyPhone(String email, String phone);
  Future verifyEmail(String email);
  Future addStore(Store store);
  Future addReview(String store, Review review);
}

class DatabaseService extends DataBase {
  static final db = FirebaseFirestore.instance;

  @override
  Future<List<String>> getPromos() async {
    List<String> urls = List<String>();
    final promoDoc = (await db.collection('promos').limit(1).get()).docs[0];
    for (var i = 1; i <= 4; i++) urls.add(promoDoc.data()['image_$i']);
    return urls;
  }

  @override
  Future<void> createSeller(Seller user, bool verified) async {
    DocumentReference userDoc = db.collection('seller').doc(user.email);
    await userDoc.set({
      'email': user.email,
      // 'username': user.username,
      'email_verified': verified,
      'phone': user.phone,
      'phone_verified': false,
      'uid': user.uid,
      'created_at': Timestamp.now(),
      'userType': "seller",
      'shopName': user.shopName,
      'address': user.address,
      'website': user.website,
      'name': user.ownerName,
      'typeOfBusiness': user.typeOfBusiness
    });
  }

  @override
  Future<void> createUser(User user, bool verified) async {
    DocumentReference userDoc = db.collection('users').doc(user.email);
    await userDoc.set({
      'email': user.email,
      'name': user.username,
      'email_verified': verified,
      'phone': null,
      'phone_verified': false,
      'photoUrl': user.photoUrl,
      'location': null,
      'about': null,
      'uid': user.uid,
      'created_at': Timestamp.now(),
      'userType': "customer"
    });
  }

  @override
  Future<DocumentSnapshot> getUserDocSeller(String email) async {
    if (email == null) return null;
    final user = await db
        .collection('seller')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    if (user.docs.length == 0)
      return null;
    else
      return user.docs[0];
  }

  @override
  Future<DocumentSnapshot> getUserDoc(String email) async {
    if (email == null) return null;
    final user = await db
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    if (user.docs.length == 0)
      return null;
    else
      return user.docs[0];
  }

  @override
  Future updateUserInfo(Map userInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    String url;
    Map<String, dynamic> data = {
      'username': userInfo['name'],
      'phone': userInfo['phone'],
      'phone_verified': false,
      'about': userInfo['about'],
      'location': userInfo['location'],
    };
    if (userInfo['image'] != null) {
      url = await StorageService().updateProfilePic(email, userInfo['image']);
      data['photoUrl'] = url;
    }
    await db.runTransaction((transaction) async {
      await transaction.update(db.collection('users').doc(email), data);
    });
    prefs.setString('uname', userInfo['name']);
    prefs.setString('phone', userInfo['phone']);
    prefs.setString('about', userInfo['about']);
    prefs.setString('location', userInfo['location']);
    if (url != null) prefs.setString('photo', url);
  }

  @override
  Future<bool> checkPhoneExists(String phone) async {
    phone = '+91' + phone;
    final user = await db
        .collection('users')
        .where('phone', isEqualTo: phone)
        .limit(1)
        .get();
    print(user.docs);
    if (user.docs.length == 0)
      return false;
    else
      return true;
  }

  @override
  Future verifyPhone(String email, String phone) async {
    phone = '+91' + phone;
    await db.runTransaction((transaction) async {
      transaction.update(db.collection('users').doc(email),
          {'phone': phone, 'phone_verified': true});
    });
  }

  @override
  Future<void> verifyEmail(String email) async {
    await db.runTransaction((transaction) async {
      transaction
          .update(db.collection('users').doc(email), {'email_verified': true});
    });
  }

  @override
  Future addStore(Store store) async {
    final images =
        await StorageService().addStorePics(store.name, store.images);
    await db.collection('stores').doc(store.name).set({
      'name': store.name,
      'owner': store.owner,
      'description': store.description,
      'location': store.location,
      'items': store.items,
      'category': store.category,
      'subcategory': store.subcategory,
      'images': images,
      'primary_image': store.primaryImage,
      'rating': store.rating,
      'timing': store.timing,
      'coordinates': store.position,
      'phone': store.phone,
      'website': store.website,
      'added_by': CurrentUser.user.email,
      'timestamp': DateTime.now()
    });
  }

  @override
  Future<void> addReview(String store, Review review) async {
    final images = review.images.length == 0
        ? null
        : await StorageService()
            .addReviewPics(store, review.reviewerName, review.images);
    final timestamp = DateTime.now();
    final ref =
        await db.collection('stores').doc(store).collection('reviews').add({
      'timestamp': timestamp,
      'reviewer_id': review.reviewerId,
      'reviewer_name': review.reviewerName,
      'review': review.description,
      'rating': review.rating,
      'images': images,
      'likes': review.likes,
      'dislikes': review.dislikes,
      'store': store
    });

    final userRef = db.collection('users').doc(CurrentUser.user.email);
    await db.runTransaction((transaction) async {
      await transaction.set(userRef.collection('my_reviews').doc(ref.id),
          {'review_id': ref.id, 'store': store, 'timestamp': timestamp});
      await transaction.update(ref, {'review_id': ref.id});
    });
  }
}

class Hashing {
  static final hasher = HashCrypt('SHA-3/512');
  static String encrypt(String text) {
    return hasher.hash(text);
  }
}

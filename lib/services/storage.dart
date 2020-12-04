import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

abstract class BaseStorage {
  Future updateProfilePic(String email, File image);
  Future addStorePics(String store, List<Uint8List> images);
  Future addReviewPics(String store, String review, List<Uint8List> images);
}

class StorageService extends BaseStorage {
  static final storage = FirebaseStorage.instance.ref();

  @override
  Future<String> updateProfilePic(String email, File image) async {
    final ref = storage.child('users').child(email).child('profile_pic.jpg');
    // await ref.putFile(image).onComplete;
    await ref.putFile(image);
    final url = await ref.getDownloadURL();
    return url;
  }

  @override
  Future<List<String>> addStorePics(
      String store, List<Uint8List> images) async {
    List<String> urls = [];
    for (var i = 0; i < images.length; i++) {
      var ref =
          storage.child('stores').child(store).child('image_${i + 1}.jpg');
      String url = await (await ref.putData(images[i])).ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }

  @override
  Future<List<String>> addReviewPics(
      String store, String review, List<Uint8List> images) async {
    List<String> urls = [];
    for (var i = 0; i < images.length; i++) {
      var ref = storage
          .child('stores')
          .child(store)
          .child('reviews')
          .child(review)
          .child('image_${i + 1}.jpg');
      String url = await (await ref.putData(images[i])).ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }
}

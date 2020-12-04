

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  String name,
      owner,
      location,
      description,
      category,
      subcategory,
      phone,
      website;
  Map timing;
  GeoPoint position;
  double rating;
  int primaryImage;
  List<Uint8List> images;
  List<Map<String, dynamic>> items;
  Store(
      {this.name,
      this.location,
      this.description,
      this.category,
      this.subcategory,
      this.rating,
      this.owner,
      this.phone,
      this.website,
      this.position,
      this.timing,
      this.images,
      this.primaryImage,
      this.items});
}

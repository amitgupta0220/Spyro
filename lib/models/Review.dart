import 'dart:typed_data';

import 'package:flutter/foundation.dart';

class Review {
  final String reviewerName, reviewerId, description;
  final double rating;
  final List<Uint8List> images;
  final List<String> likes, dislikes;
  static List<String> likeTags = [
    'hygiene',
    'service',
    'behaviour',
    'puntuality',
    'availability'
  ];
  static List<String> dislikeTags = [
    'price',
    'hygiene',
    'way of speaking',
    'lateness',
    'rates'
  ];

  Review(
      {@required this.reviewerName,
      @required this.reviewerId,
      @required this.rating,
      this.description,
      this.images,
      this.likes,
      this.dislikes})
      : assert(rating != null);
}

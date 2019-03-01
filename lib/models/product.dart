import 'package:flutter/material.dart';

import '../models/location_data.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final String image;
  final double price;
  final bool isFavorite;
  final LocationData location;

  final String userEmail;
  final String userId;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.image,
      @required this.price,
      @required this.userEmail,
      @required this.userId,
      @required this.location,
      this.isFavorite = false});
}

import 'package:flutter/material.dart';

import 'package:favourite_places/models/place.dart';

class PlaceDetailScreen extends StatelessWidget {
  final Place place;
  const PlaceDetailScreen({required this.place, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(place.title)),
      body: Stack(children: [
        Image.file(
          place.image,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ]),
    );
  }
}

import 'package:flutter/material.dart';

String songName = 'Loading...';
String artistName = "Loading...";
Duration totalTime = const Duration(minutes: 4);



Widget songimage(String imageassate) {
  return Image.network(imageassate);
}

Widget listimage(String imageassate) {
  return Image.network(
    imageassate,
    height: 50,
    width: 50,
  );
}

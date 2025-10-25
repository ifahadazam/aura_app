import 'package:flutter/material.dart';

class AppGradients {
  AppGradients._();

  // Prominent Color Gradient

  static const scaffolfGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 201, 239, 226),
      Color.fromARGB(255, 239, 203, 222),
      Color.fromARGB(255, 254, 232, 215),
      Color.fromARGB(255, 206, 237, 237),
    ],
  );
}

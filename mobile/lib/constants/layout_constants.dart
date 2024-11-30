import 'package:flutter/material.dart';

BoxDecoration kStandardBackgroundContainerDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(50),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      spreadRadius: 5,
      blurRadius: 7,
      offset: Offset(0, 3),
    ),
  ],
);

// Colors used in this app
const primaryColor = Color.fromRGBO(39, 93, 173, 1);
const secondaryColor = Colors.white;
const bgColor = Color.fromRGBO(247, 251, 254, 1);
const textColor = Colors.black;
const lightTextColor = Colors.black26;
const transparent = Colors.transparent;

const grey = Color.fromRGBO(217, 217, 217, 1);
const purple = Color.fromRGBO(143, 45, 86, 1);
const orange = Color.fromRGBO(251, 177, 60, 1);
const green = Color.fromRGBO(115, 210, 22, 1);
const red = Color.fromRGBO(216, 17, 89, 1);

// Default App Padding
const appPadding = 16.0;
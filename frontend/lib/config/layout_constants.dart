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

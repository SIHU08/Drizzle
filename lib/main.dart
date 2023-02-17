import 'dart:developer';

import 'package:flutter/material.dart';

import 'widgets/page.dart';

void main() async {
  runApp(MaterialApp(
    home: const MapPage(),
    theme: ThemeData(
      useMaterial3: true,
    ),
  ));
}

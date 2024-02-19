import 'package:flutter/material.dart';
import 'package:movies_app/screens/home_screen.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(colorScheme: ColorScheme.fromSwatch()),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen()));
}

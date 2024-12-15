/*
This application teaches students how to make API calls
to retrieve JSON data and manipulate it.
 */
import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'csci410 week 11',
        home: Home());
  }
}
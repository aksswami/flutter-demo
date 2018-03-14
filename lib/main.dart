import 'package:flutter/material.dart';
import 'GithubPage.dart';
import 'RandomWord.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Startup Name Generator',
      home: new GithubPage(), //RandomWord()
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
    );
  }
}





import 'package:flutter/material.dart';
import 'package:news_app/pages/feedPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
      
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      home: const Feedpage(),
    );
  }
}

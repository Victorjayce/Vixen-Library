import 'package:flutter/material.dart';
import 'package:library_mgt/author.dart';
import 'package:library_mgt/borrowed.dart';
import 'package:library_mgt/details.dart';
import 'package:library_mgt/test.dart';
import 'home.dart';
//import 'dart:ui' as ui;

const homeRoute = '/'; //signifies home screen;
const authorRoute = '/authorscreen';
const borrowedRoute = '/borrowedscreen';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: _routes(),
      title: 'Libro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => TestWidg(),
        '/authorscreen': (context) => AuthorPage(),
        '/borrowedscreen': (context) => BorrowedPage(),
        '/authordetail': (context) => AuthorDetailPage(),
      },
    );
  }
}

RouteFactory _routes(){
    return (settings) {
        //final Map<String, dynamic> arguments = settings.arguments;
        Widget screen;
        switch (settings.name){
            case homeRoute:
                screen = HomePage(); //no arguments needed
                break;
            case borrowedRoute:
                screen = BorrowedPage(); // list of all arguemnts......BorrowedPage(arguments['id'])
                break;
            case authorRoute:
                screen = AuthorPage(); //no arguments needed
                break;
            default: return null;
        }
        return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
}

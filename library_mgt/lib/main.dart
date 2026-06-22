import 'package:flutter/material.dart';
import 'package:library_mgt/author.dart';
import 'package:library_mgt/borrowed.dart';
import 'package:library_mgt/details.dart';
import 'package:library_mgt/lib.dart';
import 'home.dart';

const homeRoute = '/';
const authorRoute = '/authorscreen';
const borrowedRoute = '/borrowedscreen';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LibraryProvider(
      library: library,
      child: MaterialApp(
        onGenerateRoute: _routes(),
        title: 'Libro',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/authorscreen': (context) => const AuthorPage(),
          '/borrowedscreen': (context) => const BorrowedPage(),
          '/authordetail': (context) => const AuthorDetailPage(),
        },
      ),
    );
  }
}

RouteFactory _routes() {
  return (settings) {
    Widget screen;
    switch (settings.name) {
      case homeRoute:
        screen = const HomePage();
        break;
      case borrowedRoute:
        screen = const BorrowedPage();
        break;
      case authorRoute:
        screen = const AuthorPage();
        break;
      default:
        return null;
    }
    return MaterialPageRoute(builder: (BuildContext context) => screen);
  };
}

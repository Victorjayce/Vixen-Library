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
        onGenerateRoute: _routes,
        title: 'Libro',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        ),
        initialRoute: homeRoute,
      ),
    );
  }
}

Route<dynamic>? _routes(RouteSettings settings) {
  switch (settings.name) {
    case homeRoute:
      return MaterialPageRoute(builder: (_) => const HomePage());
    case borrowedRoute:
      return MaterialPageRoute(builder: (_) => const BorrowedPage());
    case authorRoute:
      return MaterialPageRoute(builder: (_) => const AuthorPage());
    case '/authordetail':
      final args = settings.arguments;
      if (args is AuthorDetailArgs) {
        return MaterialPageRoute(
          builder: (_) =>
              AuthorDetailPage(booksId: args.booksId, authorName: args.name),
        );
      }
      return _errorRoute();
    default:
      return _errorRoute();
  }
}

Route<dynamic> _errorRoute() {
  return MaterialPageRoute(
    builder: (_) => Scaffold(
      appBar: AppBar(title: const Text('Route Error')),
      body: const Center(child: Text('Page not found or invalid arguments.')),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:library_mgt/author.dart';
import 'package:library_mgt/details.dart';
import 'package:library_mgt/lib.dart';
import 'package:library_mgt/home.dart';
import 'package:library_mgt/user.dart';
import 'package:library_mgt/udetails.dart';

const homeRoute = '/';
const authorRoute = '/authorscreen';
const userRoute = '/userscreen';
const detailsRoute = '/detailscreen';
const userdetailsRoute = '/userdetailscreen';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lightScheme = ColorScheme.fromSeed(seedColor: Colors.lightBlue);
    final darkScheme = ColorScheme.fromSeed(
      seedColor: Colors.lightBlue,
      brightness: Brightness.dark,
    );

    return LibraryProvider(
      library: library,
      child: MaterialApp(
        onGenerateRoute: _routes,
        title: 'Libro',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightScheme,
          scaffoldBackgroundColor: lightScheme.surface,
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: lightScheme.surface,
          ),
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: lightScheme.surface,
          ),
          dialogTheme: DialogThemeData(backgroundColor: lightScheme.surface),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkScheme,
          scaffoldBackgroundColor: darkScheme.surface,
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: darkScheme.surface,
          ),
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: darkScheme.surface,
          ),
          dialogTheme: DialogThemeData(backgroundColor: darkScheme.surface),
        ),
        themeMode: ThemeMode.system,
        initialRoute: homeRoute,
      ),
    );
  }
}

Route<dynamic>? _routes(RouteSettings settings) {
  switch (settings.name) {
    case homeRoute:
      return MaterialPageRoute(builder: (_) => const Home());
    case authorRoute:
      return MaterialPageRoute(builder: (_) => const AuthorPage());
    case userdetailsRoute:
      final args = settings.arguments;
      if (args is User) {
        return MaterialPageRoute(builder: (_) => UserDetail(user: args));
      }
      return _errorRoute();
    case userRoute:
      return MaterialPageRoute(builder: (_) => const UserPage());
    case detailsRoute:
      final args = settings.arguments;
      if (args is AuthorDetailArgs) {
        return MaterialPageRoute(
          builder: (_) =>
              AuthorDetailPage(booksId: args.booksId, authorId: args.authorId),
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

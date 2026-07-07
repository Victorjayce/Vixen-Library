import 'package:flutter/material.dart';
import 'package:library_mgt/lib.dart';

extension Statype on int {
  IconData get icon {
    switch (this) {
      case 1:
        return Icons.auto_stories_rounded;
      case 2:
        return Icons.person_rounded;
      case 3:
        return Icons.people_alt_rounded;
      case 4:
        return Icons.bookmark_added_rounded;
      case 5:
        return Icons.library_books;
      default:
        return Icons.person_rounded;
    }
  }

  int value(BuildContext context) {
    final library = LibraryProvider.of(context);
    switch (this) {
      case 1:
        return library.totalBooks;
      case 2:
        return library.totalAuthors;
      case 3:
        return library.totalUsers;
      case 4:
        return library.totalRented;
      case 5:
        return library.totalCopies;
      default:
        return 0;
    }
  }

  String get title {
    switch (this) {
      case 1:
        return 'Books';
      case 2:
        return 'Authors';
      case 3:
        return 'Users';
      case 4:
        return 'Rented';
      case 5:
        return 'Total Copies';
      default:
        return 'Books';
    }
  }

  Color get color {
    switch (this) {
      case 1:
        return Colors.blueAccent;
      case 2:
        return Colors.cyan;
      case 3:
        return Colors.indigo;
      case 4:
        return Colors.teal;
      case 5:
        return Colors.lightBlue;
      default:
        return Colors.cyan;
    }
  }
}

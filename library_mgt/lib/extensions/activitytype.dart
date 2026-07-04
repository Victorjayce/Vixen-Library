import 'package:library_mgt/lib.dart';
import 'package:flutter/material.dart';

extension ActivityEnumX on ActivityEnum {
  IconData get icon {
    switch (this) {
      case ActivityEnum.newBook:
        return Icons.auto_stories_rounded;
      case ActivityEnum.bookReturned:
        return Icons.restart_alt_rounded;
      case ActivityEnum.userRegistered:
        return Icons.person_add_alt_rounded;
      case ActivityEnum.authorAdded:
        return Icons.person_add_alt_rounded;
      case ActivityEnum.userDeleted:
        return Icons.person_remove_alt_1_rounded;
      case ActivityEnum.authorDeleted:
        return Icons.person_remove_alt_1_rounded;
      case ActivityEnum.newPieces:
        return Icons.my_library_add_rounded;
      case ActivityEnum.bookDeleted:
        return Icons.delete_outline;
      case ActivityEnum.authorEdited:
        return Icons.edit;
      case ActivityEnum.userEdited:
        return Icons.edit;
      case ActivityEnum.bookRented:
        return Icons.bookmark_added;
    }
  }

  String get title {
    switch (this) {
      case ActivityEnum.newBook:
        return 'New book added';
      case ActivityEnum.bookReturned:
        return 'Book returned';
      case ActivityEnum.userRegistered:
        return 'User registered';
      case ActivityEnum.authorAdded:
        return 'Author added';
      case ActivityEnum.userDeleted:
        return 'User deleted';
      case ActivityEnum.authorDeleted:
        return 'Author deleted';
      case ActivityEnum.newPieces:
        return 'New pieces added';
      case ActivityEnum.bookDeleted:
        return 'Book deleted';
      case ActivityEnum.authorEdited:
        return 'Author edited';
      case ActivityEnum.userEdited:
        return 'User edited';
      case ActivityEnum.bookRented:
        return 'Book rented';
    }
  }
}

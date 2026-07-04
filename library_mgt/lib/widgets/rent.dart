import 'package:flutter/material.dart';
import 'package:library_mgt/lib.dart';
import 'package:library_mgt/widgets/form_shell.dart';

class Rent extends StatefulWidget {
  const Rent({
    super.key,
    this.bookName = '',
    this.bookId = 0,
    this.userId = 0,
    this.userName = '',
  });
  final String bookName;
  final int bookId;
  final int userId;
  final String userName;

  @override
  State<Rent> createState() => _RentState();
}

Future<int?> showRentsheet(
  BuildContext context, {
  String bookName = '',
  int bookId = 0,
  int userId = 0,
  String userName = '',
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
    clipBehavior: Clip.antiAlias,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),

            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 16),
            Rent(
              bookName: bookName,
              bookId: bookId,
              userId: userId,
              userName: userName,
            ),
          ],
        ),
      );
    },
  );
}

class _RentState extends State<Rent> {
  int quantity = 1;
  String selectedBook = '';
  String selectedUser = '';
  int bookId = 0;
  int userId = 0;
  bool showdecrement = false;
  bool showincrement = true;
  bool userchangeable = false;
  bool bookchangeable = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final libbooks = LibraryProvider.of(context).books;
    if (widget.bookName.isEmpty && libbooks.isNotEmpty) {
      selectedBook = libbooks.first.title;
      bookId = libbooks.first.id;
      bookchangeable = true;
    } else {
      selectedBook = widget.bookName;
      bookId = widget.bookId;
    }
    final libuser = LibraryProvider.of(context).users;
    if (widget.userName.isEmpty && libuser.isNotEmpty) {
      selectedUser = libuser.first.name;
      userId = libuser.first.id;
      userchangeable = true;
    } else {
      selectedUser = widget.userName;
      userId = widget.userId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final library = LibraryProvider.of(context);
    final available = library.books.firstWhere((b) => b.id == bookId).available;

    return FormScaffold(
      icon: Icons.library_add_check_rounded,
      title: 'Rent book',
      subtitle: 'Assign a book to a library member.',
      saveLabel: 'Rent',
      onCancel: () => Navigator.pop(context, 0),
      onSave: () => _rent(context),

      children: [
        DropdownButtonFormField<String>(
          initialValue: selectedBook,
          decoration: appInputDecoration(
            context: context,
            label: 'Book',
            icon: Icons.book_outlined,
          ),
          items: library.bookNames.map((book) {
            return DropdownMenuItem(value: book, child: Text(book));
          }).toList(),
          onChanged: bookchangeable
              ? (value) {
                  setState(() {
                    selectedBook = value!;
                    quantity = 1;
                  });

                  bookId = library.books.firstWhere((b) => b.title == value).id;
                }
              : null,
        ),

        const SizedBox(height: 16),

        DropdownButtonFormField<String>(
          initialValue: selectedUser,
          decoration: appInputDecoration(
            context: context,
            label: 'Library member',
            icon: Icons.person_outline,
          ),
          items: library.userNames.map((user) {
            return DropdownMenuItem(value: user, child: Text(user));
          }).toList(),
          onChanged: userchangeable
              ? (value) {
                  setState(() {
                    selectedUser = value!;
                    quantity = 1;
                  });

                  userId = library.users.firstWhere((u) => u.name == value).id;
                }
              : null,
        ),
        const SizedBox(height: 16),

        QuantityStepper(
          value: quantity,
          canDecrement: quantity > 1,
          canIncrement: quantity < available,
          onIncrement: () => _increment(context),
          onDecrement: () => _decrement(context),
        ),
      ],
    );
  }

  void _increment(BuildContext context) {
    int available = LibraryProvider.of(
      context,
    ).books.firstWhere((b) => b.id == bookId).available;
    if (quantity == available) return;
    setState(() {
      quantity++;
      if (quantity > 1) showdecrement = true;
      if (quantity >= available) showincrement = false;
    });
  }

  void _decrement(BuildContext context) {
    int available = LibraryProvider.of(
      context,
    ).books.firstWhere((b) => b.id == bookId).available;
    if (quantity <= 1) return;

    setState(() {
      quantity--;
      if (quantity == 1) {
        showdecrement = false;
      }
      if (available > quantity) {
        showincrement = true;
      }
    });
  }

  Future<void> _rent(BuildContext context) async {
    if (bookId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Select Book to rent'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 2),
          showCloseIcon: false,
        ),
      );

      return;
    }

    final rent = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.info_outline, color: Colors.orange, size: 40),
          title: Text(''),
          content: Text(
            'You are about to rent $quantity books to $selectedUser?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
    if (!context.mounted) return;
    if (rent != true) {
      Navigator.pop(context);
      return;
    }
    library.rentBook(bookId, quantity, userId);
    Navigator.pop(context, quantity);
  }
}

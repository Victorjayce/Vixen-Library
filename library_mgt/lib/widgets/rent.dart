import 'package:flutter/material.dart';
import 'package:library_mgt/lib.dart';
import 'containertitle.dart';

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
  final libbooks = LibraryProvider.of(context).books;
  if (bookName.isEmpty && libbooks.isNotEmpty) {
    bookName = libbooks.first.title;
    bookId = libbooks.first.id;
  }
  final libuser = LibraryProvider.of(context).users;
  if (userName.isEmpty && libuser.isNotEmpty) {
    userName = libuser.first.name;
    userId = libuser.first.id;
  }
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedBook = widget.bookName;
    bookId = widget.bookId;
    selectedUser = widget.userName;
    userId = widget.userId;
  }

  @override
  Widget build(BuildContext context) {
    final library = LibraryProvider.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[ContainerTitle(title: 'Rent Book')],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.book, color: Colors.blue, size: 28),
                          const SizedBox(width: 10),

                          Expanded(
                            child: DropdownButton<String>(
                              value: selectedBook,
                              isExpanded: true,
                              underline:
                                  const SizedBox(), // removes default underline
                              items: [
                                ...library.bookNames.map(
                                  (name) => DropdownMenuItem(
                                    value: name,
                                    child: Text(name),
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedBook = value!;
                                  quantity = 1;
                                  showdecrement = false;
                                });

                                bookId = (library.books.firstWhere(
                                  (b) => b.title == value!,
                                )).id;
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.people,
                            color: Colors.blue,
                            size: 28,
                          ),
                          const SizedBox(width: 10),

                          Expanded(
                            child: DropdownButton<String>(
                              value: selectedUser,
                              isExpanded: true,
                              underline:
                                  const SizedBox(), // removes default underline
                              items: [
                                ...library.userNames.map(
                                  (name) => DropdownMenuItem(
                                    value: name,
                                    child: Text(name),
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedUser = value!;
                                  quantity = 1;
                                });

                                userId = (library.users.firstWhere(
                                  (b) => b.name == value!,
                                )).id;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AnimatedScale(
                        scale: showdecrement ? 1.0 : 0,
                        duration: Duration(milliseconds: 200),
                        child: IconButton(
                          onPressed: () => {_decrement(context)},
                          icon: Icon(Icons.remove_circle, color: Colors.red),
                          iconSize: 40,
                          color: Colors.blue,
                        ),
                      ),
                      ContainerTitle(title: quantity.toString()),
                      AnimatedScale(
                        scale: showincrement ? 1.0 : 0,
                        duration: Duration(milliseconds: 200),
                        child: IconButton(
                          onPressed: () => {_increment(context)},
                          icon: Icon(Icons.add_circle, color: Colors.blue),
                          iconSize: 40,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context, 0),
                icon: const Icon(Icons.close, color: Colors.red, size: 50),
                tooltip: 'Cancel',
              ),
              SizedBox(width: 40),
              IconButton(
                onPressed: () => _rent(context),
                icon: const Icon(Icons.check, color: Colors.green, size: 50),
                tooltip: 'Save',
              ),
            ],
          ),
        ],
      ),
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
            'You are about to rent $quantity books to ${widget.userName}?',
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
    if (!rent!) {
      Navigator.pop(context);
    }
    library.rentBook(bookId, quantity, userId);
    Navigator.pop(context, quantity);
  }
}

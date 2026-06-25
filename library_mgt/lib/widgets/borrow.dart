import 'package:flutter/material.dart';
import 'package:library_mgt/lib.dart';
import 'containertitle.dart';

class Borrow extends StatefulWidget {
  const Borrow({
    super.key,
    required this.onClose,
    this.bookName = '',
    this.bookId = 0,
  });
  final VoidCallback onClose;
  final String bookName;
  final int bookId;

  @override
  State<Borrow> createState() => _BorrowState();
}

class _BorrowState extends State<Borrow> {
  int quantity = 1;
  String selectedBook = '';
  int bookId = 0;
  bool showdecrement = false;
  bool showincrement = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.bookName.isEmpty) {
      final lib = LibraryProvider.of(context);
      selectedBook = lib.books.isNotEmpty ? lib.books.first.title : '';
      bookId = lib.books.first.id;
    } else {
      selectedBook = widget.bookName;
      bookId = widget.bookId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final library = LibraryProvider.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ContainerTitle(title: 'Borrow Books'),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.book,
                                color: Colors.blue,
                                size: 28,
                              ),
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
                                    });

                                    bookId = (library.books.firstWhere(
                                      (b) => b.title == value!,
                                    )).id;
                                  },
                                ),
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
                                  icon: Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                  ),
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
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: Colors.blue,
                                  ),
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
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: widget.onClose,
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 50,
                      ),
                      tooltip: 'Cancel',
                    ),
                    SizedBox(width: 40),
                    IconButton(
                      onPressed: () => _borrow(context),
                      icon: const Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 50,
                      ),
                      tooltip: 'Save',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _increment(BuildContext context) {
    int available = LibraryProvider.of(
      context,
    ).books.firstWhere((b) => b.id == bookId).id;
    setState(() {
      quantity++;
      if (quantity > 1) showdecrement = true;
      if (quantity >= available) showincrement = false;
    });
  }

  void _decrement(BuildContext context) {
    int available = LibraryProvider.of(
      context,
    ).books.firstWhere((b) => b.id == bookId).id;
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

  void _borrow(BuildContext context) {
    if (bookId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Select Book to borrow'),
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
    library.borrowBook(bookId, quantity);
    widget.onClose;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$quantity borrowed from Library successfully'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blue.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 2),
        showCloseIcon: true,
      ),
    );
    quantity = 1;
  }
}

import 'package:flutter/material.dart';
import 'package:library_mgt/lib.dart';
import 'containertitle.dart';

class Return extends StatefulWidget {
  const Return({super.key, required this.rental});

  final Rental rental;
  @override
  State<Return> createState() => _ReturnState();
}

Future<int?> showReturnsheet(BuildContext context, {required Rental rental}) {
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
            Return(rental: rental),
          ],
        ),
      );
    },
  );
}

class _ReturnState extends State<Return> {
  int quantity = 1;
  String selectedBook = '';
  String userName = '';
  int bookId = 0;
  bool showdecrement = false;
  bool showincrement = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final book = LibraryProvider.of(context).getbook(widget.rental.bookid);
    final user = LibraryProvider.of(context).getuser(widget.rental.userid);
    selectedBook = book.title;
    bookId = book.id;
    userName = user.name;
  }

  @override
  Widget build(BuildContext context) {
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
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.3),
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
                            Text(
                              'Return $selectedBook rented by $userName',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                                fontFamily: 'Roboto',
                                letterSpacing: 0.5,
                                color: Colors.blue,
                              ),
                            ),
                          ],
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
                      onPressed: () => {Navigator.pop(context, 0)},
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 50,
                      ),
                      tooltip: 'Cancel',
                    ),
                    SizedBox(width: 40),
                    IconButton(
                      onPressed: () => _return(context),
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
    int rented = LibraryProvider.of(
      context,
    ).books.firstWhere((b) => b.id == bookId).rented;
    if (quantity == rented) return;
    setState(() {
      quantity++;
      if (quantity > 1) showdecrement = true;
      if (quantity >= rented) showincrement = false;
    });
  }

  void _decrement(BuildContext context) {
    int rented = LibraryProvider.of(
      context,
    ).books.firstWhere((b) => b.id == bookId).rented;
    if (quantity <= 1) return;

    setState(() {
      quantity--;
      if (quantity == 1) {
        showdecrement = false;
      }
      if (rented > quantity) {
        showincrement = true;
      }
    });
  }

  void _return(BuildContext context) {
    library.returnBook(widget.rental.id, quantity);
    Navigator.pop(context, quantity);
  }
}

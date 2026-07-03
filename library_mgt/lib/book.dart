import 'package:flutter/material.dart';
import 'package:library_mgt/lib.dart';
import 'package:library_mgt/widgets/addbook.dart';
import 'package:library_mgt/widgets/addmore.dart';
import 'widgets/rent.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum MenuAction { rent, addmore, delete }

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  bool showAddbook = false;
  bool showFab = false;
  int addbookId = 0;

  bool showrent = false;
  String rentbookName = '';
  int rentbookId = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final library = LibraryProvider.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${library.books.length} Books In Library',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'Roboto',
                  letterSpacing: 0.5,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              IconButton(
                onPressed: () => _calladdbook(context),
                tooltip: 'Add Book',
                iconSize: 40,
                color: Colors.blue,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        Expanded(
          child: library.books.isEmpty
              ? const Center(
                  child: Text(
                    'No books available yet.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: library.books.length,
                  itemBuilder: (context, index) {
                    final book = library.books[index];
                    return ListTile(
                      leading: const Icon(Icons.book, color: Colors.blue),
                      title: Text(
                        book.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Roboto',
                          letterSpacing: 0.5,
                          color: Colors.blue,
                        ),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'by ${book.author}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Roboto',
                              letterSpacing: 0.5,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          book.available > 1
                              ? Text(
                                  '${book.available} pieces',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    fontFamily: 'Roboto',
                                    letterSpacing: 0.5,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                )
                              : Text(
                                  'Unavailable',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    fontFamily: 'Roboto',
                                    letterSpacing: 0.5,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                        ],
                      ),
                      trailing: PopupMenuButton<MenuAction>(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: MenuAction.rent,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.bookmark_add,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                                Text('Rent'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: MenuAction.addmore,
                            child: Row(
                              children: [
                                Icon(Icons.add, color: Colors.blue, size: 20),
                                Text('Add more pieces'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: MenuAction.delete,
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red, size: 20),
                                Text('Delete'),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (action) {
                          switch (action) {
                            case MenuAction.rent:
                              _callrent(book.title, book.id);
                              break;
                            case MenuAction.addmore:
                              _calladdmore(book.id, context);
                              break;
                            case MenuAction.delete:
                              _calldelete(context, book.title, book.id);
                              break;
                          }
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const Divider(indent: 16, endIndent: 16, thickness: 1),
                ),
        ),
      ],
    );
  }

  Future<void> _calldelete(
    BuildContext context,
    String bookname,
    int bookId,
  ) async {
    final delete = await showDialog<bool>(
      context: context,
      builder: (context) {
        if (LibraryProvider.of(
          context,
        ).rentals.any((rental) => rental.bookid == bookId)) {
          return AlertDialog(
            icon: Icon(Icons.error, color: Colors.orange, size: 40),
            content: Text(
              'You can\'t delete a book that have been rented out\n wait for all the copies to be returned to library before continuing this action',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('OK'),
              ),
            ],
          );
        }
        return AlertDialog(
          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 40),
          title: Text('Delete $bookname'),
          content: Text(
            'You are about to permanently delete $bookname\nwould you like to continue',
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
    if (delete!) {
      library.deleteBook(bookId);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Book $bookname deleted from Library'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.blue.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 2),
          showCloseIcon: true,
        ),
      );
    }
  }

  Future<void> _calladdbook(BuildContext context) async {
    String? bookName = await showAddBook(context);
    if (!context.mounted) return;
    if (bookName != null && bookName.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Book: \'$bookName\'      added to library'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.blue.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 2),
          showCloseIcon: true,
        ),
      );
    }
    if (newAuthor.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Author: \'$newAuthor\'      added to library'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.blue.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 2),
          showCloseIcon: true,
        ),
      );
      newAuthor = '';
    }
  }

  Future<void> _calladdmore(int id, BuildContext context) async {
    int? quantity = await showAddMore(context, id: id);
    if (!context.mounted) return;
    if (quantity != 0 && quantity != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: quantity == 1
              ? Text('$quantity piece added to library')
              : Text('$quantity Pieces added to library'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.blue.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 2),
          showCloseIcon: true,
        ),
      );
    }
  }

  Future<void> _callrent(String name, int id) async {
    int? result = await showRentsheet(context, bookName: name, bookId: id);
    if (result != 0 && result != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: result == 1
              ? Text('$result book rented from Library')
              : Text('$result books rented from Library'),
          behavior: SnackBarBehavior.fixed,
          backgroundColor: Colors.blue.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 2),
          showCloseIcon: true,
        ),
      );
    }
  }
}

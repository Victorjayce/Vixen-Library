import 'package:flutter/material.dart';
import 'widgets/containertitle.dart';
import 'lib.dart';
import 'widgets/rent.dart';
import 'widgets/addmore.dart';
import 'widgets/addbook.dart';
import 'widgets/addauthor.dart';

class AuthorDetailPage extends StatefulWidget {
  const AuthorDetailPage({
    super.key,
    required this.booksId,
    required this.authorId,
  });
  final List<int> booksId;
  final int authorId;

  @override
  State<AuthorDetailPage> createState() => _AuthorDetailPageState();
}

enum MenuAction { rent, addmore, delete }

class _AuthorDetailPageState extends State<AuthorDetailPage> {
  bool showAddmore = false;
  bool showdecrement = false;
  int quantity = 1;
  int addbookId = 0;

  bool showrent = false;
  String rentbookName = '';
  int rentbookId = 0;

  @override
  Widget build(BuildContext context) {
    final library = LibraryProvider.of(context);
    final author = library.getauthor(widget.authorId);
    final List<Book> authorbooks = library.authorBooks(widget.booksId);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        title: Text('Author - ${author.name}'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.blue,
                      backgroundImage: null,
                      child: Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Hero(
                          tag: 'name-${author.name}',
                          transitionOnUserGestures: true,
                          child: Text(
                            author.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Roboto',
                              letterSpacing: 0.5,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          onPressed: () => {
                            _calleditAuthorDialog(
                              context,
                              author.name,
                              author.id,
                            ),
                          },
                          icon: Icon(Icons.edit, color: Colors.blue),
                          iconSize: 25,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: authorbooks.isNotEmpty,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ContainerTitle(
                          title: authorbooks.length == 1
                              ? '${authorbooks.length}Book'
                              : '${authorbooks.length}Books',
                        ),
                      ],
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
              child: widget.booksId.isEmpty
                  ? const Center(
                      child: Text(
                        'No books Published yet.',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Roboto',
                          letterSpacing: 0.5,
                          color: Colors.blue,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: authorbooks.length,
                      itemBuilder: (context, index) {
                        final book = authorbooks[index];
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
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: 'Roboto',
                                  letterSpacing: 0.5,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                              Text(
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
                                    Icon(
                                      Icons.add,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                    Text('Add more pieces'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: MenuAction.delete,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 20,
                                    ),
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
                      separatorBuilder: (context, index) => const Divider(
                        indent: 16,
                        endIndent: 16,
                        thickness: 1,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _calleditAuthorDialog(
    BuildContext context,
    String authorName,
    int id,
  ) async {
    final newAuthorName = await showAddAuthor(
      context,
      authorName: authorName,
      id: id,
    );
    if (!context.mounted) return;
    if (newAuthorName != null && newAuthorName.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Name updated to \'$newAuthorName\''),
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
}

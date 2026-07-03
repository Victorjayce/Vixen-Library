import 'package:flutter/material.dart';
import 'widgets/containertitle.dart';
import 'lib.dart';
import 'widgets/rent.dart';
import 'widgets/addmore.dart';
import 'widgets/addbook.dart';

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

enum MenuAction { rent, addmore, edit, delete }

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
                                value: MenuAction.edit,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.bookmark_add,
                                      color: Colors.orange,
                                      size: 20,
                                    ),
                                    Text('Edit'),
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
                                case MenuAction.edit:
                                  _callrent(book.title, book.id);
                                  break;
                                case MenuAction.delete:
                                  _callrent(book.title, book.id);
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
}

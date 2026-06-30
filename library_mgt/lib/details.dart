import 'package:flutter/material.dart';
import 'widgets/containertitle.dart';
import 'lib.dart';
import 'dart:ui' as ui;
import 'widgets/rent.dart';

class AuthorDetailPage extends StatefulWidget {
  const AuthorDetailPage({
    super.key,
    required this.booksId,
    required this.authorName,
  });
  final List<int> booksId;
  final String authorName;

  @override
  State<AuthorDetailPage> createState() => _AuthorDetailPageState();
}

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
    final List<Book> authorbooks = library.authorBooks(widget.booksId);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      tooltip: 'Close',
                      onPressed: () => {Navigator.pop(context)},
                      icon: Icon(Icons.cancel, color: Colors.red),
                      iconSize: 40,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.blue,
                          backgroundImage: null,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                        Hero(
                          tag: 'name-${widget.authorName}',
                          transitionOnUserGestures: true,
                          child: Text(
                            widget.authorName,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[ContainerTitle(title: 'Books')],
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
                              leading: const Icon(
                                Icons.book,
                                color: Colors.blue,
                              ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      ).colorScheme.surface,
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
                                      ).colorScheme.surface,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        _calladd(context, addbookId),
                                    tooltip: 'Add more to Library',
                                    icon: Icon(
                                      Icons.add_box,
                                      color: Colors.blue,
                                    ),
                                    iconSize: 30,
                                  ),
                                  Visibility(
                                    visible: book.available > 0,
                                    maintainState: true,
                                    child: IconButton(
                                      onPressed: () => {
                                        _callrent(book.title, book.id),
                                      },
                                      tooltip: 'Rent this Book',
                                      icon: Icon(
                                        Icons.bookmark_add,
                                        color: Colors.blue,
                                      ),
                                      iconSize: 30,
                                    ),
                                  ),
                                ],
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
            Visibility(
              visible: showAddmore,
              maintainState: true,
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: AnimatedScale(
                  scale: showAddmore ? 1.0 : 0,
                  duration: Duration(milliseconds: 250),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            AnimatedScale(
                              scale: showdecrement ? 1.0 : 0,
                              duration: Duration(milliseconds: 200),
                              child: IconButton(
                                onPressed: _decrement,
                                icon: Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                                iconSize: 40,
                                color: Colors.blue,
                              ),
                            ),
                            ContainerTitle(title: quantity.toString()),
                            IconButton(
                              onPressed: _increment,
                              icon: Icon(Icons.add_circle, color: Colors.blue),
                              iconSize: 40,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            onPressed: _close,
                            icon: Icon(Icons.close, color: Colors.red),
                            iconSize: 40,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            onPressed: () => _addbooks(context),
                            icon: Icon(Icons.check, color: Colors.green),
                            iconSize: 40,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: showrent,
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: AnimatedScale(
                  scale: showrent ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  child: Rent(
                    onClose: () {
                      setState(() {
                        showrent = false;
                      });
                    },
                    bookId: rentbookId,
                    bookName: rentbookName,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addbooks(BuildContext context) {
    if (addbookId == 0) return;
    LibraryProvider.of(context).addMore(addbookId, quantity);
    quantity = 1;
    setState(() {
      showAddmore = false;
      addbookId = 0;
      showdecrement = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Books added to library'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blue.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 2),
        showCloseIcon: true,
      ),
    );
  }

  void _close() {
    setState(() {
      showAddmore = false;
      quantity = 1;
      addbookId = 0;
    });
  }

  void _calladd(BuildContext context, int passedId) {
    setState(() {
      showAddmore = true;
      addbookId = passedId;
    });
  }

  void _increment() {
    if (quantity == 1) {
      setState(() {
        quantity++;
        showdecrement = true;
      });
    } else {
      setState(() {
        quantity++;
      });
    }
  }

  void _decrement() {
    if (quantity <= 1) return;

    setState(() {
      quantity--;
      if (quantity == 1) {
        showdecrement = false;
      }
    });
  }

  void _callrent(String name, int id) {
    setState(() {
      rentbookId = id;
      rentbookName = name;
      showrent = true;
    });
  }
}

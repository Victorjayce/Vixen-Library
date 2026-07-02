import 'package:flutter/material.dart';
import 'package:library_mgt/lib.dart';
import 'package:library_mgt/widgets/addbook.dart';
import 'package:library_mgt/widgets/addmore.dart';
import 'dart:ui' as ui;
import 'widgets/rent.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum MenuAction { rent, addmore, edit, delete }

class _HomePageState extends State<HomePage> {
  bool showAddbook = false;
  bool showAddmore = false;
  bool showFab = false;
  int addbookId = 0;

  bool showrent = false;
  String rentbookName = '';
  int rentbookId = 0;

  @override
  Widget build(BuildContext context) {
    final library = LibraryProvider.of(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
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
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: 'Roboto',
                                  letterSpacing: 0.5,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
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
                                  _addmore(book.id);
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
        Visibility(
          visible: showAddbook,
          maintainState: true,
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AnimatedScale(
              scale: showAddbook ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              child: Addbook(
                onClose: () {
                  setState(() {
                    showAddbook = false;
                    showFab = true;
                  });
                },
              ),
            ),
          ),
        ),
        Visibility(
          visible: showAddmore,
          maintainState: true,
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AnimatedScale(
              scale: showAddmore ? 1.0 : 0,
              duration: Duration(milliseconds: 250),
              child: AddMore(
                onClose: () {
                  setState(() {
                    showAddmore = false;
                    showFab = true;
                  });
                },
                bookId: addbookId,
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
    );
    // floatingActionButton: IgnorePointer(
    //   ignoring: !showFab,
    //   child: AnimatedScale(
    //     scale: showFab ? 1.0 : 0.0,
    //     duration: const Duration(milliseconds: 250),
    //     child: FloatingActionButton(
    //       onPressed: () => _addbooks(),
    //       tooltip: 'Add Books',
    //       child: const Icon(
    //         Icons.library_add,
    //         size: 40,
    //         color: Colors.blue,
    //       ),
    //     ),
    //   ),
    // ),
  }

  void _addbooks() {
    setState(() {
      showAddbook = !showAddbook;
      showFab = !showFab;
    });
  }

  void _addmore(int id) {
    addbookId = id;
    setState(() {
      showAddmore = !showAddmore;
      showFab = !showFab;
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

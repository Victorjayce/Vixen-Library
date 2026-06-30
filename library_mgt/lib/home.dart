import 'package:flutter/material.dart';
import 'package:library_mgt/lib.dart';
import 'package:library_mgt/widgets/actioncard.dart';
import 'package:library_mgt/widgets/addbook.dart';
import 'package:library_mgt/widgets/addmore.dart';
import 'widgets/containertitle.dart';
import 'dart:ui' as ui;
import 'widgets/rent.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final exit = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              icon: const Icon(
                Icons.error_outline,
                color: Colors.orange,
                size: 40,
              ),
              title: const Text('Exit App'),
              content: const Text('You are about to exit the application.'),
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

        if (exit == true) {
          SystemNavigator.pop(); // Pops the last route (exits if it's the root)
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text('Vixen Library'),
          automaticallyImplyLeading: false,
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                color: Theme.of(context).colorScheme.surface,
                iconSize: 40,
                onPressed: () => _opendrawer(context),
              ),
            ),
          ],
        ),
        endDrawer: Drawer(
          child: ListView(
            children: <Widget>[
              const ContainerTitle(title: 'Menu'),
              ListTile(
                leading: const Icon(Icons.bookmark_add),
                title: const Text(
                  'Rent Books',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Roboto',
                    letterSpacing: 0.5,
                    color: Colors.blue,
                  ),
                ),
                iconColor: Colors.blue,
                onTap: null,
              ),
              ListTile(
                leading: const Icon(Icons.bookmark_added),
                title: const Text(
                  'Rented Books',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Roboto',
                    letterSpacing: 0.5,
                    color: Colors.blue,
                  ),
                ),
                iconColor: Colors.blue,
                onTap: () {
                  Navigator.pushNamed(context, '/rentedscreen');
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text(
                  'Authors',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Roboto',
                    letterSpacing: 0.5,
                    color: Colors.blue,
                  ),
                ),
                iconColor: Colors.blue,
                onTap: () {
                  Navigator.pushNamed(context, '/authorscreen');
                },
              ),
            ],
          ),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: NavCard(
                          icon: Icons.book,
                          text: 'Books',
                          onPage: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () => {
                            Navigator.pushReplacementNamed(
                              context,
                              '/authorscreen',
                            ),
                          },
                          child: NavCard(
                            icon: Icons.person,
                            text: 'Authors',
                            onPage: false,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () => {
                            Navigator.pushReplacementNamed(
                              context,
                              '/rentedscreen',
                            ),
                          },
                          child: NavCard(
                            icon: Icons.bookmark_added,
                            text: 'Rented',
                            onPage: false,
                          ),
                        ),
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
                                            ).colorScheme.surface,
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
                              trailing: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () => _addmore(book.id),
                                    tooltip: 'Add more to Library',
                                    icon: Icon(
                                      Icons.add_box,
                                      color: Colors.blue,
                                    ),
                                    iconSize: 30,
                                  ),
                                  Visibility(
                                    visible: book.available > 1,
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
        ),
        floatingActionButton: IgnorePointer(
          ignoring: !showFab,
          child: AnimatedScale(
            scale: showFab ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: FloatingActionButton(
              onPressed: () => _addbooks(),
              tooltip: 'Add Books',
              child: const Icon(
                Icons.library_add,
                size: 40,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ),
    );
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

  void _opendrawer(BuildContext context) {
    if (showAddbook) {
      return;
    }
    Scaffold.of(context).openEndDrawer();
  }

  void _callrent(String name, int id) {
    setState(() {
      rentbookId = id;
      rentbookName = name;
      showrent = true;
    });
  }
}

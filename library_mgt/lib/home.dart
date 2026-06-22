import 'package:flutter/material.dart';
import 'package:library_mgt/lib.dart';
import 'package:library_mgt/widgets/addbook.dart';
import 'widgets/containertitle.dart';
import 'dart:ui' as ui;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showAddbook = false;

  @override
  Widget build(BuildContext context) {
    final library = LibraryProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('--Libro--'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              color: Colors.blue,
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
                'Borrow Books',
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
                'Borrowed Books',
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
                Navigator.pushNamed(context, '/borrowedscreen');
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const ContainerTitle(title: 'Books'),
                  IconButton(
                    icon: const Icon(Icons.bookmark_add),
                    color: Colors.blue,
                    iconSize: 40,
                    tooltip: 'Borrow Books',
                    onPressed: () {},
                  ),
                ],
              ),
              Expanded(
                child: library.books.isEmpty
                    ? const Center(
                        child: Text(
                          'No books available yet.',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: library.books.length,
                        itemBuilder: (context, index) {
                          final book = library.books[index];
                          return ListTile(
                            leading: const Icon(Icons.book),
                            title: Text(book.title),
                            subtitle: Text(
                              '${book.author} · ${book.available} available',
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          if (showAddbook)
            IgnorePointer(
              ignoring: !showAddbook,
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: AnimatedScale(
                  scale: showAddbook ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Addbook(),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () => _addbooks(),
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 50,
                                ),
                                tooltip: 'Cancel',
                              ),
                              SizedBox(width: 40),
                              IconButton(
                                onPressed: () => _addbooks(),
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
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: IgnorePointer(
        ignoring: showAddbook,
        child: AnimatedScale(
          scale: !showAddbook ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: () => _addbooks(),
            tooltip: 'Add Books',
            child: const Icon(Icons.library_add, size: 40, color: Colors.blue),
          ),
        ),
      ),
    );
  }

  void _addbooks() {
    setState(() {
      showAddbook = !showAddbook;
    });
  }

  void _opendrawer(BuildContext context) {
    if (showAddbook) {
      return;
    }
    Scaffold.of(context).openEndDrawer();
  }
}

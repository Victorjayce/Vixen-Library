import 'package:flutter/material.dart';

class BorrowedPage extends StatefulWidget {
  const BorrowedPage({super.key});
  //final Library library;
  @override
  State<BorrowedPage> createState() => _BorrowedPageState();
}

class _BorrowedPageState extends State<BorrowedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('--Borrowed Books--'),
        actions: [
      Builder(
      builder: (context) => IconButton(
        icon: Icon(Icons.close),
        color: Colors.blue,
        iconSize: 40,
        onPressed: () => Navigator.pop(context),
      ),
    ),
  ],
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView(
              children: const <Widget>[
                ListTile(
                  leading: Icon(Icons.book),
                  title: Text('Book 1'),
                ),
                ListTile(
                  leading: Icon(Icons.menu_book),
                  title: Text('Book 2'),
                ),
                ListTile(
                  leading: Icon(Icons.library_add),
                  title: Text('Book 3'),
                ),
                ListTile(
                  leading: Icon(Icons.bookmark_add),
                  title: Text('Book 1'),
                ),
                ListTile(
                  leading: Icon(Icons.close),
                  title: Text('Book 1'),
                ),
                ListTile(
                  leading: Icon(Icons.add_circle),
                  title: Text('Book 2'),
                ),
                ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Book 3'),
                ),
              ],
            ),
            ),
          ],
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Return Book',
        child: Icon(
          Icons.bookmark_remove,
          size: 40,
          color: Colors.blue
          ),
      ),
    );
  }
}
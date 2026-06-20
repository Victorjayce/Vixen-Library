import 'package:flutter/material.dart';

class AuthorPage extends StatefulWidget {
  const AuthorPage({super.key});
  //final Library library;
  @override
  State<AuthorPage> createState() => _AuthorPageState();
}

class _AuthorPageState extends State<AuthorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('--Author\'s--'),
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
                  leading: Icon(Icons.people),
                  title: Text('Book 1'),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Book 2'),
                ),
                ListTile(
                  leading: Icon(Icons.person_add),
                  title: Text('Book 3'),
                ),
              ],
            ),
            ),
          ],
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Borrow Books',
        child: Icon(
          Icons.person_add,
          size: 40,
          color: Colors.blue
          ),
      ),
    );
  }
}
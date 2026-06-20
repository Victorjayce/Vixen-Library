
import 'package:flutter/material.dart';
import 'package:library_mgt/widgets/containertitle.dart';


class AuthorDetailPage extends StatefulWidget {
  const AuthorDetailPage({super.key});

  @override
  State<AuthorDetailPage> createState() => _AuthorDetailPageState();
}

class _AuthorDetailPageState extends State<AuthorDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                onPressed: null, icon: Icon(Icons.cancel, color: Colors.red),
                iconSize: 40,
                color: Colors.blue,
                )
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
                    child: Icon(Icons.person, size: 40, color: Colors.white),
          ),
                  Text('Author Name', style: TextStyle(fontSize: 20,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
          fontFamily: 'Roboto',
          letterSpacing: 0.5,
          color: Colors.blue,)),
                ],
              ),
          ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ContainerTitle(title: 'Books')
            ],
          ),
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
                  leading: Icon(Icons.add, color: Colors.blue,),
                  title: Text('Book 3'),
                ),
              ],
            ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Add Books',
        child: Icon(Icons.library_add, color: Colors.blue, size: 40,),
      ),
    );
  }
}
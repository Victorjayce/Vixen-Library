import 'package:flutter/material.dart';
import 'package:library_mgt/widgets/addbook.dart';
import 'widgets/containertitle.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  //final Library library;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showAddbook = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('--Libro--'),
        actions: [
      Builder(
      builder: (context) => IconButton(
        icon: Icon(Icons.menu),
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
        ContainerTitle(title: 'Menu'),
        ListTile(leading: Icon(Icons.library_add), title: Text(
        'Add Books',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
          fontFamily: 'Roboto',
          letterSpacing: 0.5,
          color: Colors.blue,
        ),
      ), iconColor: Colors.blue, onTap: () {}),
        ListTile(leading: Icon(Icons.bookmark_add), title: Text(
        'Borrow Books',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
          fontFamily: 'Roboto',
          letterSpacing: 0.5,
          color: Colors.blue,
        ),
      ),iconColor: Colors.blue, onTap: () {}),
        ListTile(leading: Icon(Icons.bookmark_added), title: Text(
        'Borrowed Books',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
          fontFamily: 'Roboto',
          letterSpacing: 0.5,
          color: Colors.blue,
        ),
      ),iconColor: Colors.blue, onTap: () 
        {Navigator.pushNamed(context, '/borrowedscreen');}),
        ListTile(leading: Icon(Icons.person), title: Text(
        'Authors',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
          fontFamily: 'Roboto',
          letterSpacing: 0.5,
          color: Colors.blue,
        ),
      ),iconColor: Colors.blue, onTap: () {
        Navigator.pushNamed(context, '/authorscreen');
      }),
        ListTile(leading: Icon(Icons.person_add), title: Text(
        'Add Authors',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
          fontFamily: 'Roboto',
          letterSpacing: 0.5,
          color: Colors.blue,
        ),
      ),iconColor: Colors.blue, onTap: () {}),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // pushes children to opposite ends
              children: <Widget>[
              ContainerTitle(title: 'Books'),
              IconButton(
                icon: Icon(Icons.bookmark_add),
                color: Colors.blue,
                iconSize: 40,
                tooltip: 'Borrow Books',
                onPressed: () {},
            ),
              ]
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
                  leading: Icon(Icons.add),
                  title: Text('Book 3'),
                ),
              ],
            ),
            ),
          ],
        ),
          Visibility(
            visible: showAddbook,
            maintainState: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Addbook(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(onPressed: () => _addbooks(), 
                    icon: Icon(Icons.close, color: Colors.red, size: 50,), tooltip: 'Cancel',),
                    IconButton(onPressed: null, 
                    icon: Icon(Icons.check, color: Colors.blue, size: 50,), tooltip: 'Save Book',),
                  ],
                )
              ],
            )
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addbooks(),
        tooltip: 'Add Books',
        child: Icon(
          Icons.library_add,
          size: 40,
          color: Colors.blue
          ),
      ),
    );
  }

  _addbooks(){
    setState(() {
      if (!showAddbook) {
        showAddbook = true;
      }
      else{
        showAddbook = false;
      }
    });
  }

  _opendrawer(BuildContext context){
    if(showAddbook) {return;}
    else{
      Scaffold.of(context).openEndDrawer();
    }
  }
}
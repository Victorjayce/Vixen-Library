import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  //final Library library;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //void _incrementCounter() {setState(() {});}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
      Builder(
      builder: (context) => IconButton(
        icon: Icon(Icons.menu),
        color: Colors.blue,
        iconSize: 40,
        onPressed: () => Scaffold.of(context).openEndDrawer(),
      ),
    ),
  ],
      ),
      body: Center(
        child:
          Text(
            'Hello World',
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Add Books',
        child: Icon(
          Icons.library_add,
          size: 40,
          color: Colors.blue
          ),
      ),
    );
  }
}
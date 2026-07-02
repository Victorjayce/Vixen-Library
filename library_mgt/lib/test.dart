import 'package:flutter/material.dart';

class TestWidg extends StatefulWidget {
  const TestWidg({super.key});

  @override
  State<TestWidg> createState() => _TestWidgState();
}

class _TestWidgState extends State<TestWidg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.book, color: Colors.blue),
              title: Text(
                'book.title',
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
                    'by author',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Roboto',
                      letterSpacing: 0.5,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  Text(
                    '29 rented',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Roboto',
                      letterSpacing: 0.5,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                onPressed: () => {
                  //_callreturn(book.title, book.id),
                },
                tooltip: 'Return this Book',
                icon: Icon(Icons.undo, color: Colors.blue),
                iconSize: 30,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.book, color: Colors.blue),
              title: Text(
                'book.title',
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
                    'by author',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Roboto',
                      letterSpacing: 0.5,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  Text(
                    '29 rented',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Roboto',
                      letterSpacing: 0.5,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                onPressed: () => {
                  //_callreturn(book.title, book.id),
                },
                tooltip: 'Return this Book',
                icon: Icon(Icons.undo, color: Colors.blue),
                iconSize: 30,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.book, color: Colors.blue),
              title: Text(
                'Book title',
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
                    'by author',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Roboto',
                      letterSpacing: 0.5,
                      color:
                          Colors.black, //Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  Text(
                    '29 rented',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Roboto',
                      letterSpacing: 0.5,
                      color:
                          Colors.black, //Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                onPressed: () => {
                  //_callreturn(book.title, book.id),
                },
                tooltip: 'Return this Book',
                icon: Icon(Icons.undo, color: Colors.blue),
                iconSize: 30,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.book, color: Colors.blue),
              title: Text(
                'book.title',
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'by author',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Roboto',
                      letterSpacing: 0.5,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  Text(
                    '29 rented by User',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Roboto',
                      letterSpacing: 0.5,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                onPressed: () => {
                  //_callreturn(book.title, book.id),
                },
                tooltip: 'Return this Book',
                icon: Icon(Icons.undo, color: Colors.blue),
                iconSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

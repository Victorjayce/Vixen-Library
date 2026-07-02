import 'package:flutter/material.dart';
import 'package:library_mgt/widgets/return.dart';
import 'lib.dart';
import 'dart:ui' as ui;

class RentedPage extends StatefulWidget {
  const RentedPage({super.key});
  @override
  State<RentedPage> createState() => _RentedPageState();
}

class _RentedPageState extends State<RentedPage> {
  bool showreturn = false;
  String bookName = '';
  int bookId = 0;
  @override
  Widget build(BuildContext context) {
    final rented = LibraryProvider.of(context).rented;
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: rented.isEmpty
                  ? Center(
                      child: Text(
                        'No books available yet.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: rented.length,
                      itemBuilder: (context, index) {
                        final book = rented[index];
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
                              Text(
                                '${book.rented} rented',
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
                          trailing: IconButton(
                            onPressed: () => {_callreturn(book.title, book.id)},
                            tooltip: 'Return this Book',
                            icon: Icon(Icons.undo, color: Colors.blue),
                            iconSize: 30,
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
          visible: showreturn,
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AnimatedScale(
              scale: showreturn ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              child: Return(
                onClose: () {
                  setState(() {
                    showreturn = false;
                  });
                },
                bookId: bookId,
                bookName: bookName,
              ),
            ),
          ),
        ),
      ],
    );
  }

  int rent = 0;
  void _callreturn(String name, int id) {
    setState(() {
      bookId = id;
      bookName = name;
      showreturn = true;
    });
  }
}

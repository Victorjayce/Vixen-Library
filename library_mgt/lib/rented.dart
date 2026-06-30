import 'package:flutter/material.dart';
import 'package:library_mgt/widgets/return.dart';
import 'lib.dart';
import 'widgets/actioncard.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

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
                icon: Icon(Icons.close),
                color: Colors.blue,
                iconSize: 40,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          onTap: () => {
                            Navigator.pushReplacementNamed(context, '/'),
                          },
                          child: NavCard(
                            icon: Icons.book,
                            text: 'Books',
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
                        child: NavCard(
                          icon: Icons.bookmark_added,
                          text: 'Rented',
                          onPage: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: rented.isEmpty
                      ? Center(
                          child: Text(
                            'No books available yet.',
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: rented.length,
                          itemBuilder: (context, index) {
                            final book = rented[index];
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
                                      ).colorScheme.surface,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                onPressed: () => {
                                  _callreturn(book.title, book.id),
                                },
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
        ),
      ),
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

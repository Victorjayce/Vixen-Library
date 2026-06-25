import 'package:flutter/material.dart';
import 'lib.dart';
import 'widgets/actioncard.dart';

class BorrowedPage extends StatefulWidget {
  const BorrowedPage({super.key});
  @override
  State<BorrowedPage> createState() => _BorrowedPageState();
}

class _BorrowedPageState extends State<BorrowedPage> {
  @override
  Widget build(BuildContext context) {
    final borrowed = LibraryProvider.of(
      context,
    ).books.where((b) => b.borrowed > 0);
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: () => {Navigator.pushNamed(context, '/')},
                  child: NavCard(
                    icon: Icons.book,
                    text: 'Books',
                    onPage: false,
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () => {Navigator.pushNamed(context, '/authorscreen')},
                  child: NavCard(
                    icon: Icons.person,
                    text: 'Authors',
                    onPage: false,
                  ),
                ),
                const SizedBox(width: 12),
                NavCard(
                  icon: Icons.bookmark_added,
                  text: 'Borrowed',
                  onPage: true,
                ),
              ],
            ),
          ),
          Expanded(
            child: borrowed.isEmpty
                ? const Center(
                    child: Text(
                      'No books available yet.',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: borrowed.length,
                    itemBuilder: (context, index) {
                      //final book = borrowed[index];
                      return ListTile(
                        leading: const Icon(Icons.book),
                        title: Text(
                          borrowed.title,
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
                            Text('by ${book.author}'),
                            Text(
                              '${book.available} pieces',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                                fontFamily: 'Roboto',
                                letterSpacing: 0.5,
                                color: Colors.black,
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
                              icon: Icon(Icons.add_box, color: Colors.blue),
                              iconSize: 30,
                            ),
                            IconButton(
                              onPressed: null,
                              tooltip: 'Borrow this Book',
                              icon: Icon(
                                Icons.bookmark_add,
                                color: Colors.blue,
                              ),
                              iconSize: 30,
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const Divider(indent: 16, endIndent: 16, thickness: 1),
                  ),
          ),
        ],
      ),
    );
  }
}

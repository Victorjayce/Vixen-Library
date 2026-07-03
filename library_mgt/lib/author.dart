import 'package:flutter/material.dart';
import 'package:library_mgt/lib.dart';
import 'widgets/addauthor.dart';

class AuthorPage extends StatefulWidget {
  const AuthorPage({super.key});
  //final Library library;
  @override
  State<AuthorPage> createState() => _AuthorPageState();
}

class _AuthorPageState extends State<AuthorPage> {
  bool showAddauthor = false;
  @override
  Widget build(BuildContext context) {
    final library = LibraryProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Authors',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
            fontFamily: 'Roboto',
            letterSpacing: 0.5,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => _callAddAuthorDialog(context),
                  tooltip: 'Add Book',
                  iconSize: 40,
                  color: Colors.blue,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: library.authors.length,
              itemBuilder: (context, index) {
                final author = library.authors[index];
                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/detailscreen',
                      arguments: AuthorDetailArgs(
                        booksId: author.booksId,
                        authorId: author.id,
                      ),
                    );
                  },
                  leading: const Icon(
                    Icons.person,
                    color: Colors.blue,
                    size: 30,
                  ),
                  title: Hero(
                    tag: 'name-${author.name}',
                    transitionOnUserGestures: true,
                    child: Text(
                      author.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        fontFamily: 'Roboto',
                        letterSpacing: 0.5,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  subtitle: author.booksId.isNotEmpty
                      ? Text(
                          '${author.booksId.length.toString()} Books Published',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Roboto',
                            letterSpacing: 0.5,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        )
                      : Text(
                          'No Books Published',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Roboto',
                            letterSpacing: 0.5,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                  trailing: InkWell(
                    onTap: () async {
                      final delete = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          if (author.booksId.isNotEmpty) {
                            return AlertDialog(
                              icon: Icon(
                                Icons.error,
                                color: Colors.orange,
                                size: 40,
                              ),
                              content: Text(
                                'You can\'t delete an author with more than 1 books published\n delete all the books from library first before continuing this action',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          }
                          return AlertDialog(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 40,
                            ),
                            title: Text('Delete ${author.name}'),
                            content: Text(
                              'You are about to permanently delete ${author.name}\nwould you like to continue',
                            ),
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
                      if (delete!) {
                        library.deleteAuthor(author.id);
                        deletesnackbar(delete, author.name);
                      }
                    },
                    child: Icon(Icons.delete, color: Colors.red, size: 30),
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

  void _callAddAuthorDialog(BuildContext context) async {
    final newAuthorName = await showAddAuthor(context);
    if (!context.mounted) return;
    if (newAuthorName != null && newAuthorName.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Author: \'$newAuthorName\'         saved'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.blue.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 2),
          showCloseIcon: true,
        ),
      );
    }
  }

  void deletesnackbar(bool delete, String name) {
    if (delete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Author: $name deleted from Library'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.blue.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 2),
          showCloseIcon: true,
        ),
      );
    }
  }
}

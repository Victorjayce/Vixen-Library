import 'package:flutter/material.dart';
import 'package:library_mgt/lib.dart';
import 'dart:ui' as ui;
import 'widgets/containertitle.dart';

class AuthorPage extends StatefulWidget {
  const AuthorPage({super.key});
  //final Library library;
  @override
  State<AuthorPage> createState() => _AuthorPageState();
}

class _AuthorPageState extends State<AuthorPage> {
  final TextEditingController _authornamecontroller = TextEditingController();
  bool showAddauthor = false;
  @override
  Widget build(BuildContext context) {
    final library = LibraryProvider.of(context);
    return Scaffold(
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
          Visibility(
            visible: showAddauthor,
            maintainState: true,
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AnimatedScale(
                scale: showAddauthor ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.all(50),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ContainerTitle(title: 'New Author'),
                          ],
                        ),
                        TextField(
                          controller: _authornamecontroller,
                          decoration: InputDecoration(
                            labelText: 'Author Name',
                            hintText: 'Enter new Author\'s name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.blue,
                              size: 30,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              onPressed: _addauthor,
                              icon: Icon(Icons.close, color: Colors.red),
                              iconSize: 40,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 40),
                            IconButton(
                              onPressed: () => _savenewauthor(context),
                              icon: Icon(Icons.check, color: Colors.green),
                              iconSize: 40,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedScale(
        scale: showAddauthor ? 1.0 : 0,
        duration: Duration(milliseconds: 250),
        child: FloatingActionButton(
          onPressed: _addauthor,
          tooltip: 'Add Authors',
          child: Icon(Icons.person_add, size: 40, color: Colors.blue),
        ),
      ),
    );
  }

  void _addauthor() {
    if (showAddauthor) {
      _authornamecontroller.clear();
      setState(() {
        showAddauthor = false;
      });
    } else {
      setState(() {
        showAddauthor = true;
      });
    }
  }

  void _savenewauthor(BuildContext context) {
    if (_authornamecontroller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Enter name of author to save'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 2),
          showCloseIcon: true,
        ),
      );
    } else {
      _authornamecontroller.text.trim().isEmpty
          ? null
          : LibraryProvider.of(
              context,
            ).addAuthor(_authornamecontroller.text, []);
      String author = _authornamecontroller.text.trim();
      _authornamecontroller.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Author: \'$author\'         saved'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.blue.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 2),
          showCloseIcon: true,
        ),
      );

      _addauthor();
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

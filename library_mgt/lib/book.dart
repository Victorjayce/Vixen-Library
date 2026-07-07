import 'package:flutter/material.dart';
import 'package:library_mgt/lib.dart';
import 'package:library_mgt/widgets/addbook.dart';
import 'package:library_mgt/widgets/addmore.dart';
import 'widgets/rent.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum MenuAction { rent, addmore, delete }

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  bool showAddbook = false;
  bool showFab = false;
  int addbookId = 0;

  bool showrent = false;
  String rentbookName = '';
  int rentbookId = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final library = LibraryProvider.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [scheme.primary, scheme.inversePrimary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: scheme.primary.withValues(alpha: 0.18),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: scheme.surface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.auto_stories_rounded,
                  color: scheme.onPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Library catalog',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: scheme.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${library.books.length} books available in the library',
                      style: TextStyle(
                        color: scheme.onPrimary.withValues(alpha: 0.9),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _calladdbook(context),
                tooltip: 'Add Book',
                iconSize: 34,
                color: scheme.onPrimary,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        Expanded(
          child: library.books.isEmpty
              ? const Center(
                  child: Text(
                    'No books available yet.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: library.books.length,
                  itemBuilder: (context, index) {
                    final book = library.books[index];
                    final author = LibraryProvider.of(
                      context,
                    ).authors.firstWhere((a) => a.id == book.author);
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest.withValues(
                          alpha: 0.45,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: scheme.outlineVariant.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.menu_book_rounded,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 4,
                                  children: [
                                    InkWell(
                                      onTap: () => {
                                        Navigator.pushNamed(
                                          context,
                                          '/detailscreen',
                                          arguments: AuthorDetailArgs(
                                            booksId: author.booksId,
                                            authorId: author.id,
                                          ),
                                        ),
                                      },
                                      child: Text(
                                        'by ${author.name}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      book.available > 1
                                          ? '${book.available} pieces'
                                          : 'Unavailable',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton<MenuAction>(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: MenuAction.rent,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.bookmark_add,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                    Text('Rent'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: MenuAction.addmore,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.add,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                    Text('Add more pieces'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: MenuAction.delete,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    Text('Delete'),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (action) {
                              switch (action) {
                                case MenuAction.rent:
                                  _callrent(book.title, book.id);
                                  break;
                                case MenuAction.addmore:
                                  _calladdmore(book.id, context);
                                  break;
                                case MenuAction.delete:
                                  _calldelete(
                                    context,
                                    book.title,
                                    book.id,
                                    book.available,
                                  );
                                  break;
                              }
                            },
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
    );
  }

  Future<void> _calldelete(
    BuildContext context,
    String bookname,
    int bookId,
    int available,
  ) async {
    final delete = await showDialog<bool>(
      context: context,
      builder: (context) {
        if (LibraryProvider.of(
          context,
        ).rentals.any((rental) => rental.bookid == bookId)) {
          return AlertDialog(
            icon: Icon(Icons.error, color: Colors.orange, size: 40),
            content: Text(
              'You can\'t delete a book that have been rented out\n wait for all the copies to be returned to library before continuing this action',
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
          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 40),
          title: Text('Delete $bookname'),
          content: Text(
            'You are about to permanently delete $bookname  and all $available copies\nwould you like to continue',
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
      library.deleteBook(bookId);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Book $bookname deleted from Library'),
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

  Future<void> _calladdbook(BuildContext context) async {
    String? bookName = await showAddBook(context);
    if (!context.mounted) return;
    if (bookName != null && bookName.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Book: \'$bookName\'      added to library'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.blue.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 2),
          showCloseIcon: true,
        ),
      );
    }
    if (newAuthor.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Author: \'$newAuthor\'      added to library'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.blue.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 2),
          showCloseIcon: true,
        ),
      );
      newAuthor = '';
    }
  }

  Future<void> _calladdmore(int id, BuildContext context) async {
    int? quantity = await showAddMore(context, id: id);
    if (!context.mounted) return;
    if (quantity != 0 && quantity != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: quantity == 1
              ? Text('$quantity piece added to library')
              : Text('$quantity Pieces added to library'),
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

  Future<void> _callrent(String name, int id) async {
    int? result = await showRentsheet(context, bookName: name, bookId: id);
    if (result != 0 && result != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: result == 1
              ? Text('$result book rented from Library')
              : Text('$result books rented from Library'),
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

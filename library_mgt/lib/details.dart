import 'package:flutter/material.dart';
import 'lib.dart';
import 'widgets/rent.dart';
import 'widgets/addmore.dart';
import 'widgets/addbook.dart';
import 'widgets/addauthor.dart';

class AuthorDetailPage extends StatefulWidget {
  const AuthorDetailPage({super.key, required this.authorId});
  final int authorId;

  @override
  State<AuthorDetailPage> createState() => _AuthorDetailPageState();
}

enum MenuAction { rent, addmore, delete }

class _AuthorDetailPageState extends State<AuthorDetailPage> {
  bool showAddmore = false;
  bool showdecrement = false;
  int quantity = 1;
  int addbookId = 0;

  bool showrent = false;
  String rentbookName = '';
  int rentbookId = 0;

  @override
  Widget build(BuildContext context) {
    final library = LibraryProvider.of(context);
    final author = library.getauthor(widget.authorId);
    final authorbooks = library.books.where((a) => a.author == author.id);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onPrimary,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [scheme.primary, scheme.inversePrimary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(22),
            ),
            boxShadow: [
              BoxShadow(
                color: scheme.primary.withValues(alpha: 0.18),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
        ),
        iconTheme: IconThemeData(color: scheme.onPrimary),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              author.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: scheme.onPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              authorbooks.length == 1
                  ? '1 published book'
                  : '${authorbooks.length} published books',
              style: TextStyle(
                color: scheme.onPrimary.withValues(alpha: 0.85),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
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
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: scheme.surface.withValues(alpha: 0.2),
                        child: Icon(
                          Icons.person,
                          size: 28,
                          color: scheme.onPrimary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: 'name-${author.name}',
                              transitionOnUserGestures: true,
                              child: Text(
                                author.name,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: scheme.onPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Manage this author’s books and availability.',
                              style: TextStyle(
                                color: scheme.onPrimary.withValues(alpha: 0.9),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _calleditAuthorDialog(
                          context,
                          author.name,
                          author.id,
                        ),
                        icon: Icon(Icons.edit, color: scheme.onPrimary),
                        iconSize: 24,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: scheme.surface.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.auto_stories_rounded,
                                color: scheme.onPrimary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  authorbooks.length == 1
                                      ? '${authorbooks.length} book published'
                                      : '${authorbooks.length} books published',
                                  style: TextStyle(
                                    color: scheme.onPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () => _calladdbook(context, author.name),
                        tooltip: 'Add Book',
                        iconSize: 32,
                        color: scheme.onPrimary,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: authorbooks.isEmpty
                  ? const Center(
                      child: Text(
                        'No books Published yet.',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Roboto',
                          letterSpacing: 0.5,
                          color: Colors.blue,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: authorbooks.length,
                      itemBuilder: (context, index) {
                        final book = authorbooks[index];
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
                              color: scheme.outlineVariant.withValues(
                                alpha: 0.35,
                              ),
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
                                        Text(
                                          '${book.available} pieces',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
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
                      separatorBuilder: (context, index) => const Divider(
                        indent: 16,
                        endIndent: 16,
                        thickness: 1,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _calleditAuthorDialog(
    BuildContext context,
    String authorName,
    int id,
  ) async {
    final newAuthorName = await showAddAuthor(
      context,
      authorName: authorName,
      id: id,
    );
    if (!context.mounted) return;
    if (newAuthorName != null && newAuthorName.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Name updated to \'$newAuthorName\''),
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

  Future<void> _calladdbook(BuildContext context, String authorname) async {
    String? bookName = await showAddBook(context, author: authorname);
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
          behavior: SnackBarBehavior.fixed,
          backgroundColor: Colors.blue.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(16),
          duration: Duration(seconds: 2),
          showCloseIcon: true,
        ),
      );
    }
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
}

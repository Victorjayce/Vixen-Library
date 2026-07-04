import 'package:flutter/material.dart';
import 'package:library_mgt/widgets/form_shell.dart';
import 'package:library_mgt/lib.dart';
import 'addauthor.dart';

class Addbook extends StatefulWidget {
  const Addbook({super.key, this.author = ''});
  final String author;
  @override
  State<Addbook> createState() => _AddbookState();
}

Future<String?> showAddBook(BuildContext context, {String author = ''}) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
    clipBehavior: Clip.antiAlias,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),

            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 16),
            Addbook(author: author),
          ],
        ),
      );
    },
  );
}

String newAuthor = '';

class _AddbookState extends State<Addbook> {
  bool showAddauthor = false;
  final TextEditingController _booknamecontroller = TextEditingController();
  int quantity = 5;
  String selectedAuthor = '';
  String addnew = '--add new author--';
  bool showdecrement = true;
  bool authorchangeable = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.author.isEmpty) {
      final lib = LibraryProvider.of(context);
      selectedAuthor = lib.authorNames.isNotEmpty
          ? lib.authorNames.first
          : addnew;
      authorchangeable = true;
    } else {
      selectedAuthor = widget.author;
    }
  }

  @override
  void initState() {
    super.initState();

    _booknamecontroller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final library = LibraryProvider.of(context);

    return FormScaffold(
      icon: Icons.library_books_rounded,
      title: 'Add book',
      subtitle: 'Add a new title to your library collection.',
      saveLabel: 'Add',
      saveEnabled:
          _booknamecontroller.text.trim().isNotEmpty &&
          selectedAuthor.isNotEmpty,
      onCancel: () => Navigator.pop(context),
      onSave: () => _saveBook(context),

      children: [
        TextField(
          controller: _booknamecontroller,
          decoration: appInputDecoration(
            context: context,
            label: 'Book title',
            icon: Icons.book_outlined,
          ),
        ),

        const SizedBox(height: 16),

        DropdownButtonFormField<String>(
          initialValue: selectedAuthor,
          decoration: appInputDecoration(
            context: context,
            label: 'Author',
            icon: Icons.person_outline,
          ),
          items: library.authorNames.map((author) {
            return DropdownMenuItem(value: author, child: Text(author));
          }).toList(),
          onChanged: authorchangeable
              ? (value) {
                  setState(() {
                    selectedAuthor = value!;
                  });
                }
              : null,
        ),

        // spacing
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => _callAddAuthorDialog(context),
            icon: const Icon(Icons.person_add_alt_1),
            label: const Text('Add new author'),
          ),
        ),

        const SizedBox(height: 16),

        QuantityStepper(
          value: quantity,
          canDecrement: quantity > 1,
          onIncrement: _increment,
          onDecrement: _decrement,
        ),
      ],
    );
  }

  void _callAddAuthorDialog(BuildContext context) async {
    final newAuthorName = await showAddAuthor(context);
    if (newAuthorName != null && newAuthorName.isNotEmpty) {
      setState(() {
        selectedAuthor = newAuthorName;
        newAuthor = newAuthorName;
      });
    } else {
      setState(() {
        selectedAuthor = library.authorNames.isNotEmpty
            ? library.authorNames.first
            : addnew;
      });
    }
  }

  void _saveBook(BuildContext context) {
    final bookName = _booknamecontroller.text.trim();
    if (bookName.isNotEmpty && selectedAuthor.isNotEmpty) {
      LibraryProvider.of(context).addBook(bookName, selectedAuthor, quantity);
      Navigator.pop(context, bookName);
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

  void _increment() {
    if (quantity == 1) {
      setState(() {
        quantity++;
        showdecrement = true;
      });
    } else {
      setState(() {
        quantity++;
      });
    }
  }

  void _decrement() {
    if (quantity <= 1) return;

    setState(() {
      quantity--;
      if (quantity == 1) {
        showdecrement = false;
      }
    });
  }
}

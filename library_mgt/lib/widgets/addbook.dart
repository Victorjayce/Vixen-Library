import 'package:flutter/material.dart';
import 'package:library_mgt/widgets/containertitle.dart';
import 'package:library_mgt/lib.dart';
import 'dart:ui' as ui;

class Addbook extends StatefulWidget {
  const Addbook({super.key, required this.onClose});
  final VoidCallback onClose;
  @override
  State<Addbook> createState() => _AddbookState();
}

class _AddbookState extends State<Addbook> {
  bool showAddauthor = false;
  String newauthorname = '';
  final TextEditingController _booknamecontroller = TextEditingController();
  final TextEditingController _authornamecontroller = TextEditingController();
  int quantity = 5;
  String selectedAuthor = '';
  String addnew = '--add new author--';
  bool showdecrement = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (selectedAuthor.isEmpty) {
      final lib = LibraryProvider.of(context);
      selectedAuthor = lib.authorNames.isNotEmpty
          ? lib.authorNames.first
          : addnew;
    }
  }

  @override
  Widget build(BuildContext context) {
    final library = LibraryProvider.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
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
                                ContainerTitle(title: 'Add Books'),
                              ],
                            ),
                            TextField(
                              controller: _booknamecontroller,
                              decoration: InputDecoration(
                                labelText: 'Book Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixIcon: Icon(
                                  Icons.book,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    color: Colors.blue,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: DropdownButton<String>(
                                      value: selectedAuthor,
                                      isExpanded: true,
                                      underline:
                                          const SizedBox(), // removes default underline
                                      items: [
                                        ...library.authorNames.map(
                                          (name) => DropdownMenuItem(
                                            value: name,
                                            child: Text(name),
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: addnew,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Icon(
                                                Icons.person_add,
                                                size: 20,
                                                color: Colors.blue,
                                              ),
                                              SizedBox(width: 8),
                                              Text('Add new author...'),
                                            ],
                                          ),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          if (value == addnew) {
                                            _addauthor();
                                            setState(() {
                                              selectedAuthor =
                                                  library.authorNames.isNotEmpty
                                                  ? library.authorNames.first
                                                  : addnew;
                                            });
                                          } else {
                                            setState(() {
                                              selectedAuthor = value!;
                                            });
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  AnimatedScale(
                                    scale: showdecrement ? 1.0 : 0,
                                    duration: Duration(milliseconds: 200),
                                    child: IconButton(
                                      onPressed: _decrement,
                                      icon: Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      ),
                                      iconSize: 40,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  ContainerTitle(title: quantity.toString()),
                                  IconButton(
                                    onPressed: _increment,
                                    icon: Icon(
                                      Icons.add_circle,
                                      color: Colors.blue,
                                    ),
                                    iconSize: 40,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: widget.onClose,
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 50,
                          ),
                          tooltip: 'Cancel',
                        ),
                        SizedBox(width: 40),
                        IconButton(
                          onPressed: () => _saveBook(context),
                          icon: const Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 50,
                          ),
                          tooltip: 'Save',
                        ),
                      ],
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
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
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
                                    icon: Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
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
          ],
        ),
      ),
    );
  }

  void _saveBook(BuildContext context) {
    final bookName = _booknamecontroller.text.trim();
    if (bookName.isNotEmpty && selectedAuthor.isNotEmpty) {
      LibraryProvider.of(context).addBook(bookName, selectedAuthor, quantity);
      _booknamecontroller.clear();
      setState(() {
        selectedAuthor = '';
        quantity = 0;
      });
      widget.onClose();
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Enter Required details before saving'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
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
    _authornamecontroller.text.trim().isEmpty
        ? null
        : LibraryProvider.of(context).addAuthor(_authornamecontroller.text, []);
    _setfield();
    _authornamecontroller.clear();
    setState(() {
      selectedAuthor = newauthorname;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Author: \'$newauthorname\'         saved'),
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

  void _setfield() {
    newauthorname = _authornamecontroller.text;
  }
}

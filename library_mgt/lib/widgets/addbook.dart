import 'package:flutter/material.dart';
import 'package:library_mgt/widgets/containertitle.dart';
import 'package:library_mgt/lib.dart';
import 'dart:ui' as ui;

class Addbook extends StatefulWidget {
  Addbook({super.key});

  @override
  State<Addbook> createState() => _AddbookState();
}

class _AddbookState extends State<Addbook> {
  bool showAddauthor = false;
  String newauthorname = '';
  final TextEditingController _booknamecontroller = TextEditingController();
  final TextEditingController _authornamecontroller = TextEditingController();
  int quantity = 0;
  @override
  Widget build(BuildContext context) {
    final library = LibraryProvider.of(context);
    const String addnew = '--add new author--';
    String selectedAuthor = library.authorNames.isNotEmpty
        ? library.authorNames.first
        : addnew;
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[ContainerTitle(title: 'Add Books')],
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Book Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.book, color: Colors.blue, size: 30),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: library.authorNames.isNotEmpty
                      ? library.authorNames.first
                      : null,
                  items: [
                    ...library.authorNames
                        .map(
                          (name) =>
                              DropdownMenuItem(value: name, child: Text(name)),
                        )
                        .toList(),
                    DropdownMenuItem(
                      value: addnew,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person_add, size: 20, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Add new author...+'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == addnew) {
                      _addauthor();
                      value = library.authorNames.isNotEmpty
                          ? library.authorNames.first
                          : null;
                      selectedAuthor = value!;
                    } else {
                      selectedAuthor = value!;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Author\'s Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      //borderSide: BorderSide(Colors.transparent),
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 35,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        onPressed: null,
                        icon: Icon(Icons.remove_circle, color: Colors.red),
                        iconSize: 40,
                        color: Colors.blue,
                      ),
                      ContainerTitle(title: '5'),
                      IconButton(
                        onPressed: null,
                        icon: Icon(Icons.add_circle, color: Colors.blue),
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
                  color: Colors.white,
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
                        children: <Widget>[ContainerTitle(title: 'New Author')],
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
                            onPressed: _savenewauthor,
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
    );
  }

  void _addauthor() {
    setState(() {
      _authornamecontroller.clear();
      showAddauthor = !showAddauthor;
    });
  }

  void _savenewauthor() {
    _authornamecontroller.text.trim().isEmpty
        ? null
        : LibraryProvider.of(context).addAuthor(_authornamecontroller.text, []);
    _setfield();
    _authornamecontroller.clear();
    _addauthor();
  }

  void _setfield() {
    newauthorname = _authornamecontroller.text;
  }
}

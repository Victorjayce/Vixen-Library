import 'package:flutter/material.dart';
import 'containertitle.dart';
import 'package:library_mgt/lib.dart';

class AddMore extends StatefulWidget {
  const AddMore({super.key, required this.bookId});
  final int bookId;

  @override
  State<AddMore> createState() => _AddMoreState();
}

Future<int?> showAddMore(BuildContext context, {int id = 0}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
    clipBehavior: Clip.antiAlias,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return SafeArea(child: AddMore(bookId: id));
    },
  );
}

class _AddMoreState extends State<AddMore> {
  bool showdecrement = false;
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Add more to Library',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
            fontFamily: 'Roboto',
            letterSpacing: 0.5,
            color: Colors.blue,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.surface.withValues(alpha: 0.3),
            ),
          ),
          padding: EdgeInsets.all(2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedScale(
                scale: showdecrement ? 1.0 : 0,
                duration: Duration(milliseconds: 200),
                child: IconButton(
                  onPressed: _decrement,
                  icon: Icon(Icons.remove_circle, color: Colors.red),
                  iconSize: 40,
                  color: Colors.blue,
                ),
              ),
              ContainerTitle(title: quantity.toString()),
              IconButton(
                onPressed: _increment,
                icon: Icon(Icons.add_circle, color: Colors.blue),
                iconSize: 40,
                color: Colors.blue,
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () => {Navigator.pop(context, 0)},
              icon: Icon(Icons.close, color: Colors.red),
              iconSize: 40,
              color: Colors.blue,
            ),
            SizedBox(width: 10),
            IconButton(
              onPressed: () => _addbooks(context),
              icon: Icon(Icons.check, color: Colors.green),
              iconSize: 40,
              color: Colors.blue,
            ),
          ],
        ),
      ],
    );
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

  void _addbooks(BuildContext context) {
    LibraryProvider.of(context).addMore(widget.bookId, quantity);
    Navigator.pop(context, quantity);
  }
}

import 'package:flutter/material.dart';
import 'containertitle.dart';
import 'package:library_mgt/lib.dart';

class AddMore extends StatefulWidget {
  const AddMore({super.key, required this.onClose, required this.bookId});
  final VoidCallback onClose;
  final int bookId;

  @override
  State<AddMore> createState() => _AddMoreState();
}

class _AddMoreState extends State<AddMore> {
  bool showdecrement = false;
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
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
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
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
                onPressed: _close,
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
      ),
    );
  }

  void _close() {
    quantity = 1;
    showdecrement = false;
    widget.onClose();
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
    widget.onClose();
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

import 'package:flutter/material.dart';
import 'package:library_mgt/lib.dart';
import 'form_shell.dart';

class AddMore extends StatefulWidget {
  const AddMore({super.key, required this.bookId});
  final int bookId;

  @override
  State<AddMore> createState() => _AddMoreState();
}

Future<int?> showAddMore(BuildContext context, {int id = 0}) {
  return showAppBottomSheet<int?>(
    context: context,
    child: AddMore(bookId: id),
  );
}

class _AddMoreState extends State<AddMore> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return FormScaffold(
      icon: Icons.my_library_add_rounded,
      title: 'Add copies',
      subtitle: 'Increase the available stock for this book.',
      onCancel: () => Navigator.pop(context, 0),
      onSave: () => _addbooks(context),
      children: [
        QuantityStepper(
          value: quantity,
          canDecrement: quantity > 1,
          onDecrement: _decrement,
          onIncrement: _increment,
        ),
      ],
    );
  }

  void _increment() {
    setState(() {
      quantity++;
    });
  }

  void _decrement() {
    if (quantity <= 1) return;

    setState(() {
      quantity--;
    });
  }

  void _addbooks(BuildContext context) {
    LibraryProvider.of(context).addMore(widget.bookId, quantity);
    Navigator.pop(context, quantity);
  }
}

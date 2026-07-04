import 'package:flutter/material.dart';
import 'package:library_mgt/lib.dart';
import 'form_shell.dart';

class Return extends StatefulWidget {
  const Return({super.key, required this.rental});

  final Rental rental;
  @override
  State<Return> createState() => _ReturnState();
}

Future<int?> showReturnsheet(BuildContext context, {required Rental rental}) {
  return showAppBottomSheet<int?>(
    context: context,
    child: Return(rental: rental),
  );
}

class _ReturnState extends State<Return> {
  int quantity = 1;
  String selectedBook = '';
  String userName = '';
  int bookId = 0;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final book = LibraryProvider.of(context).getbook(widget.rental.bookid);
      final user = LibraryProvider.of(context).getuser(widget.rental.userid);
      selectedBook = book.title;
      bookId = book.id;
      userName = user.name;
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxReturn = widget.rental.quantity;

    return FormScaffold(
      icon: Icons.restart_alt_rounded,
      title: 'Return book',
      subtitle: '$selectedBook rented by $userName',
      onCancel: () => Navigator.pop(context, 0),
      onSave: () => _return(context),
      children: [
        QuantityStepper(
          value: quantity,
          canDecrement: quantity > 1,
          canIncrement: quantity < maxReturn,
          onDecrement: _decrement,
          onIncrement: _increment,
        ),
      ],
    );
  }

  void _increment() {
    if (quantity >= widget.rental.quantity) return;
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

  void _return(BuildContext context) {
    library.returnBook(widget.rental.id, quantity);
    Navigator.pop(context, quantity);
  }
}

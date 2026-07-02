import 'package:flutter/material.dart';
import 'lib.dart';
import 'widgets/containertitle.dart';
import 'widgets/return.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({super.key, required this.user});
  final User user;
  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  @override
  Widget build(BuildContext context) {
    final userRentals = LibraryProvider.of(
      context,
    ).userRentals(widget.user.rentId);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        title: Text('User - ${widget.user.name}'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.blue,
                      backgroundImage: null,
                      child: Icon(
                        Icons.person_pin,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    Hero(
                      tag: 'name-${widget.user.name}',
                      transitionOnUserGestures: true,
                      child: Text(
                        widget.user.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Roboto',
                          letterSpacing: 0.5,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (widget.user.rentId.length > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ContainerTitle(
                    title: widget.user.rentId.length == 1
                        ? '${widget.user.rentId.length} Book rented'
                        : '${widget.user.rentId.length} Books rented',
                  ),
                ],
              ),
            Expanded(
              child: widget.user.rentId.isEmpty
                  ? const Center(
                      child: Text(
                        'No books rented yet.',
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
                      itemCount: userRentals.length,
                      itemBuilder: (context, index) {
                        final rental = userRentals[index];
                        final book = library.getbook(rental.bookid);
                        return ListTile(
                          leading: const Icon(Icons.book, color: Colors.blue),
                          title: Text(
                            book.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Roboto',
                              letterSpacing: 0.5,
                              color: Colors.blue,
                            ),
                          ),
                          subtitle: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'by ${book.author}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                    fontFamily: 'Roboto',
                                    letterSpacing: 0.5,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  '${rental.quantity} rented',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                    fontFamily: 'Roboto',
                                    letterSpacing: 0.5,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () => {callreturnsheet(context, rental)},
                            tooltip: 'Return Book',
                            icon: Icon(Icons.undo, color: Colors.blue),
                            iconSize: 30,
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

  Future<void> callreturnsheet(BuildContext context, Rental rental) async {
    final quantity = await showReturnsheet(context, rental: rental);
    if (!context.mounted) return;
    if (quantity != 0 && quantity != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: quantity == 1
              ? Text('$quantity book returned to Library')
              : Text('$quantity books returned to Library'),
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

import 'package:flutter/material.dart';
import 'package:library_mgt/widgets/return.dart';
import 'lib.dart';

class RentedPage extends StatefulWidget {
  const RentedPage({super.key});
  @override
  State<RentedPage> createState() => _RentedPageState();
}

class _RentedPageState extends State<RentedPage>
    with AutomaticKeepAliveClientMixin {
  bool showreturn = false;
  String bookName = '';
  int bookId = 0;
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final rented = LibraryProvider.of(context).rented;
    final rentals = LibraryProvider.of(context).rentals;
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: rented.isEmpty
                  ? Center(
                      child: Text(
                        'No books available yet.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: rentals.length,
                      itemBuilder: (context, index) {
                        final rental = rentals[index];
                        final book = library.getbook(rental.bookid);
                        final user = library.getuser(rental.userid);
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
                                  '${rental.quantity} rented by',
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
                                const SizedBox(width: 3),
                                InkWell(
                                  onTap: () => {
                                    Navigator.pushNamed(
                                      context,
                                      '/userdetailscreen',
                                      arguments: user,
                                    ),
                                  },
                                  child: Text(
                                    user.name,
                                    style: TextStyle(
                                      fontSize: 17,
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
      ],
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

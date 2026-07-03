import 'package:flutter/material.dart';
import 'lib.dart';
import 'widgets/containertitle.dart';
import 'widgets/return.dart';
import 'widgets/rent.dart';
import 'widgets/adduser.dart';

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
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.surface),
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        title: Text(
          'User - ${widget.user.name}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
            fontFamily: 'Roboto',
            letterSpacing: 0.5,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                        SizedBox(width: 10),
                        IconButton(
                          onPressed: () => {
                            _calleditUserDialog(
                              context,
                              widget.user.name,
                              widget.user.id,
                            ),
                          },
                          icon: Icon(Icons.edit, color: Colors.blue),
                          iconSize: 25,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Visibility(
                    visible: widget.user.rentId.length > 1,
                    child: ContainerTitle(
                      title: widget.user.rentId.length == 1
                          ? '${widget.user.rentId.length} Book rented'
                          : '${widget.user.rentId.length} Books rented',
                    ),
                  ),
                  IconButton(
                    onPressed: () => {
                      _callrent(widget.user.name, widget.user.id),
                    },
                    icon: Icon(Icons.bookmark_add),
                    tooltip: 'Rent book',
                    color: Colors.blue,
                    iconSize: 40,
                  ),
                ],
              ),
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

  void _calleditUserDialog(
    BuildContext context,
    String userName,
    int id,
  ) async {
    final newUserName = await showAddUser(context, userName: userName, id: id);
    if (!context.mounted) return;
    if (newUserName != null && newUserName.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Name updated to \'$newUserName\''),
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

  Future<void> _callrent(String userName, int userId) async {
    int? result = await showRentsheet(
      context,
      userId: userId,
      userName: userName,
    );
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
}

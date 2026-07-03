import 'package:flutter/material.dart';
import 'package:library_mgt/lib.dart';
import 'widgets/adduser.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    final library = LibraryProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Users',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
            fontFamily: 'Roboto',
            letterSpacing: 0.5,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.close),
              color: Colors.blue,
              iconSize: 40,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => _callAddUserDialog(context),
                  tooltip: 'Add User',
                  iconSize: 40,
                  color: Colors.blue,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: library.users.length,
              itemBuilder: (context, index) {
                final user = library.users[index];
                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/userscreen',
                      arguments: user,
                    );
                  },
                  leading: const Icon(
                    Icons.person,
                    color: Colors.blue,
                    size: 30,
                  ),
                  title: Hero(
                    tag: 'name-${user.name}',
                    transitionOnUserGestures: true,
                    child: Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        fontFamily: 'Roboto',
                        letterSpacing: 0.5,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  subtitle: user.rentId.isNotEmpty
                      ? Text(
                          '${user.rentId.length.toString()} Books Rented',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Roboto',
                            letterSpacing: 0.5,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        )
                      : Text(
                          'No Books Rented',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Roboto',
                            letterSpacing: 0.5,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                  trailing: InkWell(
                    onTap: () async {
                      final delete = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          if (user.rentId.isNotEmpty) {
                            return AlertDialog(
                              icon: Icon(
                                Icons.error,
                                color: Colors.orange,
                                size: 40,
                              ),
                              content: Text(
                                'You can\'t delete a user with more than 1 books rented\n return all the books to library before continuing this action',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          }
                          return AlertDialog(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 40,
                            ),
                            title: Text('Delete ${user.name}'),
                            content: Text(
                              'You are about to permanently delete ${user.name}\nwould you like to continue',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                child: const Text('Continue'),
                              ),
                            ],
                          );
                        },
                      );
                      if (delete!) {
                        library.deleteUser(user.id);
                        deletesnackbar(delete, user.name);
                      }
                    },
                    child: Icon(Icons.delete, color: Colors.red, size: 30),
                  ),
                );
              },
              separatorBuilder: (context, index) =>
                  const Divider(indent: 16, endIndent: 16, thickness: 1),
            ),
          ),
        ],
      ),
    );
  }

  void _callAddUserDialog(BuildContext context) async {
    final newUserName = await showAddUser(context);
    if (!context.mounted) return;
    if (newUserName != null && newUserName.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User: \'$newUserName\'  created successfully'),
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

  void deletesnackbar(bool delete, String name) {
    if (delete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User: $name deleted from Library'),
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

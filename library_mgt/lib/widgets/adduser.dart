import 'package:flutter/material.dart';
import 'containertitle.dart';
import 'package:library_mgt/lib.dart';

class Adduser extends StatefulWidget {
  const Adduser({super.key, this.userName = '', this.id = 0});
  final String userName;
  final int id;

  @override
  State<Adduser> createState() => _AdduserState();
}

Future<String?> showAddUser(
  BuildContext context, {
  String userName = '',
  int id = 0,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Adduser(userName: userName, id: id),
    ),
  );
}

class _AdduserState extends State<Adduser> {
  final TextEditingController _usernamecontroller = TextEditingController();
  @override
  void initState() {
    super.initState();

    _usernamecontroller.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _usernamecontroller.text = widget.userName;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
              children: <Widget>[ContainerTitle(title: 'New Author')],
            ),
            TextField(
              controller: _usernamecontroller,
              decoration: InputDecoration(
                labelText: 'Author Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(Icons.person, color: Colors.blue, size: 30),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () => {Navigator.pop(context)},
                  icon: Icon(Icons.close, color: Colors.red),
                  iconSize: 40,
                  color: Colors.blue,
                ),
                SizedBox(width: 40),
                AnimatedScale(
                  scale: _usernamecontroller.text.trim().isNotEmpty ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 150),
                  child: IconButton(
                    onPressed: () => _savenewuser(context),
                    icon: Icon(Icons.check, color: Colors.green),
                    iconSize: 40,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _savenewuser(BuildContext context) async {
    if (widget.id != 0) {
      bool add = LibraryProvider.of(
        context,
      ).updateUser(widget.id, _usernamecontroller.text.trim());
      if (!add) {
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            icon: Icon(Icons.error, color: Colors.red),
            title: const Text("User already exists in Library"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
        return;
      }
    } else {
      LibraryProvider.of(context).addUser(_usernamecontroller.text.trim());
    }
    Navigator.pop(context, _usernamecontroller.text.trim());
  }
}

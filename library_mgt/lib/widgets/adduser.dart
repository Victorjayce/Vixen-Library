import 'package:flutter/material.dart';
import 'package:library_mgt/lib.dart';
import 'form_shell.dart';

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
    builder: (_) => appDialog(
      context: context,
      child: Adduser(userName: userName, id: id),
    ),
  );
}

class _AdduserState extends State<Adduser> {
  final TextEditingController _usernamecontroller = TextEditingController();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _usernamecontroller.addListener(() => setState(() {}));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _usernamecontroller.text = widget.userName;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _usernamecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.id != 0;

    return FormScaffold(
      icon: editing ? Icons.edit : Icons.person_add_alt_rounded,
      title: editing ? 'Edit user' : 'New user',
      subtitle: editing
          ? 'Update this reader profile.'
          : 'Register a reader who can rent books.',
      saveEnabled: _usernamecontroller.text.trim().isNotEmpty,
      onCancel: () => Navigator.pop(context),
      onSave: () => _savenewuser(context),
      children: [
        TextField(
          controller: _usernamecontroller,
          textInputAction: TextInputAction.done,
          decoration: appInputDecoration(
            context: context,
            label: 'User name',
            icon: Icons.person_outline,
          ),
          onSubmitted: (_) {
            if (_usernamecontroller.text.trim().isNotEmpty) {
              _savenewuser(context);
            }
          },
        ),
      ],
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

import 'package:flutter/material.dart';
import 'package:library_mgt/lib.dart';
import 'form_shell.dart';

class Addauthor extends StatefulWidget {
  const Addauthor({super.key, this.authorName = '', this.id = 0});
  final String authorName;
  final int id;

  @override
  State<Addauthor> createState() => _AddauthorState();
}

Future<String?> showAddAuthor(
  BuildContext context, {
  String authorName = '',
  int id = 0,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => appDialog(
      context: context,
      child: Addauthor(authorName: authorName, id: id),
    ),
  );
}

class _AddauthorState extends State<Addauthor> {
  final TextEditingController _authornamecontroller = TextEditingController();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _authornamecontroller.addListener(() => setState(() {}));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _authornamecontroller.text = widget.authorName;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _authornamecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.id != 0;

    return FormScaffold(
      icon: editing ? Icons.edit : Icons.person_add_alt_rounded,
      title: editing ? 'Edit author' : 'New author',
      subtitle: editing
          ? 'Update this author name.'
          : 'Add a writer to your library catalog.',
      saveEnabled: _authornamecontroller.text.trim().isNotEmpty,
      onCancel: () => Navigator.pop(context),
      onSave: () => _savenewauthor(context),
      children: [
        TextField(
          controller: _authornamecontroller,
          textInputAction: TextInputAction.done,
          decoration: appInputDecoration(
            context: context,
            label: 'Author name',
            icon: Icons.person_outline,
          ),
          onSubmitted: (_) {
            if (_authornamecontroller.text.trim().isNotEmpty) {
              _savenewauthor(context);
            }
          },
        ),
      ],
    );
  }

  Future<void> _savenewauthor(BuildContext context) async {
    if (widget.id != 0) {
      bool add = LibraryProvider.of(context).editAuthor(
        widget.authorName,
        widget.id,
        _authornamecontroller.text.trim(),
      );
      if (!add) {
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            icon: Icon(Icons.error, color: Colors.red),
            title: const Text("Author already exists in Library"),
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
      LibraryProvider.of(
        context,
      ).addAuthor(_authornamecontroller.text.trim(), []);
    }
    Navigator.pop(context, _authornamecontroller.text.trim());
  }
}

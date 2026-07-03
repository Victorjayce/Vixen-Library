import 'package:flutter/material.dart';
import 'containertitle.dart';
import 'package:library_mgt/lib.dart';

class Addauthor extends StatefulWidget {
  const Addauthor({super.key});

  @override
  State<Addauthor> createState() => _AddauthorState();
}

Future<String?> showAddAuthor(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Addauthor(),
    ),
  );
}

class _AddauthorState extends State<Addauthor> {
  final TextEditingController _authornamecontroller = TextEditingController();
  @override
  void initState() {
    super.initState();

    _authornamecontroller.addListener(() {
      setState(() {});
    });
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
              controller: _authornamecontroller,
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
                  scale: _authornamecontroller.text.trim().isNotEmpty
                      ? 1.0
                      : 0.0,
                  duration: Duration(milliseconds: 150),
                  child: IconButton(
                    onPressed: () => _savenewauthor(context),
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

  void _savenewauthor(BuildContext context) {
    _authornamecontroller.text.trim().isEmpty
        ? null
        : LibraryProvider.of(context).addAuthor(_authornamecontroller.text, []);

    Navigator.pop(context, _authornamecontroller.text.trim);

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Author: \'$newauthorname\'         saved'),
    //     behavior: SnackBarBehavior.floating,
    //     backgroundColor: Colors.blue.withValues(alpha: 0.5),
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    //     margin: EdgeInsets.all(16),
    //     duration: Duration(seconds: 2),
    //     showCloseIcon: true,
    //   ),
    // );
  }
}

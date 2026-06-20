import 'package:flutter/material.dart';
import 'package:library_mgt/widgets/containertitle.dart';
//import 'package:library_mgt/lib.dart';

class Addbook extends StatefulWidget {
  const Addbook({super.key});

  //final List<Author> authors;
  @override
  State<Addbook> createState() => _AddbookState();
}

class _AddbookState extends State<Addbook> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      child: Padding(
        padding:EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ContainerTitle(title: 'Add Books'),
              ],
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Book Name',
                hintText: 'Book name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: Icon(Icons.book, color: Colors.blue, size: 30,),
              ),
            ),
            SizedBox(height: 10,),
            DropdownButtonFormField<String>(
              items: [],
              onChanged: null,
              initialValue: 'new Author',
              decoration: InputDecoration(
                labelText: 'Author\'s Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  //borderSide: BorderSide(Colors.transparent),
                ),
                prefixIcon: Icon(Icons.person, color: Colors.blue, size: 35,),
              ),
            ),
            Container(
              padding: EdgeInsets.all(2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: null, 
                    icon: Icon(Icons.remove_circle, color: Colors.red),
                    iconSize: 40,
                    color: Colors.blue,
                  ),
                  ContainerTitle(title: '5'),
                  IconButton(
                    onPressed: null, 
                    icon: Icon(Icons.add_circle, color: Colors.blue,),
                    iconSize: 40,
                    color: Colors.blue,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

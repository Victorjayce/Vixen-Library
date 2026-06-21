import 'package:flutter/material.dart';
import 'package:library_mgt/widgets/addbook.dart';


class TestWidg extends StatefulWidget {
  const TestWidg({super.key});

  @override
  State<TestWidg> createState() => _TestWidgState();
}

class _TestWidgState extends State<TestWidg> {
  @override
  Widget build(BuildContext context) {
    return Addbook();
  }
}
import 'package:flutter/material.dart';

class ContainerTitle extends StatelessWidget {
  final String title;

  const ContainerTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
          fontFamily: 'Roboto',
          letterSpacing: 0.5,
          color: Colors.white,
        ),
      ),
    );
  }
}
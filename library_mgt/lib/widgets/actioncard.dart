import 'package:flutter/material.dart';

class NavCard extends StatelessWidget {
  const NavCard({
    super.key,
    required this.icon,
    required this.text,
    required this.onPage,
  });

  final IconData icon;
  final String text;
  final bool onPage;

  @override
  Widget build(BuildContext context) {
    final fg = onPage ? Colors.white : Colors.blue;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: onPage ? Colors.blue : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: fg, size: 35),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              color: fg,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

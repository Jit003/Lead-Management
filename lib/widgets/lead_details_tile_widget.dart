import 'package:flutter/material.dart';

Widget detailTile(IconData icon, String label, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: Colors.red, size: 24),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(fontSize: 15, color: Colors.black87)),
          ],
        ),
      ),
    ],
  );
}

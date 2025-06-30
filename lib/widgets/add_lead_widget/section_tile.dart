import 'package:flutter/material.dart';

Widget buildSectionTitle(String title) {
  return Text(
    title,
    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Color(0xFF1A1A1A),
    ),
  );
}

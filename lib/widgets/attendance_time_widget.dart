import 'package:flutter/material.dart';

Widget punchInfoCard({
  required IconData icon,
  required Color iconColor,
  required String label,
  required String time,
}) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.3),
          Colors.white.withOpacity(0.05),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(
        color: Colors.white.withOpacity(0.2),
        width: 1.0,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 20,
          spreadRadius: 5,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Row(
      children: [
        // Glowing Icon Circle
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                iconColor.withOpacity(0.4),
                iconColor.withOpacity(0.2),
              ],
              center: Alignment.center,
              radius: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: iconColor.withOpacity(0.4),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              icon,
              color: iconColor,
              size: 25,
            ),
          ),
        ),

        const SizedBox(width: 20),

        // Label + Time
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

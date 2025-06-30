import 'package:flutter/material.dart';

Widget buildEnhancedDropdown({
  required String label,
  required IconData icon,
  required Color color,
  required String value,
  required List<String> items,
  required Function(String?) onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
        ),
      ),
      SizedBox(height: 8),
      Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: DropdownButtonHideUnderline(
          child:
          DropdownButton<String>(
            value: value.isEmpty ? null : value,
            hint: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 12),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Text(
                  'Select  $label',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ],
            ),
            icon: Icon(Icons.arrow_drop_down, color: Colors.grey[400]),
            isExpanded: true,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 12),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: color, size: 20),
                    ),
                    Text(item),
                  ],
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    ],
  );
}
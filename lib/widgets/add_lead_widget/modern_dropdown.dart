import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

Widget buildModernDropdown({
  required String label,
  required String? value,
  required List<String> items,
  required ValueChanged<String?> onChanged,
   String? hint,
  bool isEnabled = true,
}) {
  final uniqueItems = items.toSet().toList();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1A1A1A),
        ),
      ),
      const SizedBox(height: 8),
      DropdownSearch<String>(
        items: uniqueItems,
        selectedItem: value,
        enabled: isEnabled,
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            hintText: hint,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
            ),
          ),
        ),
        popupProps: const PopupProps.menu(
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: 'Search...',
              border: OutlineInputBorder(),
              contentPadding:
              EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
          fit: FlexFit.loose,
        ),
        onChanged: onChanged,
      ),
    ],
  );
}










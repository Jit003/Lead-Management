import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int maxLines;
  final FormFieldValidator<String>? validator; // ✅ FIXED
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final Color? borderColor;

  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(15),
      child: TextFormField(
        validator: validator,
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        onChanged: onChanged,
        textInputAction: textInputAction,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: label,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          prefixIcon: Icon(prefixIcon, color: Colors.redAccent),
          suffixIcon: suffixIcon,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: borderColor ?? Colors.redAccent,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

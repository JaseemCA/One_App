import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool obscureText;
  final IconData prefixIcon;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onPressed;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final void Function(String)? onFieldSubmitted;

  const CustomTextField({
    super.key,
    this.onFieldSubmitted,
    this.controller,
    required this.labelText,
    required this.hintText,
    this.obscureText = false,
    required this.prefixIcon,
    this.keyboardType,
    this.onChanged,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onFieldSubmitted: onFieldSubmitted,
      keyboardType: keyboardType,
      onChanged: onChanged,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        prefixIcon: IconButton(
          icon: Icon(
            prefixIcon,
            color: Colors.white,
          ),
          onPressed: onPressed,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}

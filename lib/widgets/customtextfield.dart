import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.keyboardtype,
  });

  final TextEditingController controller;

  final String label;

  final TextInputType keyboardtype;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        labelText: label,
      ),
      keyboardType: keyboardtype,
      validator: (value) {
        return null;
      },
    );
  }
}

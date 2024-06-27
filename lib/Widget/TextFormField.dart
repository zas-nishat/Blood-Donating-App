import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? initialValue;
  final Icon icon;

  const TextFormFieldWidget({
    Key? key,
    required this.controller,
    this.initialValue,
    required this.label,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: icon,
          labelText: label,
          filled: true,
          fillColor: Colors.black.withOpacity(0.1),
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the $label';
          }
          return null;
        },
      ),
    );
  }
}

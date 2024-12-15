import 'package:flutter/material.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart'; // Import the package

class CustomTextWidget extends StatelessWidget {
  const CustomTextWidget({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 80),
      child: Container(
        height: 100,
        child: AutoSizeTextField(
          controller: controller,
          cursorColor: Colors.redAccent,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          style: const TextStyle(
            fontSize: 40, // Initial font size
          ),
          minFontSize: 20, // Set minimum font size to prevent text from shrinking too much
          maxLines: 1, // Keep it as a single line
          readOnly: true,
          autofocus: true,
          showCursor: true,
          textAlign: TextAlign.right, // Align text to the right
          keyboardType: TextInputType.none, // Disable keyboard
        ),
      ),
    );
  }
}

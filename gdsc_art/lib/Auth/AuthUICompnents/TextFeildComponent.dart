import 'package:flutter/material.dart';
import 'package:gdsc_artwork/Constants/Colors.dart';

class TextFieldComponent extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;

  TextFieldComponent({
    required this.labelText,
    required this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.75,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.grey[600]),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: CustomColors.primaryBrown),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: CustomColors.primaryBrown),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

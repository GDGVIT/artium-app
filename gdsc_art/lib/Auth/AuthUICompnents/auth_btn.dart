import 'package:flutter/material.dart';
import 'package:gdsc_artwork/Constants/Colors.dart';

class AuthButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const AuthButton(
      {super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.75,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.secondaryBrown,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gdsc_artwork/Constants/Colors.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      child: const Row(
        children: [
          Expanded(
            child: Divider(
              color: CustomColors.primaryBrown,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'or',
              style: TextStyle(color: CustomColors.primaryBrown),
            ),
          ),
          Expanded(
            child: Divider(
              color: CustomColors.primaryBrown,
            ),
          ),
        ],
      ),
    );
  }
}

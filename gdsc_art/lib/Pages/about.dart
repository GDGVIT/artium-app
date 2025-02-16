import 'package:flutter/material.dart';
import 'package:gdsc_artwork/Constants/Colors.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: CustomColors.primaryBlack,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40.0),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: RichText(
                text: const TextSpan(
                  text: 'What kind of ',
                  style: TextStyle(
                      color: CustomColors.primaryWhite,
                      fontSize: 24,
                      fontFamily: "OutfitRegular",
                      fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'technology ',
                      style: TextStyle(
                          fontFamily: "OutfitRegular",
                          color: CustomColors.primaryCream,
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '\n did we use?'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.0),
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                'This is an implementation of an arbitrary style transfer algorithm running purely in the browser using Tensor Flow.js. As with all neural style transfer algorithms, a neural network attempts to "draw" one picture, the Content (usually a photograph), in the style of another, the Style (usually a painting).',
                style: TextStyle(
                  color: CustomColors.primaryWhite,
                  fontSize: 16,
                  fontFamily: "OutfitRegular",
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                  ),
                  SizedBox(width: 20.0),
                  const Text(
                    '+',
                    style: TextStyle(
                        color: CustomColors.primaryWhite, fontSize: 20),
                  ),
                  SizedBox(width: 20.0),
                  Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                  ),
                  SizedBox(width: 20.0),
                  const Text(
                    "=",
                    style: TextStyle(
                        color: CustomColors.primaryWhite, fontSize: 20),
                  ),
                  const SizedBox(width: 20.0),
                  Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

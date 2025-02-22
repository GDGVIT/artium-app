import 'package:flutter/material.dart';
import 'package:artium/Constants/Colors.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0D0C0D),
            Color(0xFF1A181A),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment(1, -0.9),
              child: Image.asset('images/general_right.png'),
            ),
            Align(
              alignment: Alignment(-1, .91),
              child: Image.asset('images/general_left.png'),
            ),
            Padding(
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
                  const SizedBox(height: 30.0),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Our project utilizes Neural Style Transfer (NST), powered by a pre-trained VGG19 network. NST combines the content of one image with the artistic style of another, using convolutional neural networks, Gram matrices, and loss functions to create unique, visually captivating images that blend structure and texture.',
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
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: Image.asset('images/rec-1.png'),
                        ),
                        const SizedBox(width: 20.0),
                        const Text(
                          '+',
                          style: TextStyle(
                              color: CustomColors.primaryWhite, fontSize: 20),
                        ),
                        const SizedBox(width: 20.0),
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: Image.asset('images/rec-3.png'),
                        ),
                        const SizedBox(width: 20.0),
                        const Text(
                          "=",
                          style: TextStyle(
                              color: CustomColors.primaryWhite, fontSize: 20),
                        ),
                        const SizedBox(width: 20.0),
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: Image.asset('images/rec-2.png'),
                        ),
                      ],
                    ),
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

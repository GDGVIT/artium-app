import 'package:flutter/material.dart';

import '../../Constants/Colors.dart';

class ToggleSection extends StatelessWidget {
  final bool isLogin;
  final VoidCallback toggleView;

  const ToggleSection(
      {super.key, required this.isLogin, required this.toggleView});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: CustomColors.primaryBlack,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: CustomColors.primaryBrown),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!isLogin) toggleView();
              },
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: isLogin
                      ? CustomColors.secondaryBrown
                      : CustomColors.primaryBlack,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    bottomLeft: const Radius.circular(12),
                    topRight: isLogin ? const Radius.circular(12) : Radius.zero,
                    bottomRight:
                        isLogin ? const Radius.circular(12) : Radius.zero,
                  ),
                ),
                child: Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isLogin ? Colors.black : Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (isLogin) toggleView();
              },
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: isLogin
                      ? CustomColors.primaryBlack
                      : CustomColors.secondaryBrown,
                  borderRadius: BorderRadius.only(
                    topLeft: isLogin ? Radius.zero : const Radius.circular(12),
                    bottomLeft:
                        isLogin ? Radius.zero : const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomRight: const Radius.circular(12),
                  ),
                ),
                child: Text(
                  'Signup',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isLogin ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

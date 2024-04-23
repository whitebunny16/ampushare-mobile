import 'package:ampushare/widgets/layouts/auth_layout/_widgets/BottomStackedCircle.dart';
import 'package:ampushare/widgets/layouts/auth_layout/_widgets/TopStackedCircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenHeight,
      width: screenWidth,
      child: Column(
        children: [
          Transform(
            transform: Matrix4.identity()
              ..translate(screenWidth * -0.1, screenHeight * 0.1),
            child: Container(
              width: 182,
              height: 39,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/logos/ampushare-gradient.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const TopStackedCircle(),
          const BottomStackedCircle(),
        ],
      ),
    );
  }
}

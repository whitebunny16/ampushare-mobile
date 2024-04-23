import 'package:flutter/material.dart';

class TopStackedCircle extends StatelessWidget {
  const TopStackedCircle({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Transform(
      transform: Matrix4.identity()
        ..translate(screenWidth * 0.45, screenHeight * -0.1),
      child: SizedBox(
        width: 213,
        height: 213,
        child: Stack(
          children: [
            Positioned(
              left: 18,
              top: 0,
              child: Container(
                width: 195,
                height: 195,
                decoration: const ShapeDecoration(
                  color: Color(0xFF009781),
                  shape: OvalBorder(),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 38,
              child: Container(
                width: 175,
                height: 175,
                decoration: const ShapeDecoration(
                  color: Color(0x7F009781),
                  shape: OvalBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


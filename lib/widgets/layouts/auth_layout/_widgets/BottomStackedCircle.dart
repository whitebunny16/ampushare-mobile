import 'package:flutter/material.dart';

class BottomStackedCircle extends StatelessWidget {
  const BottomStackedCircle({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Transform(
      transform: Matrix4.identity()
        ..translate(screenWidth * 0.15, screenHeight * 0.85)
        ..rotateZ(3.14),
      child: SizedBox(
        width: 232,
        height: 235,
        child: Stack(
          children: [
            Positioned(
              left: 19.61,
              top: 0,
              child: Container(
                width: 212.39,
                height: 215.14,
                decoration: const ShapeDecoration(
                  color: Color(0xFF009781),
                  shape: OvalBorder(),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 41.92,
              child: Container(
                width: 190.61,
                height: 193.08,
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

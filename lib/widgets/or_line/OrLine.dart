import 'package:flutter/material.dart';

class OrLine extends StatelessWidget {
  const OrLine({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 282,
      height: 22.11,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 11.58,
            child: Container(
              width: 110,
              decoration: const ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: Color(0xFF9B9B9B),
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            left: 133,
            top: 0,
            child: SizedBox(
              width: 20,
              height: 22.11,
              child: Text(
                'or',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 11.58,
            child: Container(
              width: 110,
              decoration: const ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: Color(0xFF9B9B9B),
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


import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TopRightDecoration extends HookWidget {
  const TopRightDecoration({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: -80,
      top: -80,
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

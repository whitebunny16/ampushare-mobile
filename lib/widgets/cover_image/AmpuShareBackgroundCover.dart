import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AmpuShareBackgroundCover extends HookWidget {
  const AmpuShareBackgroundCover({super.key});

  @override
  Widget build(BuildContext context) {
    double SCREEN_WIDTH = MediaQuery.of(context).size.width;

    return Positioned(
      left: 0,
      top: 0,
      child: SizedBox(
        width: SCREEN_WIDTH,
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: Container(
            decoration: const ShapeDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/ampushare-cover.png"),
                fit: BoxFit.fill,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

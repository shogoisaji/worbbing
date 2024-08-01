import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

const double offsetX = 5.0;
const double offsetY = 4.0;
const double rotationAngle = 0.05;
const int maxRandomValue = 10;
const int animationDelayMultiplier = 30;
const int animationDuration = 1000;

Widget noticeBlock(double size, int number, Color color, bool isShake) {
  Random random = Random();
  final fontSize = size * 0.60;
  final textStyle = GoogleFonts.notoSans(
      color: Colors.black, fontSize: fontSize, fontWeight: FontWeight.w500);
  final infinityTextStyle = GoogleFonts.roboto(
      color: Colors.black, fontSize: fontSize, fontWeight: FontWeight.w400);

  return Stack(
    children: [
      Transform.translate(
        offset: const Offset(offsetX, offsetY),
        child: Transform.rotate(
          angle: rotationAngle,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(size * 0.025),
            ),
          ),
        ),
      ),
      Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(size * 0.025),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 7,
            ),
          ],
        ),
        child: number == 99
            ? Text(
                '∞',
                style: infinityTextStyle,
              )
            : Text(
                number.toString(),
                style: textStyle,
              ),
      ).animate().shake(
            duration: animationDuration.milliseconds,
            delay: (random.nextInt(maxRandomValue) * animationDelayMultiplier)
                .milliseconds,
            hz: isShake ? 5 : 0,
          ),
    ],
  );
}

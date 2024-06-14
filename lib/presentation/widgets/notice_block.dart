import 'dart:math';

import 'package:flutter/material.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

const double offsetX = 5.0;
const double offsetY = 4.0;
const double rotationAngle = 0.05;
const int maxRandomValue = 10;
const int animationDelayMultiplier = 30;
const int animationDuration = 1000;

Widget noticeBlock(double size, int number, Color color) {
  Random random = Random();
  final fontSize = size * 0.60;
  final textStyle = TextStyle(
    color: Colors.black,
    fontSize: fontSize,
  );

  return Stack(
    children: [
      Transform.translate(
        offset: const Offset(offsetX, offsetY),
        child: Transform.rotate(
          angle: rotationAngle,
          child: Container(
            width: size,
            height: size,
            color: Colors.white,
          ),
        ),
      ),
      Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        color: color,
        child: Text(
          number == 99 ? '∞' : number.toString(),
          style: textStyle,
        ),
      ).animate().shake(
            duration: animationDuration.milliseconds,
            delay: (random.nextInt(maxRandomValue) * animationDelayMultiplier)
                .milliseconds,
            hz: color == MyTheme.orange ? 5 : 0,
          ),
    ],
  );
}

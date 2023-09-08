import 'dart:math';

import 'package:flutter/material.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:flutter_animate/flutter_animate.dart';

Widget noticeBlock(double size, int number, Color color) {
  Random random = Random();
  int randomNumber = random.nextInt(10);
  final fontSize = size * 0.60;
  return Stack(
    children: [
      Transform.translate(
        offset: const Offset(5, 4),
        child: Transform.rotate(
          angle: 0.05,
          child: Container(
            width: size,
            height: size,
            color: Colors.white,
          ),
        ),
      ),
      Container(
        alignment: Alignment.center,
        width: size,
        height: size,
        color: color,
        child: Center(
            child: titleText(
                number != 0
                    ? number.toString()
                    : number.toString().padLeft(2, '0'),
                Colors.black,
                fontSize)),
      ).animate().shake(
            duration: 1500.milliseconds,
            delay: (randomNumber * 30).milliseconds,
            hz: color == MyTheme.orange ? 5 : 0,
          ),
    ],
  );
}

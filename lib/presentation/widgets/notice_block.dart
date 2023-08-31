import 'package:flutter/material.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';

Widget noticeBlock(double size, int number, Color color) {
  final fontSize = size * 0.60;
  return Stack(
    children: [
      Transform.translate(
        offset: const Offset(3, 2),
        child: Transform.rotate(
          angle: 0.06,
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
      )
    ],
  );
}

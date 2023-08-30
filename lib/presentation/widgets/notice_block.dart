import 'package:flutter/material.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';

Widget noticeBlock(double size, int number, Color color) {
  final fontSize = size * 0.65;
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
        width: size,
        height: size,
        padding: const EdgeInsets.only(bottom: 10),
        color: color,
        child:
            Center(child: titleText(number.toString(), Colors.black, fontSize)),
      )
    ],
  );
}

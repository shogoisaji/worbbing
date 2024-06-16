import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget customButton(Color color, Widget widget, Function() function,
    {double width = 140, double height = 50}) {
  return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        function();
      },
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            Transform.scale(
              scaleX: 1.03,
              scaleY: 1.0,
              child: Transform.rotate(
                angle: 0.06,
                child: Container(
                  width: width,
                  height: 60,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: width,
              height: 60,
              color: color,
              child: widget,
            ),
          ],
        ),
      ));
}

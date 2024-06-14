import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:worbbing/presentation/theme/theme.dart';

Widget customButton2(Color color, Widget widget, Function() function) {
  return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        function();
      },
      child: SizedBox(
        width: 120,
        height: 40,
        child: Stack(
          children: [
            Transform.translate(
              offset: const Offset(3, 4),
              child: Transform.rotate(
                angle: 0.02,
                child: Container(
                  width: 114,
                  height: 60,
                  color: MyTheme.grey,
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 7,
                  height: 60,
                  color: color,
                ),
                const SizedBox(
                  width: 4,
                ),
                Container(
                  width: 7,
                  height: 60,
                  color: color,
                ),
                const SizedBox(
                  width: 4,
                ),
                Container(
                  alignment: Alignment.center,
                  width: 90,
                  height: 60,
                  color: color,
                  child: widget,
                ),
              ],
            ),
          ],
        ),
      ));
}

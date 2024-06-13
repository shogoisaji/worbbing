import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:worbbing/presentation/theme/theme.dart';

Widget customButton(Widget widget, Function() function) {
  return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        function();
      },
      child: SizedBox(
        width: 170,
        height: 50,
        child: Stack(
          children: [
            Transform.translate(
              offset: const Offset(3, 4),
              child: Transform.rotate(
                angle: 0.02,
                child: Container(
                  width: 155,
                  height: 60,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            SizedBox(
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 60,
                    color: MyTheme.orange,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 60,
                    color: MyTheme.orange,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 120,
                    height: 60,
                    color: MyTheme.orange,
                    child: widget,
                  ),
                ],
              ),
            ),
          ],
        ),
      ));
}

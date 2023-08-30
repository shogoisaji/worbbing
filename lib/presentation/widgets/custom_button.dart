import 'package:flutter/material.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';

Widget customButton() {
  return GestureDetector(
      onTap: () {
        //
      },
      child: Container(
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
                  color: MyTheme.grey,
                ),
              ),
            ),
            Container(
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 60,
                    color: MyTheme.orange,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    width: 10,
                    height: 60,
                    color: MyTheme.orange,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 120,
                    height: 60,
                    color: MyTheme.orange,
                    child: titleText('SAVE', Colors.black, null),
                  ),
                ],
              ),
            ),
          ],
        ),
      ));
}

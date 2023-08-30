import 'package:flutter/material.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';

Widget tagSelect(String tag, int tagState, int index, Function() onTap) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 30,
        child: Column(
          children: [
            bodyText(tag, null),
            if (tagState == index)
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: MyTheme.lemon,
                  borderRadius: BorderRadius.circular(3.5),
                ),
              )
          ],
        ),
      ),
    ),
  );
}

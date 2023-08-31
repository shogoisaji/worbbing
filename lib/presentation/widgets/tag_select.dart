import 'package:flutter/material.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';

Widget tagSelect(String tag, int tagState, int index, Function() onTap) {
  return Container(
    width: 100,
    height: 37,
    child: InkWell(
      onTap: onTap,
      child: Column(
        children: [
          bodyText(tag, null),
          if (tagState == index)
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: MyTheme.lemon,
                borderRadius: BorderRadius.circular(4),
              ),
            )
        ],
      ),
    ),
  );
}

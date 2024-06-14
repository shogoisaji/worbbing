import 'package:flutter/material.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';

Widget tagSelect(String tag, int tagState, int index, Function() onTap) {
  return InkWell(
    onTap: onTap,
    child: Column(
      children: [
        if (tagState == index) ...{
          bodyTextB(tag, null),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: MyTheme.lemon,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        } else
          Column(
            children: [
              bodyText(tag, Colors.white70),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
              )
            ],
          ),
      ],
    ),
  );
}

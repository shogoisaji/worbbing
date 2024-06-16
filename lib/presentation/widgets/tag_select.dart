import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:worbbing/presentation/theme/theme.dart';

Widget tagSelect(String tag, int tagState, int index, Function() onTap) {
  return InkWell(
    onTap: () {
      HapticFeedback.lightImpact();
      onTap();
    },
    child: Column(
      children: [
        if (tagState == index) ...{
          Text(tag,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              )),
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
              Text(tag,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  )),
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

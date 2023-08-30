import 'package:flutter/material.dart';
import 'package:worbbing/presentation/theme/theme.dart';

Widget registrationTextField() {
  return Stack(
    children: [
      Transform.translate(
        offset: const Offset(6, 6),
        child: Transform.rotate(
            angle: 0.02,
            child: Container(width: 300, height: 80, color: MyTheme.lemon)),
      ),
      Container(
          width: 300,
          height: 80,
          color: Colors.white,
          child: TextField(
              //
              )),
    ],
  );
}

Widget registrationMemoTextField() {
  return Stack(
    children: [
      Transform.translate(
        offset: const Offset(6, 6),
        child: Transform.rotate(
            angle: 0.02,
            child: Container(width: 300, height: 150, color: MyTheme.orange)),
      ),
      Container(
          width: 300,
          height: 150,
          color: Colors.white,
          child: TextField(
              //
              )),
    ],
  );
}

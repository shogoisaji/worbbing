import 'package:flutter/material.dart';
import 'package:worbbing/presentation/theme/theme.dart';

Widget originalTextField(controller) {
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
        color: MyTheme.lightGrey,
        child: TextField(
            //
            keyboardType: TextInputType.visiblePassword,
            decoration: const InputDecoration(border: InputBorder.none),
            textAlign: TextAlign.center,
            controller: controller,
            style: TextStyle(
              fontSize: 36,
              color: Colors.black,
            )),
      )
    ],
  );
}

Widget translatedTextField(controller) {
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
        color: MyTheme.lightGrey,
        child: TextField(
            //
            keyboardType: TextInputType.text,
            decoration: InputDecoration(border: InputBorder.none),
            textAlign: TextAlign.center,
            controller: controller,
            style: TextStyle(
              fontSize: 28,
              color: Colors.black,
            )),
      )
    ],
  );
}

Widget memoTextField(controller) {
  return Stack(
    children: [
      Transform.translate(
        offset: const Offset(6, 6),
        child: Transform.rotate(
            angle: 0.02,
            child: Container(width: 300, height: 150, color: MyTheme.orange)),
      ),
      Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          width: 300,
          height: 150,
          color: MyTheme.lightGrey,
          child: TextField(
              //
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              decoration: InputDecoration(border: InputBorder.none),
              controller: controller,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ))),
    ],
  );
}

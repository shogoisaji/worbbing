import 'package:flutter/material.dart';

class AppTextStyles {
  // 日本語フォントを指定
  static const titleStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    fontFamily: 'SawarabiGothic',
  );

  static const bigStyle = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: 'SawarabiGothic',
  );

  static const subTitleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: 'SawarabiGothic',
  );

  static const mediumStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    fontFamily: 'SawarabiGothic',
  );

  static const bodyStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    fontFamily: 'SawarabiGothic',
  );

  static const bodyStyleB = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: 'SawarabiGothic',
  );

  static const bodyStyle2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    fontFamily: 'SawarabiGothic',
  );
}

Widget titleText(String text, Color? color, double? fontSize) {
  return Text(text,
      style: AppTextStyles.titleStyle.copyWith(
          color: color,
          decoration: TextDecoration.none,
          fontSize: fontSize,
          overflow: TextOverflow.ellipsis));
}

Widget bigText(String text, Color? color) {
  return Text(text,
      style: AppTextStyles.bigStyle.copyWith(
          color: color,
          decoration: TextDecoration.none,
          overflow: TextOverflow.ellipsis));
}

Widget subText(String text, Color? color) {
  return Text(text,
      style: AppTextStyles.subTitleStyle.copyWith(
          color: color,
          decoration: TextDecoration.none,
          overflow: TextOverflow.ellipsis));
}

Widget mediumText(String text, Color? color) {
  return Text(text,
      style: AppTextStyles.mediumStyle
          .copyWith(color: color, decoration: TextDecoration.none));
}

Widget bodyText(String text, Color? color) {
  return Text(text,
      style: AppTextStyles.bodyStyle
          .copyWith(color: color, decoration: TextDecoration.none));
}

Widget bodyTextB(String text, Color? color) {
  return Text(text,
      style: AppTextStyles.bodyStyleB
          .copyWith(color: color, decoration: TextDecoration.none));
}

Widget bodyText2(String text, Color? color) {
  return Text(text,
      style: AppTextStyles.bodyStyle2
          .copyWith(color: color, decoration: TextDecoration.none));
}

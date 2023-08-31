import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // 日本語フォントを指定
  static final titleStyle = GoogleFonts.zenKakuGothicNew(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static final bigStyle = GoogleFonts.zenKakuGothicNew(
    fontSize: 48,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static final subTitleStyle = GoogleFonts.zenKakuGothicNew(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static final mediumStyle = GoogleFonts.zenKakuGothicNew(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  static final bodyStyle = GoogleFonts.zenKakuGothicNew(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  static final bodyStyle2 = GoogleFonts.zenKakuGothicNew(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );
}

Widget titleText(String text, Color? color, double? fontSize) {
  return Text(text,
      style: AppTextStyles.titleStyle.copyWith(
          color: color, decoration: TextDecoration.none, fontSize: fontSize));
}

Widget bigText(String text, Color? color) {
  return Text(text,
      style: AppTextStyles.bigStyle
          .copyWith(color: color, decoration: TextDecoration.none));
}

Widget subText(String text, Color? color) {
  return Text(text,
      style: AppTextStyles.subTitleStyle
          .copyWith(color: color, decoration: TextDecoration.none));
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

Widget bodyText2(String text, Color? color) {
  return Text(text,
      style: AppTextStyles.bodyStyle2
          .copyWith(color: color, decoration: TextDecoration.none));
}

import 'package:flutter/material.dart';

class MyTheme {
  static Color lemon = const Color(0xFFE5FF70);
  static Color beige = const Color(0xFFDAC6A9);
  static Color grey = const Color(0xFF232B34);
  static Color appBarGrey = const Color(0xFF373D3E);
  static Color grey2 = const Color(0xFF455153);
  static Color darkGrey = const Color(0xFF1D2027);
  static Color lightGrey = const Color(0xFFECECEC);
  static Color dialogGrey = const Color(0xFF343842);
  static Color greyForOrange = const Color(0xFF515257);

  static Color orange = const Color(0xFFFF974C);
  static Color blue = const Color(0xFF526BF2);
  static Color red = const Color(0xFFEA4040);

  static LinearGradient bgGradient = const LinearGradient(
    colors: [
      Color(0xFF181A1A),
      Color(0xFF111721),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

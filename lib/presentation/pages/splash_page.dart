import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';

import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/routes/router.dart';

class AppSplashPage extends StatefulWidget {
  const AppSplashPage({super.key});

  @override
  State<StatefulWidget> createState() => _AppSplashPageState();
}

class _AppSplashPageState extends State<AppSplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 900), () {
      context.pushReplacement(PagePath.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: MyTheme.bgGradient,
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Lottie.asset('assets/lottie/splash.json', repeat: false),
          ),
        ),
      ],
    );
  }
}

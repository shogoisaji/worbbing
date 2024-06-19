import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

import 'package:worbbing/pages/home_page.dart';

class AppSplashPage extends StatefulWidget {
  const AppSplashPage({super.key});

  @override
  State<StatefulWidget> createState() => _AppSplashPageState();
}

class _AppSplashPageState extends State<AppSplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 800), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
            var opacityAnimation = animation.drive(tween);

            return FadeTransition(
              opacity: opacityAnimation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: SizedBox(
          width: 200,
          height: 200,
          child: Lottie.asset('assets/lottie/splash.json', repeat: false),
        ),
      ),
    );
  }
}

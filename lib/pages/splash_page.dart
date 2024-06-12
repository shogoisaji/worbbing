import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rive/rive.dart';

class AppSplashPage extends StatefulWidget {
  const AppSplashPage({super.key});

  @override
  State<StatefulWidget> createState() => _AppSplashPageState();
}

class _AppSplashPageState extends State<AppSplashPage> {
  late RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SimpleAnimation('opening');

    Future.delayed(const Duration(milliseconds: 2100), () {
      Navigator.of(context).pushReplacementNamed('/home');
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
        child: RiveAnimation.asset(
          'assets/rive/worbbing.riv',
          controllers: [_controller],
          onInit: (_) => setState(() => _controller.isActive = true),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}

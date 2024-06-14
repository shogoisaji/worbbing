import 'package:flutter/material.dart';
import 'package:worbbing/presentation/theme/theme.dart';

Widget customFloatingActionButton(BuildContext context,
    AnimationController animationController, Animation animation) {
  return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        return Stack(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(65),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(20.0, 15.0),
                    blurRadius: 15.0,
                    spreadRadius: 50.0,
                  ),
                ],
              ),
            ),
            Transform.rotate(
              angle: 1.5,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.zero,
                  color: MyTheme.grey,
                ),
              ),
            ),
            Transform.rotate(
              angle: 1.2 * animation.value,
              child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.zero,
                    color: MyTheme.orange,
                  ),
                  child: FloatingActionButton(
                      elevation: 0,
                      backgroundColor: MyTheme.orange,
                      onPressed: () {
                        animationController.forward();

                        Future.delayed(
                            const Duration(milliseconds: 1500), () {});
                      },
                      child: Transform.rotate(
                        angle: -1.2,
                        child: const Icon(
                          Icons.add,
                          size: 32,
                        ),
                      ))),
            ),
          ],
        );
      });
}

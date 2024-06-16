import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget customButton(Color color, Widget widget, Function() function,
    {double width = 140, double height = 50}) {
  return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        function();
      },
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            Transform.scale(
              scaleX: 1.03,
              scaleY: 1.0,
              // offset: const Offset(0, 0),
              child: Transform.rotate(
                angle: 0.06,
                child: Container(
                  width: width,
                  height: 60,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: width,
              height: 60,
              color: color,
              child: widget,
            ),
          ],
        ),
      )
      // child: SizedBox(
      //   width: width,
      //   height: height,
      //   child: Stack(
      //     children: [
      //       Transform.translate(
      //         offset: const Offset(3, 4),
      //         child: Transform.rotate(
      //           angle: 0.02,
      //           child: Container(
      //             width: width - 15,
      //             height: 60,
      //             color: Colors.grey.shade600,
      //           ),
      //         ),
      //       ),
      //       SizedBox(
      //         child: Row(
      //           children: [
      //             Container(
      //               width: 10,
      //               height: 60,
      //               color: color,
      //             ),
      //             const SizedBox(
      //               width: 6,
      //             ),
      //             Container(
      //               width: 10,
      //               height: 60,
      //               color: color,
      //             ),
      //             const SizedBox(
      //               width: 6,
      //             ),
      //             Container(
      //               alignment: Alignment.center,
      //               width: width - 50,
      //               height: 60,
      //               color: color,
      //               child: widget,
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // )
      );
}

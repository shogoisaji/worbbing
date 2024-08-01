import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Demo {
  final String title;
  final String lottie;
  const Demo({required this.title, required this.lottie});
}

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final demo = [
      const Demo(title: 'Vocabulary Check', lottie: 'assets/lottie/demo1.json'),
      const Demo(title: 'Registration', lottie: 'assets/lottie/demo2.json'),
      const Demo(title: 'Notification', lottie: 'assets/lottie/demo3.json'),
    ];
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final viewPortRate = switch (h) {
      > 900 => 0.37,
      > 700 => 0.47,
      _ => 0.57,
    };
    return Material(
      color: Colors.black.withOpacity(0.8),
      child: Align(
        alignment: Alignment.center,
        child: PageView.builder(
          itemCount: demo.length,
          scrollDirection: Axis.vertical,
          controller: PageController(viewportFraction: viewPortRate),
          itemBuilder: (context, index) {
            const angleList = [-0.04, 0.04, -0.03];
            const offsetList = [
              Offset(-2, -100.0),
              Offset(12, -80.0),
              Offset(12, -60.0)
            ];
            return Align(
              alignment: Alignment.bottomCenter,
              child: OverflowBox(
                alignment: Alignment.bottomCenter,
                maxHeight: double.infinity,
                child: Transform.rotate(
                  angle: angleList[index],
                  child: Transform.translate(
                    offset: offsetList[index],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          demo[index].title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Lottie.asset(
                          width: w.clamp(200, 500),
                          demo[index].lottie,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

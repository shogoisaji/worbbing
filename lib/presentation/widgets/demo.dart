import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Demo {
  final String title;
  final String lottie;
  const Demo({required this.title, required this.lottie});
}

class AnimationControllerManager {
  final int count;
  final List<AnimationController> controllers;

  AnimationControllerManager({
    required this.count,
    required TickerProvider vsync,
  }) : controllers = List.generate(
            count,
            (index) => AnimationController(
                vsync: vsync, duration: const Duration(milliseconds: 1000)));

  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
  }

  void play(int index) {
    controllers[index].repeat();
  }

  void stop(int index) {
    final l =
        controllers.where((controller) => controller != controllers[index]);
    for (var controller in l) {
      controller.reset();
    }
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> with TickerProviderStateMixin {
  PageController _pageController = PageController(viewportFraction: 0.5);
  late AnimationControllerManager _animationControllerManager;
  int _currentIndex = 0;
  double _opacity = 0.0;

  final demo = [
    const Demo(title: 'Vocabulary Check', lottie: 'assets/lottie/demo1.json'),
    const Demo(title: 'Registration', lottie: 'assets/lottie/demo2.json'),
    const Demo(title: 'Notification', lottie: 'assets/lottie/demo3.json'),
  ];

  void _updateLottieDuration(int index, int milliseconds) {
    setState(() {
      _animationControllerManager.controllers[index].duration =
          Duration(milliseconds: milliseconds);
    });
    _animationControllerManager.play(_currentIndex);
  }

  void _updatePageController(double value) {
    setState(() {
      _pageController = PageController(viewportFraction: value);
    });
  }

  @override
  void initState() {
    super.initState();
    _animationControllerManager =
        AnimationControllerManager(count: demo.length, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final w = MediaQuery.of(context).size.width;
      final adjust = w > 500 ? 0.1 : 0;
      final viewPortRate = 0.4 + w / 6000 + adjust;
      _updatePageController(viewPortRate);
      Future.delayed(const Duration(milliseconds: 100), () {
        _pageController.addListener(() {
          final page = _pageController.page;
          _currentIndex = page?.round() ?? 0;
          _animationControllerManager.play(_currentIndex);
          _animationControllerManager.stop(_currentIndex);
        });
      });

      setState(() {
        _opacity = 1;
      });
    });
  }

  @override
  void dispose() {
    _animationControllerManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.8),
      child: AnimatedOpacity(
        opacity: _opacity,
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 400),
        child: Align(
          alignment: Alignment.center,
          child: PageView.builder(
            itemCount: demo.length,
            scrollDirection: Axis.vertical,
            controller: _pageController,
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
                            demo[index].lottie,
                            controller:
                                _animationControllerManager.controllers[index],
                            onLoaded: (composition) {
                              _updateLottieDuration(
                                  index, composition.duration.inMilliseconds);
                            },
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
      ),
    );
  }
}

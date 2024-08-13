import 'package:auto_size_text/auto_size_text.dart';
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

  double contentWidth = 0.0;

  final List<Color> gradientColors1 = [
    const Color.fromARGB(255, 116, 20, 105),
    const Color.fromARGB(255, 42, 50, 95),
    const Color.fromARGB(255, 38, 103, 82),
  ];
  final List<Color> gradientColors2 = [
    const Color.fromARGB(255, 95, 9, 105),
    const Color.fromARGB(255, 73, 42, 95),
    const Color.fromARGB(255, 21, 75, 92),
  ];

  final demo = [
    const Demo(title: 'Vocabulary Check', lottie: 'assets/lottie/home.json'),
    const Demo(
        title: 'Registration', lottie: 'assets/lottie/registration.json'),
    const Demo(
        title: 'Notification', lottie: 'assets/lottie/notification.json'),
    const Demo(title: 'Sharing Text', lottie: 'assets/lottie/share.json'),
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
      final h = MediaQuery.of(context).size.height;
      contentWidth = w.clamp(100, 700);
      final viewPortRate = (contentWidth * 1.2) / h;
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
              return Transform.translate(
                offset: const Offset(0, -50),
                child: Align(
                  child: SizedBox(
                    width: contentWidth,
                    child: Column(
                      children: [
                        SizedBox(
                          height: contentWidth * 0.13,
                          width: contentWidth,
                          child: Center(
                            child: AutoSizeText(
                              demo[index].title,
                              maxLines: 1,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 16, bottom: 8, left: 16, right: 16),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.white24, width: 1.5),
                              gradient: LinearGradient(
                                begin: const Alignment(-0.2, -1.0),
                                end: const Alignment(1.5, 0.2),
                                colors: index % 2 == 0
                                    ? gradientColors1
                                    : gradientColors2,
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Lottie.asset(
                              demo[index].lottie,
                              controller: _animationControllerManager
                                  .controllers[index],
                              onLoaded: (composition) {
                                _updateLottieDuration(
                                    index, composition.duration.inMilliseconds);
                              },
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        SizedBox(height: contentWidth * 0.04),
                      ],
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

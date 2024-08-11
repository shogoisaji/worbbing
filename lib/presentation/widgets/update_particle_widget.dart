import 'dart:math';

import 'package:flutter/material.dart';
import 'package:worbbing/presentation/theme/theme.dart';

class UpdateParticleWidget extends StatefulWidget {
  final bool isGood;
  const UpdateParticleWidget({super.key, required this.isGood});

  @override
  State<UpdateParticleWidget> createState() => _UpdateParticleWidgetState();
}

class _UpdateParticleWidgetState extends State<UpdateParticleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> particles = [];

  final double _particleRadius = 0;
  late double _velocity;

  double w = 0;
  double h = 0;
  @override
  void initState() {
    super.initState();

    _velocity = widget.isGood ? 3.0 : -3.0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      w = MediaQuery.of(context).size.width;
      h = MediaQuery.of(context).size.height;

      _controller = AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: this,
      );
      _controller.addListener(() {
        if (_controller.value < 0.5) {
          for (var i = 0; i < 5; i++) {
            particles.add(Particle(
                holeRadius: _particleRadius,
                velocity: _velocity,
                positionX: Random().nextDouble() * w));
          }
        }
        for (var particle in particles) {
          particle.move();
        }

        /// particle opacityが0になったパーティクルを削除
        particles.removeWhere((particle) => particle.particleRadius <= 0);
        setState(() {});
      });

      // _ticker = createTicker((_) {
      //   if (particles.length < 150) {
      //     for (var i = 0; i < 5; i++) {
      //       particles.add(Particle(
      //           holeRadius: _particleRadius,
      //           velocity: _velocity,
      //           positionX: Random().nextDouble() * w));
      //     }
      //   }
      //   for (var particle in particles) {
      //     particle.move();
      //   }

      //   /// particle opacityが0になったパーティクルを削除
      //   particles.removeWhere((particle) => particle.particleRadius <= 0);
      //   setState(() {});
      // });
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant UpdateParticleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isGood != oldWidget.isGood) {
      _velocity = widget.isGood ? 4.0 : -4.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: w,
      height: h,
      child: CustomPaint(
        painter: ParticlePainter(
          isGood: widget.isGood,
          color: widget.isGood ? MyTheme.orange : MyTheme.blue,
          particles: particles,
          holeRadius: 20,
          holeScaleAnimationValue: 1,
        ),
      ),
    );
  }
}

class Particle {
  Particle({
    required this.holeRadius,
    required this.velocity,
    required this.positionX,
  });

  double holeRadius;
  final double velocity;
  final double positionX;

  double y = 0;
  int opacity = 170;
  double particleRadius = 2.5;

  void move() {
    y = y + velocity;
    particleRadius -= 0.06;
    opacity -= 2;
  }
}

class ParticlePainter extends CustomPainter {
  ParticlePainter(
      {required this.color,
      required this.particles,
      required this.holeRadius,
      required this.holeScaleAnimationValue,
      required this.isGood});
  final Color color;
  final List<Particle> particles;
  final double holeRadius;
  final double holeScaleAnimationValue;
  final bool isGood;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    for (var particle in particles) {
      var paint = Paint()
        ..color = color.withOpacity((particle.opacity / 255).clamp(0, 1))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
          Offset(particle.positionX,
              isGood ? particle.y : (size.height + particle.y)),
          particle.particleRadius * holeScaleAnimationValue * 3,
          paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

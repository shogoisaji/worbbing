import 'dart:math';

import 'package:flutter/material.dart';
import 'package:worbbing/presentation/theme/theme.dart';

class UpdateParticleWidget extends StatefulWidget {
  final bool isGood;
  final String text;
  const UpdateParticleWidget(
      {super.key, required this.isGood, required this.text});

  @override
  State<UpdateParticleWidget> createState() => _UpdateParticleWidgetState();
}

class _UpdateParticleWidgetState extends State<UpdateParticleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<String> _textCharacters;
  final List<Particle> particles = [];

  final double _particleRadius = 0;
  late double _velocity;

  double w = 0;
  double h = 0;

  @override
  void initState() {
    super.initState();

    _velocity = widget.isGood ? -5.0 : 3.0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      w = MediaQuery.of(context).size.width;
      h = MediaQuery.of(context).size.height;

      _controller = AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: this,
      );

      _textCharacters = widget.text.split('');

      _controller.addListener(() {
        if (_controller.value < 0.9) {
          for (var i = 0; i < 1; i++) {
            particles.add(Particle(
              holeRadius: _particleRadius,
              velocity: _velocity,
              angle: Random().nextDouble() - 0.5,
              positionX: Random().nextDouble() * w,
              text: _textCharacters[Random().nextInt(_textCharacters.length)],
            ));
          }
        }
        for (var particle in particles) {
          particle.move();
        }
        setState(() {});
      });

      _controller.forward().then((_) {
        particles.clear();
        _textCharacters.clear();
      });
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
      _velocity = widget.isGood ? -5.0 : 4.0;
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
    required this.angle,
    required this.text,
  });

  double holeRadius;
  final double velocity;
  final double positionX;
  final double angle;
  final String text;

  double y = 0;
  int opacity = 170;
  double sizeScale = 1.0;

  void move() {
    y = y + velocity;
    sizeScale -= 0.4;
    opacity -= 4;
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
    for (var particle in particles) {
      final textPainter = TextPainter(
        text: TextSpan(
            text: particle.text,
            style: TextStyle(
                fontSize: (40 + particle.sizeScale).clamp(0, 50),
                color:
                    color.withOpacity((particle.opacity / 255).clamp(0, 255)),
                fontWeight: FontWeight.bold)),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      canvas.save();
      final offset = Offset(particle.positionX,
          !isGood ? particle.y : (size.height + particle.y));
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(particle.angle);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 4),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

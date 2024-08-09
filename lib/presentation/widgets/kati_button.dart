import 'package:flutter/material.dart';

class KatiButton extends StatefulWidget {
  final double width;
  final double height;
  final double elevation;
  final double buttonRadius;
  final double stageOffset;
  final Widget child;
  final Widget? bgWidget;
  final Border? edgeBorder;
  final double inclinationRate;
  final double pushedElevationLevel;
  final Color stageColor;
  final Color? buttonColor;
  final Color? stagePointColor;
  final Color? edgeLineColor;
  final bool isStageShadow;
  final Duration duration;
  final VoidCallback onPressed;

  const KatiButton({
    super.key,
    required this.child,
    this.bgWidget,
    required this.onPressed,
    required this.width,
    required this.height,
    this.stageColor = Colors.grey,
    this.buttonColor,
    this.elevation = 10,
    this.inclinationRate = 0.7,
    this.pushedElevationLevel = 0.7,
    this.edgeBorder,
    this.buttonRadius = 10,
    this.duration = const Duration(milliseconds: 250),
    this.stageOffset = 10.0,
    this.isStageShadow = true,
    this.stagePointColor,
    this.edgeLineColor,
  }) : assert(pushedElevationLevel >= 0.0 && pushedElevationLevel <= 1.0);

  @override
  _KatiButtonState createState() => _KatiButtonState();
}

class _KatiButtonState extends State<KatiButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _currentElevation = 0;

  late Path _surfacePath;
  late Path _stagePath;
  late Path _sidePath;

  void _onTap() {
    if (_controller.isAnimating) return;
    Future.delayed(Duration(milliseconds: widget.duration.inMilliseconds ~/ 2),
        () {
      widget.onPressed();
    });

    _controller.forward().then((_) {
      _controller.reverse();
    });
  }

  void _updateElevation() {
    setState(() {
      _currentElevation =
          (1 - widget.pushedElevationLevel * _controller.value) *
              widget.elevation;
      _sidePath = PathUtil.createSidePath(widget.width - widget.stageOffset * 2,
          _currentElevation, widget.buttonRadius, widget.inclinationRate);
    });
  }

  void _createPaths() {
    _surfacePath = PathUtil.createPath(
        widget.width - widget.stageOffset * 2,
        widget.height - widget.elevation - widget.stageOffset,
        widget.buttonRadius,
        widget.inclinationRate);
    _sidePath = PathUtil.createSidePath(widget.width - widget.stageOffset * 2,
        _currentElevation, widget.buttonRadius, widget.inclinationRate);
    _stagePath = PathUtil.createPath(
        widget.width,
        widget.height - widget.elevation,
        widget.buttonRadius + widget.stageOffset,
        widget.inclinationRate);
  }

  @override
  void initState() {
    super.initState();
    _currentElevation = widget.elevation;
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _controller.addListener(() {
      _updateElevation();
    });

    _createPaths();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _onTap,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Stack(
            children: [
              widget.isStageShadow
                  ? _buildStageShadow()
                  : const SizedBox.shrink(),
              _buildStage(),
              _buildLightShadow(),
              _buildDarkShadow(),
              _buildButton(),
            ],
          ),
        ));
  }

  Widget _clippedSurfaceWidget(
      double width, double height, Widget child, Path path) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipPath(
        clipper: PathClipper(path: path),
        child: child,
      ),
    );
  }

  Widget _buildStage() {
    final Rect bounds = _stagePath.getBounds();
    final gradient = RadialGradient(
      center: const Alignment(0.0, 1.2),
      radius: bounds.width / 170,
      colors: [
        widget.stagePointColor ?? widget.stageColor,
        widget.stageColor,
      ],
    );
    final paint = Paint();
    paint.style = PaintingStyle.fill;
    paint.shader = gradient.createShader(bounds);
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: CustomPaint(
        painter: ButtonShapePainter(path: _stagePath, pathPaint: paint),
        size: PathUtil.getPathSize(_stagePath),
      ),
    );
  }

  Widget _buildStageShadow() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: CustomPaint(
        painter: ShadowPainter(
          path: _stagePath,
          shadowPaint: Paint()
            ..color = Colors.grey.shade900.withOpacity(0.3)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
        ),
        size: PathUtil.getPathSize(_stagePath),
      ),
    );
  }

  Widget _buildLightShadow() {
    return Positioned(
      bottom: widget.stageOffset,
      left: widget.stageOffset,
      right: widget.stageOffset,
      child: CustomPaint(
        painter: ShadowPainter(
          path: _surfacePath,
          shadowPaint: Paint()
            ..color = Colors.white.withOpacity(0.3)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
        ),
        size: PathUtil.getPathSize(_surfacePath),
      ),
    );
  }

  Widget _buildDarkShadow() {
    return Positioned(
      bottom: widget.stageOffset,
      left: widget.stageOffset,
      right: widget.stageOffset,
      child: CustomPaint(
        painter: ShadowPainter(
          path: _surfacePath,
          shadowPaint: Paint()
            ..color = Colors.grey.shade900.withOpacity(0.5)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
        ),
        size: PathUtil.getPathSize(_surfacePath),
      ),
    );
  }

  Widget _buildSideButton() {
    final Size size = PathUtil.getPathSize(_sidePath);
    return Positioned(
      bottom: widget.stageOffset,
      left: widget.stageOffset,
      right: widget.stageOffset,
      child: _clippedSurfaceWidget(
        size.width,
        size.height,
        Stack(
          fit: StackFit.expand,
          children: [
            SizedBox(
              width: size.width,
              height: size.height,
              child: widget.bgWidget ??
                  ColoredBox(color: widget.buttonColor ?? Colors.white),
            ),
            ColoredBox(
              color: Colors.black.withOpacity(0.2),
            )
          ],
        ),
        _sidePath,
      ),
    );
  }

  Widget _buildSurfaceButton() {
    final Size size = PathUtil.getPathSize(_surfacePath);
    return Positioned(
      bottom: widget.stageOffset + _currentElevation,
      left: widget.stageOffset,
      right: widget.stageOffset,
      child: Stack(
        children: [
          _clippedSurfaceWidget(
            size.width,
            size.height,
            SizedBox(
              width: size.width,
              height: size.height,
              child: widget.bgWidget ??
                  ColoredBox(color: widget.buttonColor ?? Colors.white),
            ),
            _surfacePath,
          ),
          SizedBox(
            width: size.width,
            height: size.height,
            child: widget.child,
          ),
          widget.edgeLineColor != null
              ? CustomPaint(
                  painter: ButtonShapePainter(
                    path: _surfacePath,
                    pathPaint: Paint()
                      ..color = widget.edgeLineColor!
                      ..strokeWidth = 0.7
                      ..style = PaintingStyle.stroke,
                  ),
                  size: PathUtil.getPathSize(_surfacePath),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            _buildSideButton(),
            _buildSurfaceButton(),
          ],
        );
      },
    );
  }
}

class PathClipper extends CustomClipper<Path> {
  final Path path;
  PathClipper({required this.path});
  @override
  Path getClip(Size size) => path;

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class ButtonShapePainter extends CustomPainter {
  final Path path;
  final Paint? pathPaint;
  ButtonShapePainter({required this.path, this.pathPaint});
  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, pathPaint ?? basePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ShadowPainter extends CustomPainter {
  final Path path;
  final Paint? shadowPaint;
  ShadowPainter({
    required this.path,
    this.shadowPaint,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final baseShadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawPath(
        path.shift(const Offset(0, 1)), shadowPaint ?? baseShadowPaint);
    canvas.drawPath(path, shadowPaint ?? baseShadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class PathUtil {
  static Path createPath(
      double width, double height, double radius, double inclinationRate) {
    final xRadius = radius;
    final yRadius = radius * inclinationRate;

    final path = Path();
    // 点の定義
    final p0 = Offset(0, yRadius);

    final p1 = Offset(0, yRadius / 2);
    final p2 = Offset(xRadius / 2, 0);
    final p3 = Offset(xRadius, 0);

    final p4 = Offset(width - xRadius, 0);

    final p5 = Offset(width - xRadius / 2, 0);
    final p6 = Offset(width, yRadius / 2);
    final p7 = Offset(width, yRadius);

    final p8 = Offset(width, height - yRadius);

    final p9 = Offset(width, height - yRadius / 2);
    final p10 = Offset(width - radius / 2, height);
    final p11 = Offset(width - radius, height);

    final p12 = Offset(xRadius, height);

    final p13 = Offset(xRadius / 2, height);
    final p14 = Offset(0, height - yRadius / 2);
    final p15 = Offset(0, height - yRadius);

    // パスの定義
    path.moveTo(p0.dx, p0.dy);
    path.cubicTo(p1.dx, p1.dy, p2.dx, p2.dy, p3.dx, p3.dy);

    path.lineTo(p4.dx, p4.dy);
    path.cubicTo(p5.dx, p5.dy, p6.dx, p6.dy, p7.dx, p7.dy);

    path.lineTo(p8.dx, p8.dy);
    path.cubicTo(p9.dx, p9.dy, p10.dx, p10.dy, p11.dx, p11.dy);

    path.lineTo(p12.dx, p12.dy);
    path.cubicTo(p13.dx, p13.dy, p14.dx, p14.dy, p15.dx, p15.dy);
    path.close();

    return path;
  }

  static Path createSidePath(
      double width, double elevation, double radius, double inclinationRate) {
    final xRadius = radius;
    final yRadius = radius * inclinationRate;

    final path = Path();
    // 点の定義
    const p0 = Offset(0, 0);

    final p1 = Offset(0, yRadius / 2);
    final p2 = Offset(xRadius / 2, yRadius);
    final p3 = Offset(xRadius, yRadius);

    final p4 = Offset(width - xRadius, yRadius);

    final p5 = Offset(width - xRadius / 2, yRadius);
    final p6 = Offset(width, yRadius / 2);
    final p7 = Offset(width, 0);

    final p8 = Offset(width, elevation);

    final p9 = Offset(width, elevation + yRadius / 2);
    final p10 = Offset(width - radius / 2, elevation + yRadius);
    final p11 = Offset(width - radius, elevation + yRadius);

    final p12 = Offset(xRadius, elevation + yRadius);

    final p13 = Offset(xRadius / 2, elevation + yRadius);
    final p14 = Offset(0, elevation + yRadius / 2);
    final p15 = Offset(0, elevation);

    // パスの定義
    path.moveTo(p0.dx, p0.dy);
    path.cubicTo(p1.dx, p1.dy, p2.dx, p2.dy, p3.dx, p3.dy);

    path.lineTo(p4.dx, p4.dy);
    path.cubicTo(p5.dx, p5.dy, p6.dx, p6.dy, p7.dx, p7.dy);

    path.lineTo(p8.dx, p8.dy);
    path.cubicTo(p9.dx, p9.dy, p10.dx, p10.dy, p11.dx, p11.dy);

    path.lineTo(p12.dx, p12.dy);
    path.cubicTo(p13.dx, p13.dy, p14.dx, p14.dy, p15.dx, p15.dy);
    path.close();

    return path;
  }

  static Size getPathSize(Path path) {
    final rect = path.getBounds();
    return Size(rect.width, rect.height);
  }
}

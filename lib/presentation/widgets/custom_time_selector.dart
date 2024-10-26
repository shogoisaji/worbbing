import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:worbbing/presentation/theme/theme.dart';

class VerticalTimeSelector {
  int _hour = 0;
  int _minute = 0;
  int _prevHour = 0;
  int _prevMinute = 0;

  Future<(int, int)?> show(
      BuildContext context, int initialHour, int initialMinute) async {
    _hour = initialHour;
    _minute = initialMinute;
    final result = await showDialog<(int, int)>(
        context: context,
        builder: (context) {
          final width = MediaQuery.of(context).size.width;

          final double contentHeight = (width * 0.7).clamp(100, 400);
          return StatefulBuilder(builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: MyTheme.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 330),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Time Select',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 75),
                          Text('Hour',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 18)),
                          const SizedBox(width: 85),
                          Text('Minute',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 18)),
                        ],
                      ),
                      SizedBox(
                        height: contentHeight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onPanUpdate: (details) {
                                  final dy = details.localPosition.dy;
                                  final int v = 24 * dy ~/ contentHeight;
                                  setDialogState(() {
                                    if (v != _prevHour) {
                                      _hour = v.clamp(0, 23);
                                      _prevHour = _hour;
                                      HapticFeedback.lightImpact();
                                    }
                                  });
                                },
                                child: CustomPaint(
                                  size: const Size(120, double.infinity),
                                  painter: TimeIndicatorPainter(
                                    value: _hour,
                                    numberOfDivision: 24,
                                    textSize: 32,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // const SizedBox(width: 1),
                              GestureDetector(
                                onPanUpdate: (details) {
                                  final dy = details.localPosition.dy;
                                  final int v = 60 * dy ~/ contentHeight;
                                  setDialogState(() {
                                    if (v != _prevMinute) {
                                      _minute = v.clamp(0, 59);
                                      _prevMinute = _minute;
                                      HapticFeedback.lightImpact();
                                    }
                                  });
                                },
                                child: CustomPaint(
                                  size: const Size(120, double.infinity),
                                  painter: TimeIndicatorPainter(
                                    value: _minute,
                                    numberOfDivision: 60,
                                    textSize: 32,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel',
                                style: TextStyle(
                                    color: MyTheme.lemon, fontSize: 24)),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MyTheme.lemon,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop((_hour, _minute));
                              },
                              child: Text('OK',
                                  style: TextStyle(
                                      color: Colors.grey.shade900,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
    if (result != null) {
      _hour = result.$1;
      _minute = result.$2;
      return result;
    }
    return null;
  }
}

class TimeIndicatorPainter extends CustomPainter {
  final int value;
  final int numberOfDivision;
  final double paddingValue;
  final double textSize;
  final Color color;
  const TimeIndicatorPainter(
      {required this.value,
      required this.numberOfDivision,
      required this.color,
      this.paddingValue = 20.0,
      this.textSize = 32.0});

  double _calcHeight(int index, Size size) {
    return index * (size.height - paddingValue * 2) / numberOfDivision +
        paddingValue;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double normalLength = size.width / 4;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0;
    final accentPaint = Paint()
      ..color = MyTheme.lemon
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    for (var i = 0; i < numberOfDivision; i++) {
      final path = Path();
      path.moveTo(size.width - 20, _calcHeight(i, size));
      final length = switch (i) {
        _ when i == value => -normalLength * 1.8,
        _ when (i - value).abs() == 1 => -normalLength * 1.4,
        _ when (i - value).abs() == 2 => -normalLength * 1.2,
        _ => -normalLength,
      };
      path.relativeLineTo(length, 0);
      canvas.drawPath(
          path, i % (numberOfDivision ~/ 4) == 0 ? accentPaint : paint);
    }

    final textPainter = TextPainter(
      text: TextSpan(
        text: value.toString().padLeft(2, '0'),
        style: TextStyle(fontSize: textSize, color: color),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: size.width);
    textPainter.paint(
        canvas, Offset(5, _calcHeight(value, size) - textPainter.height / 2));

    for (var i = 0; i < 4 + 1; i++) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: (numberOfDivision ~/ 4 * i).toString().padLeft(2, '0'),
          style: TextStyle(fontSize: 12, color: color.withOpacity(0.5)),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(
              size.width - textPainter.width - 2,
              _calcHeight(numberOfDivision ~/ 4 * i, size) -
                  textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

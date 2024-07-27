import 'package:flutter/material.dart';
import 'package:worbbing/presentation/theme/theme.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController textController;
  final AnimationController? animationController;
  final Color color;
  final FocusNode? focusNode;
  final bool isOriginalInput;
  final int lines;
  final bool isEnglish;
  final VoidCallback? onChange;

  const CustomTextField({
    Key? key,
    required this.textController,
    required this.color,
    this.focusNode,
    this.isOriginalInput = false,
    this.lines = 1,
    required this.isEnglish,
    this.animationController,
    this.onChange,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      return Stack(
        children: [
          widget.animationController != null
              ? AnimatedBuilder(
                  animation: widget.animationController!,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: const Offset(7.0, 4.5),
                      child: Transform.rotate(
                          alignment: Alignment.center,
                          angle:
                              0.011 - widget.animationController!.value * 0.03,
                          child: Container(
                            width: width - 10,
                            height: 70.0 * widget.lines,
                            decoration: BoxDecoration(
                              color: widget.textController.text.isEmpty
                                  ? MyTheme.grey
                                  : widget.color,
                              borderRadius: BorderRadius.circular(2),
                              border:
                                  Border.all(color: widget.color, width: 1.5),
                            ),
                          )),
                    );
                  })
              : Transform.translate(
                  offset: const Offset(7.0, 4.5),
                  child: Transform.rotate(
                      alignment: Alignment.topLeft,
                      angle: 0.011,
                      child: Container(
                        width: width - 10,
                        height: 70.0 * widget.lines,
                        decoration: BoxDecoration(
                          color: widget.textController.text.isEmpty
                              ? MyTheme.grey
                              : widget.color,
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(color: widget.color, width: 1.5),
                        ),
                      )),
                ),
          GradientBorderContainer(
            width: width - 10,
            height: 70.0 * widget.lines,
            bgColor: MyTheme.grey,
            borderColor: widget.color,
            child: TextField(
                focusNode: widget.focusNode,
                onChanged: (_) {
                  widget.onChange?.call();
                },
                cursorColor: Colors.grey.shade100,
                maxLength: widget.isOriginalInput ? 20 : null,
                maxLines: widget.lines,
                keyboardType: widget.isEnglish
                    ? TextInputType.visiblePassword
                    : TextInputType.text,
                decoration: InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.only(
                        top: widget.isOriginalInput ? 8 : 14,
                        left: 8,
                        right: 8),
                    border: InputBorder.none),
                textAlign: TextAlign.center,
                controller: widget.textController,
                style: TextStyle(
                  fontSize: widget.isOriginalInput ? 30 : 24,
                  color: Colors.grey.shade100,
                  fontFamily: 'SawarabiGothic',
                )),
          )
        ],
      );
    });
  }
}

class GradientBorderContainer extends StatelessWidget {
  final Widget child;
  final Color bgColor;
  final Color borderColor;
  final double borderWidth;
  final double width;
  final double height;
  final double borderRadius;

  const GradientBorderContainer(
      {Key? key,
      required this.child,
      required this.borderColor,
      required this.width,
      required this.height,
      this.borderWidth = 1.5,
      this.borderRadius = 2.0,
      required this.bgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(
            color: borderColor,
          ),
          Container(
            padding: EdgeInsets.all(borderWidth),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: RadialGradient(
                colors: [Colors.white.withOpacity(0.8), Colors.transparent],
                center: const Alignment(0.0, -0.5),
                radius: width / 200,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(borderRadius - borderWidth),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

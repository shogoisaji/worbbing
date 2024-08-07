import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:worbbing/presentation/theme/theme.dart';

class TwoWayDialog {
  static Future<void> show(
      BuildContext context, String title, Widget? icon, Widget? content,
      {required String leftButtonText,
      required String rightButtonText,
      required Function onLeftButtonPressed,
      required Function onRightButtonPressed,
      Color? titleColor,
      Color? leftBgColor,
      Color? leftTextColor}) async {
    showDialog(
        context: context,
        builder: (context) => Align(
              alignment: const Alignment(0.0, 1.0),
              child: TwoWayDialogWidget(
                  title: title,
                  titleColor: titleColor,
                  icon: icon,
                  content: content,
                  leftButtonText: leftButtonText,
                  rightButtonText: rightButtonText,
                  onLeftButtonPressed: onLeftButtonPressed,
                  onRightButtonPressed: onRightButtonPressed,
                  leftBgColor: leftBgColor,
                  leftTextColor: leftTextColor),
            ));
  }
}

class TwoWayDialogWidget extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final Widget? icon;
  final Widget? content;
  final String leftButtonText;
  final String rightButtonText;
  final Function onLeftButtonPressed;
  final Function onRightButtonPressed;
  final Color? leftBgColor;
  final Color? leftTextColor;
  const TwoWayDialogWidget({
    super.key,
    required this.title,
    this.titleColor,
    this.icon,
    this.content,
    required this.leftButtonText,
    required this.rightButtonText,
    required this.onLeftButtonPressed,
    required this.onRightButtonPressed,
    this.leftBgColor,
    this.leftTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Container(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          constraints: const BoxConstraints(
            maxWidth: 400,
          ),
          decoration: BoxDecoration(
            color: MyTheme.dialogGrey,
            gradient: LinearGradient(
              colors: [MyTheme.grey, MyTheme.dialogGrey],
              begin: const Alignment(-0.5, -1.5),
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 5),
                blurRadius: 5,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              icon != null
                  ? Column(
                      children: [
                        icon!,
                      ],
                    )
                  : const SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: titleColor ?? MyTheme.lemon,
                      fontWeight: FontWeight.w700,
                      shadows: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.7),
                          offset: const Offset(0.5, 1),
                          spreadRadius: 2,
                        ),
                      ],
                    )),
              ),
              content != null ? content! : const SizedBox.shrink(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).pop();
                      onLeftButtonPressed();
                    },
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                          child: AutoSizeText(leftButtonText,
                              style: TextStyle(
                                  color: Colors.grey.shade800, fontSize: 22))),
                    ),
                  )),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.of(context).pop();
                        onRightButtonPressed();
                      },
                      child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: leftBgColor ?? MyTheme.lemon,
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0, 2),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                              child: AutoSizeText(rightButtonText,
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: leftTextColor ?? MyTheme.grey,
                                  )))),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:worbbing/presentation/theme/theme.dart';

class MySimpleDialog {
  static show(
    BuildContext context,
    Widget child,
    String buttonLabel,
    Function onTap, {
    Color? buttonColor,
    Color? backgroundColor,
  }) {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3)),
              backgroundColor: backgroundColor ?? MyTheme.grey,
              content: child,
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(
                        left: 12, right: 12, bottom: 4, top: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    backgroundColor: backgroundColor ?? MyTheme.lemon,
                  ),
                  onPressed: () async {
                    HapticFeedback.lightImpact();
                    onTap();
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(buttonLabel,
                      style: TextStyle(
                          color: MyTheme.grey,
                          fontSize: 24,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ));
  }
}

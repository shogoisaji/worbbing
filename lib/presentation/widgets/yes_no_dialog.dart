import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:worbbing/presentation/theme/theme.dart';

class YesNoDialog {
  static show({
    required BuildContext context,
    required String title,
    required String noText,
    required String yesText,
    required Function() onNoPressed,
    required Function() onYesPressed,
  }) {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              backgroundColor: MyTheme.grey,
              title: Text(
                title,
                style: const TextStyle(
                    overflow: TextOverflow.clip,
                    color: Colors.white,
                    fontSize: 20),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(dialogContext).pop();
                  },
                  child:
                      Text(noText, style: const TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(
                        left: 12, right: 12, bottom: 4, top: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    backgroundColor: MyTheme.red,
                  ),
                  onPressed: () async {
                    HapticFeedback.lightImpact();
                    onYesPressed();
                    if (!context.mounted) return;
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(yesText,
                      style: const TextStyle(color: Colors.white)),
                ),
              ],
            ));
  }
}

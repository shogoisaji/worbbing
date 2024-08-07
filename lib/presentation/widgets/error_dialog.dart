import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:worbbing/presentation/theme/theme.dart';

class ErrorDialog {
  static show({
    required BuildContext context,
    required String text,
  }) {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3)),
              backgroundColor: MyTheme.grey,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.sentiment_very_dissatisfied_rounded,
                      size: 36),
                  const SizedBox(height: 12),
                  Text(text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      )),
                ],
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(
                        left: 12, right: 12, bottom: 4, top: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    backgroundColor: MyTheme.lemon,
                  ),
                  onPressed: () async {
                    HapticFeedback.lightImpact();
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text("OK",
                      style: TextStyle(
                          color: MyTheme.grey,
                          fontSize: 24,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ));
  }
}

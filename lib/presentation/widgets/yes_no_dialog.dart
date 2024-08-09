import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:worbbing/presentation/theme/theme.dart';

enum YesNoDialogType { caution, warning }

class YesNoDialog {
  static show({
    required BuildContext context,
    required String title,
    required String noText,
    required String yesText,
    required Function() onNoPressed,
    required Function() onYesPressed,
    YesNoDialogType type = YesNoDialogType.warning,
  }) {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
              actionsPadding: const EdgeInsets.only(bottom: 12, right: 16),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(3))),
              backgroundColor: MyTheme.grey,
              title: Text(
                title,
                style: const TextStyle(
                    overflow: TextOverflow.clip,
                    color: Colors.white,
                    fontSize: 22),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(noText,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 22)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(
                        left: 12, right: 12, bottom: 4, top: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    backgroundColor: switch (type) {
                      YesNoDialogType.caution => MyTheme.lemon,
                      YesNoDialogType.warning => MyTheme.red,
                    },
                  ),
                  onPressed: () async {
                    HapticFeedback.lightImpact();
                    onYesPressed();
                    if (!context.mounted) return;
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(yesText,
                      style: switch (type) {
                        YesNoDialogType.caution => TextStyle(
                            color: MyTheme.grey,
                            fontSize: 24,
                          ),
                        YesNoDialogType.warning => const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                      }),
                )
              ],
            ));
  }
}

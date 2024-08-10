import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';
import 'package:worbbing/domain/entities/translated_api_response.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';

class TranslateSuggestDialog {
  static Future<void> execute(BuildContext context, String input,
      TranslatedApiResponse response, Function() onRightButtonPressed) async {
    showDialog(
        context: context,
        builder: (context) => Align(
              alignment: const Alignment(0.0, 1.0),
              child: TwoWayDialogWidget(
                input: input,
                response: response,
                onRightButtonPressed: onRightButtonPressed,
              ),
            ));
  }
}

class TwoWayDialogWidget extends StatelessWidget {
  final String input;
  final TranslatedApiResponse response;
  final Function() onRightButtonPressed;
  const TwoWayDialogWidget(
      {super.key,
      required this.input,
      required this.response,
      required this.onRightButtonPressed});

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
              RiveAnimatedIcon(
                riveIcon: RiveIcon.graduate,
                width: 70,
                height: 70,
                color: Colors.white,
                loopAnimation: true,
                onTap: () {},
                onHover: (value) {},
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text('Maybe...this word?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: MyTheme.lemon,
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
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 1, left: 4),
                    child: bodyText('Input Original', Colors.grey.shade400),
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        input,
                        style: TextStyle(
                            fontSize: 30, color: Colors.grey.shade400),
                        minFontSize: 16,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 1, left: 4),
                    child: bodyText('Suggest Original', Colors.white),
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        response.original,
                        style:
                            const TextStyle(fontSize: 30, color: Colors.black),
                        minFontSize: 16,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  response.comment != null
                      ? Padding(
                          padding: const EdgeInsets.only(
                              top: 2.0, left: 4, right: 4),
                          child: Text(response.comment!,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.6))),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 1, left: 4),
                    child: bodyText('Translated', Colors.white),
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        response.translated[0],
                        style:
                            const TextStyle(fontSize: 30, color: Colors.black),
                        minFontSize: 16,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).pop();
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
                          child: AutoSizeText("No",
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ))),
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
                            color: MyTheme.lemon,
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
                              child: AutoSizeText("Yes",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: MyTheme.grey,
                                    fontWeight: FontWeight.bold,
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

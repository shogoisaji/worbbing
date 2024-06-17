import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worbbing/application/usecase/notice_usecase.dart';
import 'package:worbbing/application/usecase/ticket_manager.dart';
import 'package:worbbing/models/translate_language.dart';
import 'package:worbbing/models/word_model.dart';
import 'package:worbbing/presentation/widgets/my_simple_dialog.dart';
import 'package:worbbing/presentation/widgets/registration_bottom_sheet.dart';
import 'package:worbbing/presentation/widgets/ticket_widget.dart';
import 'package:worbbing/repository/sqflite_repository.dart';
import 'package:worbbing/pages/settings_page.dart';
import 'package:worbbing/pages/notice_page.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/list_tile.dart';
import 'package:worbbing/presentation/widgets/tag_select.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AppLifecycleListener _listener;
  final List<String> _states = <String>[];
  late AppLifecycleState? _state;

  int tagState = 0;

  Future<List<WordModel>> dataFuture =
      SqfliteRepository.instance.queryAllRowsNoticeDuration();

  @override
  void initState() {
    super.initState();
    _state = SchedulerBinding.instance.lifecycleState;
    _listener = AppLifecycleListener(
      onStateChange: _handleStateChange,
    );
    if (_state != null) {
      _states.add(_state!.name);
    }
  }

  void _handleStateChange(AppLifecycleState state) {
    if (_state == AppLifecycleState.inactive &&
        state == AppLifecycleState.resumed) {
      NoticeUsecase().shuffleNotification();
    }
    setState(() {
      _state = state;
    });
  }

  Future<List<TranslateLanguage>> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final loadedOriginalString = prefs.getString("original_lang") ?? "english";
    final loadedTranslateString =
        prefs.getString("translate_lang") ?? "japanese";
    final original = TranslateLanguage.values
        .firstWhere((e) => e.lowerString == loadedOriginalString);
    final translate = TranslateLanguage.values
        .firstWhere((e) => e.lowerString == loadedTranslateString);
    return [original, translate];
  }

  Future<int> loadTicket() async {
    final ticket = await TicketManager.loadTicket();
    return ticket;
  }

  void handleTapFAB(BuildContext context) async {
    final langs = await loadPreferences();
    if (!mounted) return;
    await showModalBottomSheet(
        constraints: const BoxConstraints(maxWidth: 400),
        backgroundColor: Colors.transparent,
        enableDrag: false,
        isDismissible: false,
        isScrollControlled: true,
        context: context,
        builder: (context) => RegistrationBottomSheet(
              initialOriginalLang: langs[0],
              initialTranslateLang: langs[1],
            ));
    handleReload();
  }

  void handleTapTicket() async {
    MySimpleDialog.show(
        context,
        const Text(
          'Translation Tickets\n"10" per day',
          style: TextStyle(
              overflow: TextOverflow.clip, color: Colors.white, fontSize: 24),
        ),
        'OK',
        () {});
  }

  Future<void> handleReload() async {
    //durationが短すぎるとエラーになる
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      switch (tagState) {
        case 0:
          dataFuture = SqfliteRepository.instance.queryAllRowsNoticeDuration();
        case 1:
          dataFuture = SqfliteRepository.instance.queryAllRowsRegistration();
        case 2:
          dataFuture = SqfliteRepository.instance.queryAllRowsFlag();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyTheme.grey,
          elevation: 0,
          centerTitle: true,
          title: Image.asset(
            'assets/images/worbbing_logo.png',
            width: 150,
          ),
          leadingWidth: 40,
          leading: IconButton(
              padding: const EdgeInsets.only(top: 5, left: 10),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const NoticePage()),
                );
              },
              icon: const Icon(
                Icons.notifications_rounded,
                color: Colors.white,
                size: 30,
              )),
          actions: [
            FutureBuilder<int>(
                future: loadTicket(),
                builder: (context, snapshot) {
                  return GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        handleTapTicket();
                      },
                      child: TicketWidget(count: snapshot.data ?? 0, size: 50));
                }),
            const SizedBox(
              width: 4,
            ),
            IconButton(
                padding: const EdgeInsets.only(top: 5, right: 10),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()),
                  );
                },
                icon: const Icon(
                  Icons.settings_rounded,
                  color: Colors.white,
                  size: 30,
                )),
          ],
        ),

        /// floating Action Button
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 5, right: 10.0),
            child: _customFloatingActionButton()),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: MyTheme.grey,
                  border: const Border(
                      bottom: BorderSide(color: Colors.white, width: 3))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  /// tag
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      tagSelect('Notice', tagState, 0, () {
                        setState(() {
                          tagState = 0;
                        });
                        handleReload();
                      }),
                      tagSelect('Registration', tagState, 1, () {
                        setState(() {
                          tagState = 1;
                        });
                        handleReload();
                      }),
                      tagSelect('Flag', tagState, 2, () {
                        setState(() {
                          tagState = 2;
                        });
                        handleReload();
                      }),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
// list
            Expanded(
              child: FutureBuilder<List<WordModel>>(
                future: dataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: SizedBox.shrink());
                  }
                  if (snapshot.hasError) {
                    return const Text('error');
                  }
                  final wordList = snapshot.data!;
                  final DateTime currentDateTime = DateTime.now();
                  int noticeDurationTime;
                  int forgettingDuration;
                  DateTime updateDateTime;

                  // change list expired top of list
                  if (tagState == 0) {
                    for (var i = 0; i < wordList.length; i++) {
                      noticeDurationTime = wordList[i].noticeDuration;
                      updateDateTime = wordList[i].updateDate;
                      forgettingDuration =
                          currentDateTime.difference(updateDateTime).inDays;
                      if (forgettingDuration >= noticeDurationTime &&
                          noticeDurationTime != 99) {
                        // insert top of array
                        var insertData = wordList.removeAt(i);
                        wordList.insert(0, insertData);
                      }
                    }
                  }
                  return ListView.separated(
                    separatorBuilder: (context, index) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            MyTheme.lemon,
                            MyTheme.grey,
                            MyTheme.grey,
                            MyTheme.orange,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      height: 1,
                    ),
                    padding: EdgeInsets.zero,
                    itemCount: wordList.length,
                    itemBuilder: (context, index) {
                      final item = wordList[index];
                      return Column(
                        children: [
                          WordListTile(
                            onDragEnd: handleReload,
                            wordModel: item,
                          ),
                          // under space
                          if (index == wordList.length - 1)
                            Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        MyTheme.lemon,
                                        MyTheme.grey,
                                        MyTheme.grey,
                                        MyTheme.orange,
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 200,
                                ),
                              ],
                            )
                        ],
                      );
                    },
                  );
                },
              ),
            )
          ],
        ));
  }

  Widget _customFloatingActionButton() {
    const buttonAngle = 1.2;
    return Stack(
      children: [
        Transform.rotate(
          angle: 1.5,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.zero,
              color: Colors.grey.shade600,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 15.0,
                  spreadRadius: 5.0,
                ),
              ],
            ),
          ),
        ),
        Transform.rotate(
          angle: buttonAngle,
          child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.zero,
                color: MyTheme.orange,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 15.0,
                    spreadRadius: 5.0,
                  ),
                ],
              ),
              child: FloatingActionButton(
                  elevation: 0,
                  backgroundColor: MyTheme.orange,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    handleTapFAB(context);
                  },
                  child: Transform.rotate(
                    angle: -buttonAngle,
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.black,
                      size: 42,
                    ),
                  ))),
        ),
      ],
    );
  }
}

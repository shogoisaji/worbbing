import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worbbing/application/usecase/notice_usecase.dart';
import 'package:worbbing/application/usecase/ticket_manager.dart';
import 'package:worbbing/models/translate_language.dart';
import 'package:worbbing/models/word_model.dart';
import 'package:worbbing/presentation/widgets/ad_reward.dart';
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
  late AnimationController _animationController;
  late Animation _animation;
  late final AppLifecycleListener _listener;
  final List<String> _states = <String>[];
  late AppLifecycleState? _state;

  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  int _tagState = 0;

  Future<List<WordModel>> dataFuture =
      SqfliteRepository.instance.queryAllRowsNoticeDuration();

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

  Future<void> loadTicket() async {
    await TicketManager.loadTicket();
  }

  void handleTapFAB(BuildContext context) async {
    final langs = await loadPreferences();
    if (!mounted) return;
    await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        enableDrag: false,
        isDismissible: false,
        isScrollControlled: true,
        context: context,
        builder: (context) => RegistrationBottomSheet(
              initialOriginalLang: langs[0],
              initialTranslateLang: langs[1],
            ));
    setState(() {});
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

  Future<List<WordModel>> handleReload() async {
    _isLoading.value = true;
    final model = switch (_tagState) {
      0 => await SqfliteRepository.instance.queryAllRowsNoticeDuration(),
      1 => await SqfliteRepository.instance.queryAllRowsRegistration(),
      2 => await SqfliteRepository.instance.queryAllRowsFlag(),
      _ => await SqfliteRepository.instance.queryAllRowsNoticeDuration(),
    };
    _isLoading.value = false;
    return model;
  }

  @override
  void initState() {
    super.initState();
    TicketManager.loadTicket();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _state = SchedulerBinding.instance.lifecycleState;
    _listener = AppLifecycleListener(
      onStateChange: _handleStateChange,
    );
    if (_state != null) {
      _states.add(_state!.name);
    }
    _isLoading.addListener(() {
      if (!_isLoading.value) {
        _animationController.value = 0.0;
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _listener.dispose();
    _animationController.dispose();
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
          // leadingWidth: 40,
          leading: IconButton(
              padding: const EdgeInsets.only(top: 5, left: 4, right: 4),
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
            AdReward(
              child: ValueListenableBuilder<int>(
                valueListenable: TicketManager.ticketNotifier,
                builder: (context, value, child) {
                  return TicketWidget(
                    count: value,
                    size: 50,
                    isEnableUseAnimation: true,
                  );
                },
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            IconButton(
                padding: const EdgeInsets.only(top: 5, right: 8),
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
                      tagSelect('Notice', _tagState, 0, () {
                        setState(() {
                          _tagState = 0;
                        });
                        // handleReload();
                      }),
                      tagSelect('LatestAdd', _tagState, 1, () {
                        setState(() {
                          _tagState = 1;
                        });
                        // handleReload();
                      }),
                      tagSelect('Flag', _tagState, 2, () {
                        setState(() {
                          _tagState = 2;
                        });
                        // handleReload();
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
                future: handleReload(),
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
                  if (_tagState == 0) {
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
                  return AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: (_animation.value),
                          child: ListView.separated(
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
                                    onWordUpdate: () => setState(() {}),
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
                          ),
                        );
                      });
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
              borderRadius: BorderRadius.circular(2),
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
                borderRadius: BorderRadius.circular(2),
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

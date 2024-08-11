import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:worbbing/core/constants/ticket_constants.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_repository.dart';
import 'package:worbbing/data/repositories/sqflite/notification_repository_impl.dart';
import 'package:worbbing/data/repositories/sqflite/word_list_repository_impl.dart';
import 'package:worbbing/domain/entities/word_model.dart';
import 'package:worbbing/domain/usecases/notice/shuffle_notification_usecase.dart';
import 'package:worbbing/domain/usecases/word/down_duration_usecase.dart';
import 'package:worbbing/domain/usecases/word/up_duration_usecase.dart';
import 'package:worbbing/l10n/l10n.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/view_model/home_page_view_model.dart';
import 'package:worbbing/presentation/view_model/setting_page_view_model.dart';
import 'package:worbbing/presentation/widgets/ad_reward.dart';
import 'package:worbbing/presentation/widgets/list_tile.dart';
import 'package:worbbing/presentation/widgets/tag_select.dart';
import 'package:worbbing/presentation/widgets/ticket_widget.dart';
import 'package:worbbing/presentation/widgets/update_particle_widget.dart';
import 'package:worbbing/providers/share_text_provider.dart';
import 'package:worbbing/providers/ticket_state.dart';
import 'package:worbbing/routes/router.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(homePageViewModelProvider);
    final viewModelNotifier = ref.read(homePageViewModelProvider.notifier);
    final ticketCount = ref.watch(ticketStateProvider);
    final sharedText = ref.watch(shareTextProvider);
    final isEnableSlideHint =
        ref.watch(settingPageViewModelProvider).enableSlideHint;

    final l10n = L10n.of(context)!;

    final appLifecycleState = useAppLifecycleState();

    final refresh = useState(false);
    final isGood = useState<bool?>(null);

    void handleUpDuration(WordModel wordModel) async {
      await UpDurationUsecase(ref.read(wordListRepositoryProvider))
          .execute(wordModel);
      viewModelNotifier.getWordList();
      isGood.value = true;
      Future.delayed(const Duration(milliseconds: 1000), () {
        isGood.value = null;
      });
    }

    void handleDownDuration(WordModel wordModel) async {
      await DownDurationUsecase(ref.read(wordListRepositoryProvider))
          .execute(wordModel);
      viewModelNotifier.getWordList();
      isGood.value = false;
      Future.delayed(const Duration(milliseconds: 1000), () {
        isGood.value = null;
      });
    }

    final handleEarnTicket = useCallback(() {
      ref
          .read(ticketStateProvider.notifier)
          .earnTicket(TicketConstants.rewardEarnTicket);
    }, [ref]);

    final handleUpdateWord = useCallback(() {
      viewModelNotifier.getWordList();
    }, [ref]);

    final handleTapTag = useCallback((int index) {
      viewModelNotifier.tagSelect(index);
      viewModelNotifier.getWordList();
    }, [ref]);

    final handleTapList = useCallback((WordModel word) async {
      await context.push(PagePath.detail, extra: word);
      viewModelNotifier.getWordList();
    }, [ref]);

    handleTapFAB() async {
      await viewModelNotifier.showRegistrationBottomSheet(context);
      // viewModelNotifier.getWordList();
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(homePageViewModelProvider.notifier).getWordList();
      });
      return null;
    }, []);

    useEffect(() {
      if (sharedText != "") {
        SchedulerBinding.instance.addPostFrameCallback((_) => ref
            .read(homePageViewModelProvider.notifier)
            .getTextAction(context, sharedText: sharedText));
      }
      return null;
    }, [sharedText]);

    useEffect(() {
      if (appLifecycleState == AppLifecycleState.resumed) {
        ShuffleNotificationUsecase(
          ref.read(wordListRepositoryProvider),
          ref.read(notificationRepositoryProvider),
          ref.read(sharedPreferencesRepositoryProvider),
        ).execute();
      }
      return () {};
    }, [appLifecycleState]);

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: MyTheme.bgGradient,
          ),
        ),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: MyTheme.appBarGrey,
              elevation: 0,
              centerTitle: true,
              title: Image.asset(
                'assets/images/worbbing_logo.png',
                width: 150,
              ),
              leading: IconButton(
                  padding: const EdgeInsets.only(top: 5, left: 4, right: 4),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    context.push(PagePath.notice);
                  },
                  icon: const Icon(
                    Icons.notifications_rounded,
                    color: Colors.white,
                    size: 30,
                  )),
              actions: [
                AdReward(
                  onEarnTicket: handleEarnTicket,
                  child: TicketWidget(
                    count: ticketCount,
                    size: 50,
                    isEnabledUseAnimation: true,
                    bgColor: MyTheme.appBarGrey,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                IconButton(
                    padding: const EdgeInsets.only(top: 5, right: 8),
                    onPressed: () async {
                      HapticFeedback.lightImpact();
                      await context.push(PagePath.settings);
                      refresh.value = !refresh.value;
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
                child: _customFloatingActionButton(handleTapFAB)),
            body: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: MyTheme.appBarGrey,
                      border: const Border(
                          bottom: BorderSide(color: Colors.white, width: 3))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      /// tag
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          tagSelect(l10n.notice, viewModel.tagState, 0, () {
                            handleTapTag(0);
                          }),
                          tagSelect(l10n.latest_add, viewModel.tagState, 1, () {
                            handleTapTag(1);
                          }),
                          tagSelect(l10n.flag, viewModel.tagState, 2, () {
                            handleTapTag(2);
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
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ListView.separated(
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
                        itemCount: viewModel.wordList.length,
                        itemBuilder: (context, index) {
                          final item = viewModel.wordList[index];
                          return Column(
                            children: [
                              WordListTile(
                                wordModel: item,
                                onWordUpdate: () {
                                  handleUpdateWord();
                                },
                                onTapList: () async {
                                  handleTapList(item);
                                },
                                isEnabledSlideHint: isEnableSlideHint,
                                onUpDuration: () => handleUpDuration(item),
                                onDownDuration: () => handleDownDuration(item),
                              ),
                              // under space
                              if (index == viewModel.wordList.length - 1)
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
                                      height: 170,
                                    ),
                                  ],
                                )
                            ],
                          );
                        },
                      ),
                      isGood.value != null
                          ? IgnorePointer(
                              child:
                                  UpdateParticleWidget(isGood: isGood.value!))
                          : const SizedBox.shrink(),
                    ],
                  ),
                )
              ],
            ))
      ],
    );
  }

  Widget _customFloatingActionButton(VoidCallback handleTapFAB) {
    const buttonAngle = 1.22;
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
                  color: MyTheme.darkGrey.withOpacity(0.6),
                  blurRadius: 20.0,
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
                    color: MyTheme.darkGrey.withOpacity(0.6),
                    blurRadius: 20.0,
                    spreadRadius: 5.0,
                  ),
                ],
              ),
              child: FloatingActionButton(
                  elevation: 0,
                  backgroundColor: MyTheme.orange,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    handleTapFAB();
                  },
                  child: Transform.rotate(
                    angle: -buttonAngle,
                    child: Icon(
                      Icons.add_rounded,
                      color: MyTheme.darkGrey,
                      size: 46,
                    ),
                  ))),
        ),
      ],
    );
  }
}

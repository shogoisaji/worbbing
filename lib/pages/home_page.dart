import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:worbbing/application/usecase/notice_usecase.dart';
import 'package:worbbing/pages/view_model/home_page_view_model.dart';
import 'package:worbbing/presentation/widgets/ad_reward.dart';
import 'package:worbbing/presentation/widgets/ticket_widget.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/list_tile.dart';
import 'package:worbbing/presentation/widgets/tag_select.dart';
import 'package:worbbing/routes/router.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('HomePage build');
    final viewModel = ref.watch(homePageViewModelProvider);

    final appLifecycleState = useAppLifecycleState();

    final refresh = useState(false);

    useEffect(() {
      SchedulerBinding.instance
          .addPostFrameCallback((_) => viewModel.setSlideHintState());

      return null;
    }, []);
    useEffect(() {
      if (viewModel.sharedText != "") {
        SchedulerBinding.instance
            .addPostFrameCallback((_) => viewModel.getTextAction(context));
      }
      return null;
    }, [viewModel.sharedText]);

    useEffect(() {
      if (appLifecycleState == AppLifecycleState.resumed) {
        NoticeUsecase().shuffleNotifications();
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
                  child: TicketWidget(
                    count: viewModel.ticketCount,
                    size: 50,
                    isEnableUseAnimation: true,
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
                child: _customFloatingActionButton(
                    () => viewModel.showRegistrationBottomSheet(context))),
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
                          tagSelect('Notice', viewModel.tagState, 0, () {
                            viewModel.tagSelect(0);
                          }),
                          tagSelect('LatestAdd', viewModel.tagState, 1, () {
                            viewModel.tagSelect(1);
                          }),
                          tagSelect('Flag', viewModel.tagState, 2, () {
                            viewModel.tagSelect(2);
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
                    itemCount: viewModel.wordList.length,
                    itemBuilder: (context, index) {
                      final item = viewModel.wordList[index];
                      return Column(
                        children: [
                          WordListTile(
                            wordModel: item,
                            onWordUpdate: () => viewModel.refreshWordList(),
                            onTapList: () async {
                              await context.push(PagePath.detail, extra: item);
                              viewModel.refreshWordList();
                            },
                            isEnableSlideHint: true,
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
                    handleTapFAB();
                  },
                  child: Transform.rotate(
                    angle: -buttonAngle,
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.black,
                      size: 46,
                    ),
                  ))),
        ),
      ],
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_keys.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_repository.dart';
import 'package:worbbing/providers/demo_manager_provider.dart';
import 'package:worbbing/providers/ticket_state.dart';

part 'first_launch_usecase.g.dart';

@riverpod
FirstLaunchUsecase firstLaunchUsecase(FirstLaunchUsecaseRef ref) {
  return FirstLaunchUsecase(ref);
}

class FirstLaunchUsecase {
  final FirstLaunchUsecaseRef _ref;

  const FirstLaunchUsecase(this._ref);

  void execute(BuildContext context) {
    checkFirstLaunch(context);
  }

  void checkFirstLaunch(BuildContext context) {
    final isFirstLaunch = _ref
            .read(sharedPreferencesRepositoryProvider)
            .fetch<bool>(SharedPreferencesKey.isFirst) ??
        true;

    /// 初回の場合
    if (isFirstLaunch) {
      /// 初期チケットを付与
      _ref.read(ticketStateProvider.notifier).addInitialTicket();

      /// デモを開始
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _ref.read(demoManagerProvider.notifier).showDemo(context);
      });

      /// 初回を完了させる
      _ref
          .read(sharedPreferencesRepositoryProvider)
          .save(SharedPreferencesKey.isFirst, false);
    }
  }
}

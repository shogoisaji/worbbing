import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:worbbing/application/state/home_tag_state.dart';
import 'package:worbbing/application/state/router_path_state.dart';
import 'package:worbbing/application/state/share_text_state.dart';
import 'package:worbbing/application/state/slide_hint_state.dart';
import 'package:worbbing/application/state/ticket_state.dart';
import 'package:worbbing/application/state/word_list_state.dart';
import 'package:worbbing/application/usecase/app_state_usecase.dart';
import 'package:worbbing/application/usecase/word_list_usecase.dart';
import 'package:worbbing/models/word_model.dart';
import 'package:worbbing/presentation/widgets/my_simple_dialog.dart';
import 'package:worbbing/presentation/widgets/registration_bottom_sheet.dart';
import 'package:worbbing/routes/router.dart';

final homePageViewModelProvider = ChangeNotifierProvider((ref) {
  final usecase = ref.watch(wordListUsecaseProvider);
  return HomePageViewModel(ref, usecase);
});

class HomePageViewModel extends ChangeNotifier {
  final Ref _ref;
  final WordListUsecase _usecase;
  bool _disposed = false;

  HomePageViewModel(this._ref, this._usecase);

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  List<WordModel> get wordList => _ref.watch(wordListNotifierProvider);
  int get tagState => _ref.watch(homeTagStateProvider);
  int get ticketCount => _ref.watch(ticketStateProvider);
  String get sharedText => _ref.watch(shareTextStateProvider);
  bool get isEnableSlideHint => _ref.watch(slideHintStateProvider);

  Future<void> addNewWordModel(WordModel newWord, BuildContext context) async {
    String? result = await _usecase.addWordList(newWord);
    if (result == 'exist') {
      if (!context.mounted) return;
      await showExistingWordDialog(context, newWord.originalWord);
    } else {
      if (!context.mounted) return;
      Navigator.pop(context);
    }
    notifyListeners();
  }

  Future<void> showExistingWordDialog(BuildContext context, String word) async {
    await MySimpleDialog.show(
      context,
      Text('"$word" is\nalready registered.',
          style: const TextStyle(
              overflow: TextOverflow.clip, color: Colors.white, fontSize: 24)),
      'OK',
      () {},
    );
  }

  void tagSelect(int tagState) {
    _ref.read(homeTagStateProvider.notifier).setTagState(tagState);
    notifyListeners();
  }

  Future<void> getTextAction(BuildContext context) async {
    final pathState = _ref.read(routerPathStateProvider);

    /// PagePath.homeからcontext.go(PagePath.home)すると
    /// sharedTextがリセットされてしまうため、
    /// 別ページにいる場合のみ、PagePath.homeに遷移するようにする
    if (pathState != PagePath.home) {
      context.go(PagePath.home);
    }
    await showRegistrationBottomSheet(context);
    _ref.read(shareTextStateProvider.notifier).reset();
  }

  Future<void> showRegistrationBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      builder: (_) => RegistrationBottomSheet(
        initialText: sharedText,
      ),
    );
    if (!_disposed) {
      refreshWordList();
    }
  }

  void refreshWordList() {
    if (_disposed) return;
    _ref.read(refreshWordListProvider);
    notifyListeners();
  }

  void switchSlideHintState() {
    AppStateUsecase().switchEnableSlideHint(!isEnableSlideHint);
    setSlideHintState();
    notifyListeners();
  }

  void setSlideHintState() {
    final isEnableSlideHint = AppStateUsecase().isEnableSlideHint();
    _ref
        .read(slideHintStateProvider.notifier)
        .setSlideHintState(isEnableSlideHint);
    notifyListeners();
  }
}

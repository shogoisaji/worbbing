import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:worbbing/application/usecase/word_list_usecase.dart';
import 'package:worbbing/models/word_model.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/my_simple_dialog.dart';
import 'package:worbbing/presentation/widgets/two_way_dialog.dart';

final detailPageViewModelProvider =
    ChangeNotifierProvider.family<DetailPageViewModel, WordModel>((ref, word) {
  final usecase = ref.watch(wordListUsecaseProvider);
  return DetailPageViewModel(ref, usecase, word);
});

class DetailPageViewModel extends ChangeNotifier {
  final Ref _ref;
  final WordListUsecase _usecase;
  WordModel _wordModel;

  DetailPageViewModel(this._ref, this._usecase, WordModel initialWord)
      : _wordModel = initialWord;

  WordModel get wordModel => _wordModel;

  void handleTapDelete(BuildContext context) async {
    try {
      TwoWayDialog.show(context, 'Do you really want to delete it?',
          const Icon(Icons.help_outline, size: 36), null,
          leftButtonText: 'Cancel',
          rightButtonText: 'Delete',
          onLeftButtonPressed: () {}, onRightButtonPressed: () async {
        await _usecase.deleteWord(_wordModel);
        if (!context.mounted) return;
        context.pop();
      },
          titleColor: Colors.white,
          leftBgColor: MyTheme.red,
          leftTextColor: Colors.white);
    } catch (e) {
      MySimpleDialog.show(
          context,
          const Text(
            'Delete failed.',
            style: TextStyle(
                overflow: TextOverflow.clip, color: Colors.white, fontSize: 20),
          ),
          'OK',
          () {});
    }
  }

  Future<void> handleTapFlag(BuildContext context) async {
    await _usecase.updateFlag(wordModel.id, !wordModel.flag).catchError((e) {
      MySimpleDialog.show(
          context,
          const Text('Failed to update flag.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              )),
          'OK', () {
        //
      });
    });
    _wordModel = _wordModel.copyWith(flag: !_wordModel.flag);
    notifyListeners();
  }

  Future<void> updateWordModel(
      WordModel wordModel, BuildContext context) async {
    await _usecase.updateWord(wordModel).catchError((e) {
      MySimpleDialog.show(
          context,
          const Text(
            'Update failed.',
            style: TextStyle(
                overflow: TextOverflow.clip, color: Colors.white, fontSize: 20),
          ),
          'OK',
          () {});
    });
    _wordModel = wordModel;
    notifyListeners();
  }
}

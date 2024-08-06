import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:worbbing/application/state/router_path_state.dart';
import 'package:worbbing/application/state/share_text_state.dart';
import 'package:worbbing/data/repositories/sqflite/word_list_repository_impl.dart';
import 'package:worbbing/domain/entities/ticket_state.dart';
import 'package:worbbing/domain/usecases/word/add_word_usecase.dart';
import 'package:worbbing/domain/usecases/word/delete_word_usecase.dart';
import 'package:worbbing/domain/usecases/word/get_word_list_usecase.dart';
import 'package:worbbing/domain/usecases/word/update_word_usecase.dart';
import 'package:worbbing/models/word_model.dart';
import 'package:worbbing/presentation/pages/registration_page.dart';
import 'package:worbbing/providers/tag_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:worbbing/routes/router.dart';

part 'home_page_view_model.g.dart';

class HomePageState {
  final List<WordModel> wordList;
  final int tagState;
  final int ticketCount;
  final String sharedText;

  const HomePageState({
    this.tagState = 0,
    this.wordList = const [],
    required this.ticketCount,
    this.sharedText = '',
  });

  HomePageState copyWith({
    List<WordModel>? wordList,
    int? tagState,
    int? ticketCount,
    String? sharedText,
  }) =>
      HomePageState(
        wordList: wordList ?? this.wordList,
        tagState: tagState ?? this.tagState,
        ticketCount: ticketCount ?? this.ticketCount,
        sharedText: sharedText ?? this.sharedText,
      );
}

@Riverpod(keepAlive: true)
class HomePageViewModel extends _$HomePageViewModel {
  @override
  HomePageState build() {
    return HomePageState(
      ticketCount: ref.watch(ticketStateProvider),
    );
  }

  Future<void> getWordList() async {
    final tagState = ref.read(tagStateProvider);
    final usecase =
        GetWordListUsecase(ref.read(wordListRepositoryImplProvider));
    final result = await usecase.execute(tagState);
    state = state.copyWith(wordList: result);
  }

  Future<void> addWord(WordModel newWord) async {
    final usecase = AddWordUsecase(ref.read(wordListRepositoryImplProvider));
    try {
      await usecase.execute(newWord);
      state = state.copyWith(wordList: [...state.wordList, newWord]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteWord(String id) async {
    final usecase = DeleteWordUsecase(ref.read(wordListRepositoryImplProvider));
    await usecase.execute(id);
    state = state.copyWith(
        wordList: state.wordList.where((word) => word.id != id).toList());
  }

  Future<void> updateWord(WordModel word) async {
    final usecase = UpdateWordUsecase(ref.read(wordListRepositoryImplProvider));
    await usecase.execute(word);
    state = state.copyWith(
        wordList:
            state.wordList.map((m) => m.id == word.id ? m : word).toList());
  }

  void tagSelect(int tagState) {
    ref.read(tagStateProvider.notifier).setTagState(tagState);
    state = state.copyWith(tagState: tagState);
  }

  Future<void> getTextAction(BuildContext context) async {
    final pathState = ref.read(routerPathStateProvider);

    /// PagePath.homeからcontext.go(PagePath.home)すると
    /// sharedTextがリセットされてしまうため、
    /// 別ページにいる場合のみ、PagePath.homeに遷移するようにする
    if (pathState != PagePath.home) {
      context.go(PagePath.home);
    }
    await showRegistrationBottomSheet(context);
    ref.read(shareTextStateProvider.notifier).reset();
  }

  Future<void> showRegistrationBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      builder: (_) => RegistrationPage(
        initialText: ref.watch(shareTextStateProvider),
      ),
    );
    await getWordList();
  }
}
// final homePageViewModelProvider = ChangeNotifierProvider((ref) {
//   final usecase = ref.watch(wordListUsecaseProvider);
//   return HomePageViewModel(ref, usecase);
// });

// class HomePageViewModel extends ChangeNotifier {
//   final Ref _ref;
//   final WordListUsecase _usecase;
//   bool _disposed = false;

//   HomePageViewModel(this._ref, this._usecase);

//   @override
//   void dispose() {
//     _disposed = true;
//     super.dispose();
//   }

//   List<WordModel> get wordList => _ref.watch(wordListNotifierProvider);
//   int get tagState => _ref.watch(homeTagStateProvider);
//   int get ticketCount => _ref.watch(ticketStateProvider);
//   String get sharedText => _ref.watch(shareTextStateProvider);
//   bool get isEnableSlideHint => _ref.watch(slideHintStateProvider);

//   Future<void> addNewWordModel(WordModel newWord, BuildContext context) async {
//     String? result = await _usecase.addWordList(newWord);
//     if (result == 'exist') {
//       if (!context.mounted) return;
//       await showExistingWordDialog(context, newWord.originalWord);
//     } else {
//       if (!context.mounted) return;
//       Navigator.pop(context);
//     }
//     notifyListeners();
//   }

//   Future<void> showExistingWordDialog(BuildContext context, String word) async {
//     await MySimpleDialog.show(
//       context,
//       Text('"$word" is\nalready registered.',
//           style: const TextStyle(
//               overflow: TextOverflow.clip, color: Colors.white, fontSize: 24)),
//       'OK',
//       () {},
//     );
//   }

//   void tagSelect(int tagState) {
//     _ref.read(homeTagStateProvider.notifier).setTagState(tagState);
//     notifyListeners();
//   }


//   void refreshWordList() {
//     if (_disposed) return;
//     _ref.read(refreshWordListProvider);
//     notifyListeners();
//   }

//   void setSlideHintState() {
//     final isEnableSlideHint = _ref
//             .read(sharedPreferencesRepositoryProvider)
//             .fetch<bool>(SharedPreferencesKey.isEnableSlideHint) ??
//         true;
//     _ref
//         .read(slideHintStateProvider.notifier)
//         .setSlideHintState(isEnableSlideHint);
//     notifyListeners();
//   }
// }

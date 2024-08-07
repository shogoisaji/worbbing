import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:worbbing/providers/router_path_provider.dart';
import 'package:worbbing/providers/share_text_provider.dart';
import 'package:worbbing/data/repositories/sqflite/word_list_repository_impl.dart';
import 'package:worbbing/domain/entities/word_model.dart';
import 'package:worbbing/providers/ticket_state.dart';
import 'package:worbbing/domain/usecases/word/add_word_usecase.dart';
import 'package:worbbing/domain/usecases/word/delete_word_usecase.dart';
import 'package:worbbing/domain/usecases/word/get_word_list_usecase.dart';
import 'package:worbbing/domain/usecases/word/update_word_usecase.dart';
import 'package:worbbing/presentation/pages/registration_page.dart';
import 'package:worbbing/providers/tag_state_provider.dart';
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
      sharedText: ref.watch(shareTextProvider),
    );
  }

  Future<void> getWordList() async {
    final tagState = ref.read(tagStateProvider);
    final usecase = GetWordListUsecase(ref.read(wordListRepositoryProvider));
    final result = await usecase.execute(tagState);
    state = state.copyWith(wordList: result);
  }

  Future<void> addWord(WordModel newWord) async {
    final usecase = AddWordUsecase(ref.read(wordListRepositoryProvider));
    try {
      await usecase.execute(newWord);
      // state = state.copyWith(wordList: [...state.wordList, newWord]);
      await getWordList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteWord(String id) async {
    final usecase = DeleteWordUsecase(ref.read(wordListRepositoryProvider));
    await usecase.execute(id);
    state = state.copyWith(
        wordList: state.wordList.where((word) => word.id != id).toList());
  }

  Future<void> updateWord(WordModel word) async {
    final usecase = UpdateWordUsecase(ref.read(wordListRepositoryProvider));
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
    final pathState = ref.read(routerPathProvider);

    /// PagePath.homeからcontext.go(PagePath.home)すると
    /// sharedTextがリセットされてしまうため、
    /// 別ページにいる場合のみ、PagePath.homeに遷移するようにする
    if (pathState != PagePath.home) {
      context.go(PagePath.home);
    }
    await showRegistrationBottomSheet(context);
    ref.read(shareTextProvider.notifier).reset();
  }

  Future<void> showRegistrationBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      builder: (_) => RegistrationPage(
        initialText: ref.watch(shareTextProvider),
      ),
    );
  }
}

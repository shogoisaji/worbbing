import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:worbbing/data/repositories/sqflite/word_list_repository_impl.dart';
import 'package:worbbing/domain/entities/word_model.dart';
import 'package:worbbing/domain/usecases/word/delete_word_usecase.dart';
import 'package:worbbing/domain/usecases/word/update_word_usecase.dart';

part 'detail_page_view_model.g.dart';

class DetailPageState {
  final WordModel wordModel;

  DetailPageState({
    required this.wordModel,
  });

  DetailPageState copyWith({
    WordModel? wordModel,
  }) {
    return DetailPageState(
      wordModel: wordModel ?? this.wordModel,
    );
  }
}

@riverpod
class DetailPageViewModel extends _$DetailPageViewModel {
  @override
  DetailPageState build(WordModel initialWordModel) {
    return DetailPageState(
      wordModel: initialWordModel,
    );
  }

  Future<void> deleteWord() async {
    await DeleteWordUsecase(ref.read(wordListRepositoryProvider))
        .execute(state.wordModel.id);
  }

  Future<void> updateWord(WordModel wordModel) async {
    await UpdateWordUsecase(ref.read(wordListRepositoryProvider))
        .execute(wordModel);
    state = state.copyWith(wordModel: wordModel);
  }

  Future<void> changeFlag() async {
    final currentFlag = state.wordModel.flag;
    final updatedWordModel = state.wordModel.copyWith(flag: !currentFlag);
    await UpdateWordUsecase(ref.read(wordListRepositoryProvider))
        .execute(updatedWordModel);
    state = state.copyWith(wordModel: updatedWordModel);
  }
}

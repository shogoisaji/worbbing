import 'package:worbbing/domain/repositories/word_list_repository.dart';

class DeleteWordUsecase {
  final WordListRepository _wordListRepository;

  DeleteWordUsecase(this._wordListRepository);

  Future<void> execute(String wordId) async {
    try {
      await _wordListRepository.deleteWord(wordId);
    } catch (e) {
      rethrow;
    }
  }
}

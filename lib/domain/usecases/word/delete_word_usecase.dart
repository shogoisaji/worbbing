import 'package:worbbing/domain/repositories/word_list_repository.dart';

class DeleteWordUsecase {
  final WordListRepository wordListRepository;

  DeleteWordUsecase(this.wordListRepository);

  Future<void> execute(String wordId) async {
    try {
      await wordListRepository.deleteWord(wordId);
    } catch (e) {
      rethrow;
    }
  }
}

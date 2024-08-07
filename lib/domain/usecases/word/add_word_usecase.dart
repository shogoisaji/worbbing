import 'package:worbbing/domain/repositories/word_list_repository.dart';
import 'package:worbbing/models/word_model.dart';

class AddWordUsecase {
  final WordListRepository wordListRepository;

  AddWordUsecase(this.wordListRepository);

  Future<void> execute(WordModel word) async {
    try {
      await wordListRepository.addWord(word);
    } catch (e) {
      rethrow;
    }
  }
}

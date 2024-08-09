import 'package:worbbing/domain/entities/word_model.dart';
import 'package:worbbing/domain/repositories/word_list_repository.dart';

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

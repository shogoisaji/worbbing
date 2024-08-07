import 'package:worbbing/domain/entities/word_model.dart';
import 'package:worbbing/domain/repositories/word_list_repository.dart';

class UpdateWordUsecase {
  final WordListRepository wordListRepository;

  UpdateWordUsecase(this.wordListRepository);

  Future<void> execute(WordModel word) async {
    try {
      await wordListRepository.updateWord(word);
    } catch (e) {
      rethrow;
    }
  }
}

import 'package:worbbing/domain/repositories/word_list_repository.dart';
import 'package:worbbing/models/word_model.dart';

class UpdateWordUsecase {
  final WordListRepository _wordListRepository;

  UpdateWordUsecase(this._wordListRepository);

  Future<void> execute(WordModel word) async {
    try {
      await _wordListRepository.updateWord(word);
    } catch (e) {
      rethrow;
    }
  }
}

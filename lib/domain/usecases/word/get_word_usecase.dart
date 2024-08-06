import 'package:worbbing/domain/repositories/word_list_repository.dart';
import 'package:worbbing/models/word_model.dart';

class GetWordUsecase {
  final WordListRepository _wordListRepository;

  GetWordUsecase(this._wordListRepository);

  Future<WordModel?> execute(String id) async {
    try {
      return await _wordListRepository.getWordById(id);
    } catch (e) {
      rethrow;
    }
  }
}

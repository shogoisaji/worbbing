import 'package:worbbing/domain/entities/word_model.dart';
import 'package:worbbing/domain/repositories/word_list_repository.dart';

class GetWordUsecase {
  final WordListRepository wordListRepository;

  GetWordUsecase(this.wordListRepository);

  Future<WordModel?> execute(String id) async {
    try {
      return await wordListRepository.getWordById(id);
    } catch (e) {
      rethrow;
    }
  }
}

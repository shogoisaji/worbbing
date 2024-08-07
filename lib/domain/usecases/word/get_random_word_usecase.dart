import 'package:worbbing/domain/repositories/word_list_repository.dart';
import 'package:worbbing/models/word_model.dart';

class GetRandomWordUsecase {
  final WordListRepository wordListRepository;

  GetRandomWordUsecase(this.wordListRepository);

  Future<WordModel?> execute() async {
    try {
      return await wordListRepository.getRandomWord();
    } catch (e) {
      rethrow;
    }
  }
}

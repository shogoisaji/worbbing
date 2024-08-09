import 'package:worbbing/domain/repositories/word_list_repository.dart';

class GetTotalWordsUsecase {
  final WordListRepository wordListRepository;

  GetTotalWordsUsecase(this.wordListRepository);

  Future<int> execute() async {
    try {
      return await wordListRepository.getTotalWords();
    } catch (e) {
      rethrow;
    }
  }
}

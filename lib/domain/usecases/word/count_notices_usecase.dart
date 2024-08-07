import 'package:worbbing/domain/repositories/word_list_repository.dart';

class CountNoticesUsecase {
  final WordListRepository wordListRepository;

  CountNoticesUsecase(this.wordListRepository);

  Future<Map<int, int>> execute() async {
    try {
      return await wordListRepository.countByNotices();
    } catch (e) {
      throw Exception(e);
    }
  }
}

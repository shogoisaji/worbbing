import 'package:worbbing/domain/repositories/word_list_repository.dart';
import 'package:worbbing/models/word_model.dart';

class GetWordListUsecase {
  final WordListRepository _wordListRepository;

  GetWordListUsecase(this._wordListRepository);

  Future<List<WordModel>> execute(
      {String? orderBy, bool isDesc = true, bool isFlag = false}) async {
    try {
      return await _wordListRepository.getWordList(
          orderBy: orderBy, isDesc: isDesc, isFlag: isFlag);
    } catch (e) {
      rethrow;
    }
  }
}

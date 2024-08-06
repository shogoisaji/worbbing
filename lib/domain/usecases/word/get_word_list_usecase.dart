import 'package:worbbing/domain/repositories/word_list_repository.dart';
import 'package:worbbing/models/word_model.dart';

class GetWordListUsecase {
  final WordListRepository _wordListRepository;

  GetWordListUsecase(this._wordListRepository);

  Future<List<WordModel>> execute(int tagState) async {
    try {
      switch (tagState) {
        case 0:
          final wordList = await _wordListRepository.getWordList();
          return _sortNotice(wordList);
        case 1:
          return await _wordListRepository.getWordList();
        case 2:
          return await _wordListRepository.getWordList(isFlag: true);
        default:
          return await _wordListRepository.getWordList();
      }
    } catch (e) {
      rethrow;
    }
  }

  List<WordModel> _sortNotice(List<WordModel> wordList) {
    for (var i = 0; i < wordList.length; i++) {
      final noticeDurationTime = wordList[i].noticeDuration;
      final updateDateTime = wordList[i].updateDate;
      final forgettingDuration =
          DateTime.now().difference(updateDateTime).inDays;
      if (forgettingDuration >= noticeDurationTime &&
          noticeDurationTime != 99) {
        // insert top of array
        var insertData = wordList.removeAt(i);
        wordList.insert(0, insertData);
      }
    }
    return wordList;
  }
}

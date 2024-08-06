import 'package:worbbing/models/word_model.dart';

abstract class WordListRepository {
  Future<List<WordModel>> fetchWordList(
      {String? orderBy, bool isDesc = true, bool isFlag = false});
  Future<WordModel> fetchWordById(String wordId);
  Future<void> addWord(WordModel word);
  Future<void> updateWord(WordModel word);
  Future<void> deleteWord(String wordId);
  Future<WordModel> fetchRandomWord();
  Future<Map<int, int>> countByNotices();
  Future<int> fetchTotalWords();
}

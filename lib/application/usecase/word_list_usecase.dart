// import 'package:worbbing/models/word_model.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'word_list_usecase.g.dart';

// @Riverpod(keepAlive: true)
// WordListUsecase wordListUsecase(WordListUsecaseRef ref) {
//   return WordListUsecase(ref.read(sqfliteRepositoryProvider));
// }

// class WordListUsecase {
//   final SqfliteRepository _sqfliteRepository;
//   WordListUsecase(this._sqfliteRepository);

//   /// 単語がすでに存在する場合は、"exist"が返る
//   Future<String?> addWordList(WordModel newWord) async {
//     return await _sqfliteRepository.insertData(newWord);
//   }

//   Future<void> deleteWord(WordModel word) async {
//     return await _sqfliteRepository.deleteRow(word.id).catchError((e) {
//       throw Exception(e);
//     });
//   }

//   Future<void> updateWord(WordModel word) async {
//     return await _sqfliteRepository.updateWords(word).catchError((e) {
//       throw Exception(e);
//     });
//   }

//   Future<void> updateFlag(String id, bool flag) async {
//     return await _sqfliteRepository.updateFlag(id, flag).catchError((e) {
//       throw Exception(e);
//     });
//   }
// }

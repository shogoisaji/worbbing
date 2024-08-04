import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:worbbing/application/state/home_tag_state.dart';
import 'package:worbbing/models/word_model.dart';
import 'package:worbbing/repository/sqflite/sqflite_repository.dart';

part 'word_list_state.g.dart';

@Riverpod(keepAlive: true)
Future<List<WordModel>> wordListStateNotifier(
    WordListStateNotifierRef ref) async {
  final tagState = ref.watch(homeTagStateProvider);
  final model = await switch (tagState) {
    0 => SqfliteRepository.instance.queryAllRowsNoticeDuration(),
    1 => SqfliteRepository.instance.queryAllRowsRegistration(),
    2 => SqfliteRepository.instance.queryAllRowsFlag(),
    _ => SqfliteRepository.instance.queryAllRowsNoticeDuration(),
  };
  if (tagState == 0) {
    return _replaceWordList(model);
  } else {
    return model;
  }
}

@riverpod
void refreshWordList(RefreshWordListRef ref) {
  ref.invalidate(wordListStateNotifierProvider);
}

@Riverpod(keepAlive: true)
List<WordModel> wordListNotifier(WordListNotifierRef ref) {
  final list = ref.watch(wordListStateNotifierProvider);
  return list.when(
    loading: () => [],
    error: (_, __) => [],
    data: (d) => d,
  );
}

// @Riverpod(keepAlive: true)
// class WordListState extends _$WordListState {
//   @override
//   List<WordModel> build() => [];

//   void loadWordList() async {
//     final tagState = ref.read(homeTagStateProvider);
//     final model = switch (tagState) {
//       0 => await SqfliteRepository.instance.queryAllRowsNoticeDuration(),
//       1 => await SqfliteRepository.instance.queryAllRowsRegistration(),
//       2 => await SqfliteRepository.instance.queryAllRowsFlag(),
//       _ => await SqfliteRepository.instance.queryAllRowsNoticeDuration(),
//     };
//     if (tagState == 0) {
//       state = _replaceWordList(model);
//     } else {
//       state = model;
//     }
//   }

List<WordModel> _replaceWordList(List<WordModel> models) {
  final DateTime currentDateTime = DateTime.now();
  int noticeDurationTime;
  int forgettingDuration;
  DateTime updateDateTime;
  for (var i = 0; i < models.length; i++) {
    noticeDurationTime = models[i].noticeDuration;
    updateDateTime = models[i].updateDate;
    forgettingDuration = currentDateTime.difference(updateDateTime).inDays;
    if (forgettingDuration >= noticeDurationTime && noticeDurationTime != 99) {
      // insert top of array
      var insertData = models.removeAt(i);
      models.insert(0, insertData);
    }
  }
  return models;
}

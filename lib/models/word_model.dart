// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'word_model.freezed.dart';
part 'word_model.g.dart';

const List<int> noticeDurationList = [1, 3, 7, 14, 30, 90, 00];

@freezed
class WordModel with _$WordModel {
  const factory WordModel({
    required String id,
    @JsonKey(name: 'original_word') required String originalWord,
    @JsonKey(name: 'translated_word') required String translatedWord,
    @JsonKey(name: 'notice_duration') required int noticeDuration,
    @JsonKey(name: 'update_count') required int updateCount,
    @JsonKey(name: 'update_date') required DateTime updateDate,
    @JsonKey(name: 'registration_date') required DateTime registrationDate,
    @Default(false) bool flag,
    String? memo,
  }) = _WordModel;

  factory WordModel.fromJson(Map<String, dynamic> json) => WordModel(
        id: json['id'] as String,
        originalWord: json['original_word'] as String,
        translatedWord: json['translated_word'] as String,
        noticeDuration: json['notice_duration'] as int,
        updateCount: json['update_count'] as int,
        updateDate: DateTime.parse(json['update_date'] as String),
        registrationDate: DateTime.parse(json['registration_date'] as String),
        flag: json['flag'] as int != 0, // 0:false 1:true
        memo: json['memo'] as String?,
      );

  factory WordModel.createNewWord(
      {required String originalWord,
      required String translatedWord,
      bool flag = false,
      String? memo}) {
    return WordModel(
      id: const Uuid().v4(),
      originalWord: originalWord,
      translatedWord: translatedWord,
      noticeDuration: 1,
      updateCount: 0,
      updateDate: DateTime.now(),
      registrationDate: DateTime.now(),
      flag: flag,
      memo: memo,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'original_word': originalWord,
      'translated_word': translatedWord,
      'notice_duration': noticeDuration,
      'update_count': updateCount,
      'update_date': updateDate.toIso8601String(),
      'registration_date': registrationDate.toIso8601String(),
      'flag': flag ? 1 : 0,
      'memo': memo,
    };
  }
}

extension WordModelExtension on WordModel {
  WordModel upNoticeDuration() {
    final currentDurationIndex = noticeDurationList.indexOf(noticeDuration);
    if (currentDurationIndex == noticeDurationList.length - 1) {
      return this;
    }
    return copyWith(
      noticeDuration: noticeDurationList[currentDurationIndex + 1],
    );
  }

  WordModel downNoticeDuration() {
    final currentDurationIndex = noticeDurationList.indexOf(noticeDuration);
    if (currentDurationIndex == 0) {
      return this;
    }
    return copyWith(
      noticeDuration: noticeDurationList[currentDurationIndex - 1],
    );
  }
}

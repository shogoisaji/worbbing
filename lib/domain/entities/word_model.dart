// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:worbbing/models/translate_language.dart';

part 'word_model.freezed.dart';
part 'word_model.g.dart';

const List<int> noticeDurationList = [1, 3, 7, 14, 30, 90, 99];

bool _flagFromJson(int flag) => flag != 0;

int _flagToJson(bool flag) => flag ? 1 : 0;

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
    @JsonKey(toJson: _flagToJson, fromJson: _flagFromJson)
    @Default(false)
    bool flag,
    String? example,
    @JsonKey(name: 'example_translated') String? exampleTranslated,
    @JsonKey(name: 'original_lang') required TranslateLanguage originalLang,
    @JsonKey(name: 'translated_lang') required TranslateLanguage translatedLang,
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
        example: json['example'] as String?,
        exampleTranslated: json['example_translated'] as String?,
        originalLang: TranslateLanguage.values
            .firstWhere((e) => e.lowerString == json['original_lang']),
        translatedLang: TranslateLanguage.values
            .firstWhere((e) => e.lowerString == json['translated_lang']),
      );

  factory WordModel.createNewWord({
    required String originalWord,
    required String translatedWord,
    bool flag = false,
    String? example,
    String? exampleTranslated,
    required TranslateLanguage originalLang,
    required TranslateLanguage translatedLang,
  }) {
    return WordModel(
      id: const Uuid().v4(),
      originalWord: originalWord,
      translatedWord: translatedWord,
      noticeDuration: 1,
      updateCount: 0,
      updateDate: DateTime.now(),
      registrationDate: DateTime.now(),
      flag: flag,
      example: example,
      exampleTranslated: exampleTranslated,
      originalLang: originalLang,
      translatedLang: translatedLang,
    );
  }
}

extension WordModelExtension on WordModel {
  WordModel upNoticeDuration() {
    final currentDurationIndex = noticeDurationList.indexOf(noticeDuration);
    if (currentDurationIndex == noticeDurationList.length - 1) {
      return copyWith(
        updateDate: DateTime.now(),
      );
    }
    return copyWith(
      noticeDuration: noticeDurationList[currentDurationIndex + 1],
      updateDate: DateTime.now(),
    );
  }

  WordModel downNoticeDuration() {
    final currentDurationIndex = noticeDurationList.indexOf(noticeDuration);
    if (currentDurationIndex == 0) {
      return copyWith(
        updateDate: DateTime.now(),
      );
    }
    return copyWith(
      noticeDuration: noticeDurationList[currentDurationIndex - 1],
      updateDate: DateTime.now(),
    );
  }
}

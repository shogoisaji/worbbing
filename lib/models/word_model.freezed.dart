// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'word_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WordModel _$WordModelFromJson(Map<String, dynamic> json) {
  return _WordModel.fromJson(json);
}

/// @nodoc
mixin _$WordModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'original_word')
  String get originalWord => throw _privateConstructorUsedError;
  @JsonKey(name: 'translated_word')
  String get translatedWord => throw _privateConstructorUsedError;
  @JsonKey(name: 'notice_duration')
  int get noticeDuration => throw _privateConstructorUsedError;
  @JsonKey(name: 'update_count')
  int get updateCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'update_date')
  DateTime get updateDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'registration_date')
  DateTime get registrationDate => throw _privateConstructorUsedError;
  @JsonKey(toJson: _flagToJson, fromJson: _flagFromJson)
  bool get flag => throw _privateConstructorUsedError;
  String? get example => throw _privateConstructorUsedError;
  @JsonKey(name: 'example_translated')
  String? get exampleTranslated => throw _privateConstructorUsedError;
  @JsonKey(name: 'original_lang')
  TranslateLanguage get originalLang => throw _privateConstructorUsedError;
  @JsonKey(name: 'translated_lang')
  TranslateLanguage get translatedLang => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WordModelCopyWith<WordModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WordModelCopyWith<$Res> {
  factory $WordModelCopyWith(WordModel value, $Res Function(WordModel) then) =
      _$WordModelCopyWithImpl<$Res, WordModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'original_word') String originalWord,
      @JsonKey(name: 'translated_word') String translatedWord,
      @JsonKey(name: 'notice_duration') int noticeDuration,
      @JsonKey(name: 'update_count') int updateCount,
      @JsonKey(name: 'update_date') DateTime updateDate,
      @JsonKey(name: 'registration_date') DateTime registrationDate,
      @JsonKey(toJson: _flagToJson, fromJson: _flagFromJson) bool flag,
      String? example,
      @JsonKey(name: 'example_translated') String? exampleTranslated,
      @JsonKey(name: 'original_lang') TranslateLanguage originalLang,
      @JsonKey(name: 'translated_lang') TranslateLanguage translatedLang});
}

/// @nodoc
class _$WordModelCopyWithImpl<$Res, $Val extends WordModel>
    implements $WordModelCopyWith<$Res> {
  _$WordModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? originalWord = null,
    Object? translatedWord = null,
    Object? noticeDuration = null,
    Object? updateCount = null,
    Object? updateDate = null,
    Object? registrationDate = null,
    Object? flag = null,
    Object? example = freezed,
    Object? exampleTranslated = freezed,
    Object? originalLang = null,
    Object? translatedLang = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      originalWord: null == originalWord
          ? _value.originalWord
          : originalWord // ignore: cast_nullable_to_non_nullable
              as String,
      translatedWord: null == translatedWord
          ? _value.translatedWord
          : translatedWord // ignore: cast_nullable_to_non_nullable
              as String,
      noticeDuration: null == noticeDuration
          ? _value.noticeDuration
          : noticeDuration // ignore: cast_nullable_to_non_nullable
              as int,
      updateCount: null == updateCount
          ? _value.updateCount
          : updateCount // ignore: cast_nullable_to_non_nullable
              as int,
      updateDate: null == updateDate
          ? _value.updateDate
          : updateDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      registrationDate: null == registrationDate
          ? _value.registrationDate
          : registrationDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      flag: null == flag
          ? _value.flag
          : flag // ignore: cast_nullable_to_non_nullable
              as bool,
      example: freezed == example
          ? _value.example
          : example // ignore: cast_nullable_to_non_nullable
              as String?,
      exampleTranslated: freezed == exampleTranslated
          ? _value.exampleTranslated
          : exampleTranslated // ignore: cast_nullable_to_non_nullable
              as String?,
      originalLang: null == originalLang
          ? _value.originalLang
          : originalLang // ignore: cast_nullable_to_non_nullable
              as TranslateLanguage,
      translatedLang: null == translatedLang
          ? _value.translatedLang
          : translatedLang // ignore: cast_nullable_to_non_nullable
              as TranslateLanguage,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WordModelImplCopyWith<$Res>
    implements $WordModelCopyWith<$Res> {
  factory _$$WordModelImplCopyWith(
          _$WordModelImpl value, $Res Function(_$WordModelImpl) then) =
      __$$WordModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'original_word') String originalWord,
      @JsonKey(name: 'translated_word') String translatedWord,
      @JsonKey(name: 'notice_duration') int noticeDuration,
      @JsonKey(name: 'update_count') int updateCount,
      @JsonKey(name: 'update_date') DateTime updateDate,
      @JsonKey(name: 'registration_date') DateTime registrationDate,
      @JsonKey(toJson: _flagToJson, fromJson: _flagFromJson) bool flag,
      String? example,
      @JsonKey(name: 'example_translated') String? exampleTranslated,
      @JsonKey(name: 'original_lang') TranslateLanguage originalLang,
      @JsonKey(name: 'translated_lang') TranslateLanguage translatedLang});
}

/// @nodoc
class __$$WordModelImplCopyWithImpl<$Res>
    extends _$WordModelCopyWithImpl<$Res, _$WordModelImpl>
    implements _$$WordModelImplCopyWith<$Res> {
  __$$WordModelImplCopyWithImpl(
      _$WordModelImpl _value, $Res Function(_$WordModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? originalWord = null,
    Object? translatedWord = null,
    Object? noticeDuration = null,
    Object? updateCount = null,
    Object? updateDate = null,
    Object? registrationDate = null,
    Object? flag = null,
    Object? example = freezed,
    Object? exampleTranslated = freezed,
    Object? originalLang = null,
    Object? translatedLang = null,
  }) {
    return _then(_$WordModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      originalWord: null == originalWord
          ? _value.originalWord
          : originalWord // ignore: cast_nullable_to_non_nullable
              as String,
      translatedWord: null == translatedWord
          ? _value.translatedWord
          : translatedWord // ignore: cast_nullable_to_non_nullable
              as String,
      noticeDuration: null == noticeDuration
          ? _value.noticeDuration
          : noticeDuration // ignore: cast_nullable_to_non_nullable
              as int,
      updateCount: null == updateCount
          ? _value.updateCount
          : updateCount // ignore: cast_nullable_to_non_nullable
              as int,
      updateDate: null == updateDate
          ? _value.updateDate
          : updateDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      registrationDate: null == registrationDate
          ? _value.registrationDate
          : registrationDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      flag: null == flag
          ? _value.flag
          : flag // ignore: cast_nullable_to_non_nullable
              as bool,
      example: freezed == example
          ? _value.example
          : example // ignore: cast_nullable_to_non_nullable
              as String?,
      exampleTranslated: freezed == exampleTranslated
          ? _value.exampleTranslated
          : exampleTranslated // ignore: cast_nullable_to_non_nullable
              as String?,
      originalLang: null == originalLang
          ? _value.originalLang
          : originalLang // ignore: cast_nullable_to_non_nullable
              as TranslateLanguage,
      translatedLang: null == translatedLang
          ? _value.translatedLang
          : translatedLang // ignore: cast_nullable_to_non_nullable
              as TranslateLanguage,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WordModelImpl implements _WordModel {
  const _$WordModelImpl(
      {required this.id,
      @JsonKey(name: 'original_word') required this.originalWord,
      @JsonKey(name: 'translated_word') required this.translatedWord,
      @JsonKey(name: 'notice_duration') required this.noticeDuration,
      @JsonKey(name: 'update_count') required this.updateCount,
      @JsonKey(name: 'update_date') required this.updateDate,
      @JsonKey(name: 'registration_date') required this.registrationDate,
      @JsonKey(toJson: _flagToJson, fromJson: _flagFromJson) this.flag = false,
      this.example,
      @JsonKey(name: 'example_translated') this.exampleTranslated,
      @JsonKey(name: 'original_lang') required this.originalLang,
      @JsonKey(name: 'translated_lang') required this.translatedLang});

  factory _$WordModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WordModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'original_word')
  final String originalWord;
  @override
  @JsonKey(name: 'translated_word')
  final String translatedWord;
  @override
  @JsonKey(name: 'notice_duration')
  final int noticeDuration;
  @override
  @JsonKey(name: 'update_count')
  final int updateCount;
  @override
  @JsonKey(name: 'update_date')
  final DateTime updateDate;
  @override
  @JsonKey(name: 'registration_date')
  final DateTime registrationDate;
  @override
  @JsonKey(toJson: _flagToJson, fromJson: _flagFromJson)
  final bool flag;
  @override
  final String? example;
  @override
  @JsonKey(name: 'example_translated')
  final String? exampleTranslated;
  @override
  @JsonKey(name: 'original_lang')
  final TranslateLanguage originalLang;
  @override
  @JsonKey(name: 'translated_lang')
  final TranslateLanguage translatedLang;

  @override
  String toString() {
    return 'WordModel(id: $id, originalWord: $originalWord, translatedWord: $translatedWord, noticeDuration: $noticeDuration, updateCount: $updateCount, updateDate: $updateDate, registrationDate: $registrationDate, flag: $flag, example: $example, exampleTranslated: $exampleTranslated, originalLang: $originalLang, translatedLang: $translatedLang)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WordModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.originalWord, originalWord) ||
                other.originalWord == originalWord) &&
            (identical(other.translatedWord, translatedWord) ||
                other.translatedWord == translatedWord) &&
            (identical(other.noticeDuration, noticeDuration) ||
                other.noticeDuration == noticeDuration) &&
            (identical(other.updateCount, updateCount) ||
                other.updateCount == updateCount) &&
            (identical(other.updateDate, updateDate) ||
                other.updateDate == updateDate) &&
            (identical(other.registrationDate, registrationDate) ||
                other.registrationDate == registrationDate) &&
            (identical(other.flag, flag) || other.flag == flag) &&
            (identical(other.example, example) || other.example == example) &&
            (identical(other.exampleTranslated, exampleTranslated) ||
                other.exampleTranslated == exampleTranslated) &&
            (identical(other.originalLang, originalLang) ||
                other.originalLang == originalLang) &&
            (identical(other.translatedLang, translatedLang) ||
                other.translatedLang == translatedLang));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      originalWord,
      translatedWord,
      noticeDuration,
      updateCount,
      updateDate,
      registrationDate,
      flag,
      example,
      exampleTranslated,
      originalLang,
      translatedLang);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WordModelImplCopyWith<_$WordModelImpl> get copyWith =>
      __$$WordModelImplCopyWithImpl<_$WordModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WordModelImplToJson(
      this,
    );
  }
}

abstract class _WordModel implements WordModel {
  const factory _WordModel(
      {required final String id,
      @JsonKey(name: 'original_word') required final String originalWord,
      @JsonKey(name: 'translated_word') required final String translatedWord,
      @JsonKey(name: 'notice_duration') required final int noticeDuration,
      @JsonKey(name: 'update_count') required final int updateCount,
      @JsonKey(name: 'update_date') required final DateTime updateDate,
      @JsonKey(name: 'registration_date')
      required final DateTime registrationDate,
      @JsonKey(toJson: _flagToJson, fromJson: _flagFromJson) final bool flag,
      final String? example,
      @JsonKey(name: 'example_translated') final String? exampleTranslated,
      @JsonKey(name: 'original_lang')
      required final TranslateLanguage originalLang,
      @JsonKey(name: 'translated_lang')
      required final TranslateLanguage translatedLang}) = _$WordModelImpl;

  factory _WordModel.fromJson(Map<String, dynamic> json) =
      _$WordModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'original_word')
  String get originalWord;
  @override
  @JsonKey(name: 'translated_word')
  String get translatedWord;
  @override
  @JsonKey(name: 'notice_duration')
  int get noticeDuration;
  @override
  @JsonKey(name: 'update_count')
  int get updateCount;
  @override
  @JsonKey(name: 'update_date')
  DateTime get updateDate;
  @override
  @JsonKey(name: 'registration_date')
  DateTime get registrationDate;
  @override
  @JsonKey(toJson: _flagToJson, fromJson: _flagFromJson)
  bool get flag;
  @override
  String? get example;
  @override
  @JsonKey(name: 'example_translated')
  String? get exampleTranslated;
  @override
  @JsonKey(name: 'original_lang')
  TranslateLanguage get originalLang;
  @override
  @JsonKey(name: 'translated_lang')
  TranslateLanguage get translatedLang;
  @override
  @JsonKey(ignore: true)
  _$$WordModelImplCopyWith<_$WordModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notice_data_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NoticeDataModel _$NoticeDataModelFromJson(Map<String, dynamic> json) {
  return _NoticeDataModel.fromJson(json);
}

/// @nodoc
mixin _$NoticeDataModel {
// ignore: invalid_annotation_target
  @JsonKey(name: 'notice_id')
  int? get noticeId =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'word_id')
  String get wordId => throw _privateConstructorUsedError;
  String get original => throw _privateConstructorUsedError;
  String get translated => throw _privateConstructorUsedError;
  @TimeOfDayConverter()
  TimeOfDay get time => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NoticeDataModelCopyWith<NoticeDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoticeDataModelCopyWith<$Res> {
  factory $NoticeDataModelCopyWith(
          NoticeDataModel value, $Res Function(NoticeDataModel) then) =
      _$NoticeDataModelCopyWithImpl<$Res, NoticeDataModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'notice_id') int? noticeId,
      @JsonKey(name: 'word_id') String wordId,
      String original,
      String translated,
      @TimeOfDayConverter() TimeOfDay time});
}

/// @nodoc
class _$NoticeDataModelCopyWithImpl<$Res, $Val extends NoticeDataModel>
    implements $NoticeDataModelCopyWith<$Res> {
  _$NoticeDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? noticeId = freezed,
    Object? wordId = null,
    Object? original = null,
    Object? translated = null,
    Object? time = null,
  }) {
    return _then(_value.copyWith(
      noticeId: freezed == noticeId
          ? _value.noticeId
          : noticeId // ignore: cast_nullable_to_non_nullable
              as int?,
      wordId: null == wordId
          ? _value.wordId
          : wordId // ignore: cast_nullable_to_non_nullable
              as String,
      original: null == original
          ? _value.original
          : original // ignore: cast_nullable_to_non_nullable
              as String,
      translated: null == translated
          ? _value.translated
          : translated // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NoticeDataModelImplCopyWith<$Res>
    implements $NoticeDataModelCopyWith<$Res> {
  factory _$$NoticeDataModelImplCopyWith(_$NoticeDataModelImpl value,
          $Res Function(_$NoticeDataModelImpl) then) =
      __$$NoticeDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'notice_id') int? noticeId,
      @JsonKey(name: 'word_id') String wordId,
      String original,
      String translated,
      @TimeOfDayConverter() TimeOfDay time});
}

/// @nodoc
class __$$NoticeDataModelImplCopyWithImpl<$Res>
    extends _$NoticeDataModelCopyWithImpl<$Res, _$NoticeDataModelImpl>
    implements _$$NoticeDataModelImplCopyWith<$Res> {
  __$$NoticeDataModelImplCopyWithImpl(
      _$NoticeDataModelImpl _value, $Res Function(_$NoticeDataModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? noticeId = freezed,
    Object? wordId = null,
    Object? original = null,
    Object? translated = null,
    Object? time = null,
  }) {
    return _then(_$NoticeDataModelImpl(
      noticeId: freezed == noticeId
          ? _value.noticeId
          : noticeId // ignore: cast_nullable_to_non_nullable
              as int?,
      wordId: null == wordId
          ? _value.wordId
          : wordId // ignore: cast_nullable_to_non_nullable
              as String,
      original: null == original
          ? _value.original
          : original // ignore: cast_nullable_to_non_nullable
              as String,
      translated: null == translated
          ? _value.translated
          : translated // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as TimeOfDay,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NoticeDataModelImpl implements _NoticeDataModel {
  const _$NoticeDataModelImpl(
      {@JsonKey(name: 'notice_id') this.noticeId,
      @JsonKey(name: 'word_id') required this.wordId,
      required this.original,
      required this.translated,
      @TimeOfDayConverter() required this.time});

  factory _$NoticeDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoticeDataModelImplFromJson(json);

// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'notice_id')
  final int? noticeId;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'word_id')
  final String wordId;
  @override
  final String original;
  @override
  final String translated;
  @override
  @TimeOfDayConverter()
  final TimeOfDay time;

  @override
  String toString() {
    return 'NoticeDataModel(noticeId: $noticeId, wordId: $wordId, original: $original, translated: $translated, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoticeDataModelImpl &&
            (identical(other.noticeId, noticeId) ||
                other.noticeId == noticeId) &&
            (identical(other.wordId, wordId) || other.wordId == wordId) &&
            (identical(other.original, original) ||
                other.original == original) &&
            (identical(other.translated, translated) ||
                other.translated == translated) &&
            (identical(other.time, time) || other.time == time));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, noticeId, wordId, original, translated, time);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NoticeDataModelImplCopyWith<_$NoticeDataModelImpl> get copyWith =>
      __$$NoticeDataModelImplCopyWithImpl<_$NoticeDataModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NoticeDataModelImplToJson(
      this,
    );
  }
}

abstract class _NoticeDataModel implements NoticeDataModel {
  const factory _NoticeDataModel(
          {@JsonKey(name: 'notice_id') final int? noticeId,
          @JsonKey(name: 'word_id') required final String wordId,
          required final String original,
          required final String translated,
          @TimeOfDayConverter() required final TimeOfDay time}) =
      _$NoticeDataModelImpl;

  factory _NoticeDataModel.fromJson(Map<String, dynamic> json) =
      _$NoticeDataModelImpl.fromJson;

  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'notice_id')
  int? get noticeId;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'word_id')
  String get wordId;
  @override
  String get original;
  @override
  String get translated;
  @override
  @TimeOfDayConverter()
  TimeOfDay get time;
  @override
  @JsonKey(ignore: true)
  _$$NoticeDataModelImplCopyWith<_$NoticeDataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

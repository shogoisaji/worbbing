// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'translated_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TranslatedResponse _$TranslatedResponseFromJson(Map<String, dynamic> json) {
  return _TranslatedResponse.fromJson(json);
}

/// @nodoc
mixin _$TranslatedResponse {
  String get original => throw _privateConstructorUsedError;
  List<String> get translated => throw _privateConstructorUsedError;
  String get example =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'example_translated')
  String get exampleTranslated => throw _privateConstructorUsedError;
  TranslatedResponseType get type =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'original_lang')
  TranslateLanguage get originalLang =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'translate_lang')
  TranslateLanguage get translateLang => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TranslatedResponseCopyWith<TranslatedResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TranslatedResponseCopyWith<$Res> {
  factory $TranslatedResponseCopyWith(
          TranslatedResponse value, $Res Function(TranslatedResponse) then) =
      _$TranslatedResponseCopyWithImpl<$Res, TranslatedResponse>;
  @useResult
  $Res call(
      {String original,
      List<String> translated,
      String example,
      @JsonKey(name: 'example_translated') String exampleTranslated,
      TranslatedResponseType type,
      @JsonKey(name: 'original_lang') TranslateLanguage originalLang,
      @JsonKey(name: 'translate_lang') TranslateLanguage translateLang});
}

/// @nodoc
class _$TranslatedResponseCopyWithImpl<$Res, $Val extends TranslatedResponse>
    implements $TranslatedResponseCopyWith<$Res> {
  _$TranslatedResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? original = null,
    Object? translated = null,
    Object? example = null,
    Object? exampleTranslated = null,
    Object? type = null,
    Object? originalLang = null,
    Object? translateLang = null,
  }) {
    return _then(_value.copyWith(
      original: null == original
          ? _value.original
          : original // ignore: cast_nullable_to_non_nullable
              as String,
      translated: null == translated
          ? _value.translated
          : translated // ignore: cast_nullable_to_non_nullable
              as List<String>,
      example: null == example
          ? _value.example
          : example // ignore: cast_nullable_to_non_nullable
              as String,
      exampleTranslated: null == exampleTranslated
          ? _value.exampleTranslated
          : exampleTranslated // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TranslatedResponseType,
      originalLang: null == originalLang
          ? _value.originalLang
          : originalLang // ignore: cast_nullable_to_non_nullable
              as TranslateLanguage,
      translateLang: null == translateLang
          ? _value.translateLang
          : translateLang // ignore: cast_nullable_to_non_nullable
              as TranslateLanguage,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TranslatedResponseImplCopyWith<$Res>
    implements $TranslatedResponseCopyWith<$Res> {
  factory _$$TranslatedResponseImplCopyWith(_$TranslatedResponseImpl value,
          $Res Function(_$TranslatedResponseImpl) then) =
      __$$TranslatedResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String original,
      List<String> translated,
      String example,
      @JsonKey(name: 'example_translated') String exampleTranslated,
      TranslatedResponseType type,
      @JsonKey(name: 'original_lang') TranslateLanguage originalLang,
      @JsonKey(name: 'translate_lang') TranslateLanguage translateLang});
}

/// @nodoc
class __$$TranslatedResponseImplCopyWithImpl<$Res>
    extends _$TranslatedResponseCopyWithImpl<$Res, _$TranslatedResponseImpl>
    implements _$$TranslatedResponseImplCopyWith<$Res> {
  __$$TranslatedResponseImplCopyWithImpl(_$TranslatedResponseImpl _value,
      $Res Function(_$TranslatedResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? original = null,
    Object? translated = null,
    Object? example = null,
    Object? exampleTranslated = null,
    Object? type = null,
    Object? originalLang = null,
    Object? translateLang = null,
  }) {
    return _then(_$TranslatedResponseImpl(
      original: null == original
          ? _value.original
          : original // ignore: cast_nullable_to_non_nullable
              as String,
      translated: null == translated
          ? _value._translated
          : translated // ignore: cast_nullable_to_non_nullable
              as List<String>,
      example: null == example
          ? _value.example
          : example // ignore: cast_nullable_to_non_nullable
              as String,
      exampleTranslated: null == exampleTranslated
          ? _value.exampleTranslated
          : exampleTranslated // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TranslatedResponseType,
      originalLang: null == originalLang
          ? _value.originalLang
          : originalLang // ignore: cast_nullable_to_non_nullable
              as TranslateLanguage,
      translateLang: null == translateLang
          ? _value.translateLang
          : translateLang // ignore: cast_nullable_to_non_nullable
              as TranslateLanguage,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TranslatedResponseImpl implements _TranslatedResponse {
  const _$TranslatedResponseImpl(
      {required this.original,
      required final List<String> translated,
      required this.example,
      @JsonKey(name: 'example_translated') required this.exampleTranslated,
      required this.type,
      @JsonKey(name: 'original_lang') required this.originalLang,
      @JsonKey(name: 'translate_lang') required this.translateLang})
      : _translated = translated;

  factory _$TranslatedResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TranslatedResponseImplFromJson(json);

  @override
  final String original;
  final List<String> _translated;
  @override
  List<String> get translated {
    if (_translated is EqualUnmodifiableListView) return _translated;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_translated);
  }

  @override
  final String example;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'example_translated')
  final String exampleTranslated;
  @override
  final TranslatedResponseType type;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'original_lang')
  final TranslateLanguage originalLang;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'translate_lang')
  final TranslateLanguage translateLang;

  @override
  String toString() {
    return 'TranslatedResponse(original: $original, translated: $translated, example: $example, exampleTranslated: $exampleTranslated, type: $type, originalLang: $originalLang, translateLang: $translateLang)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TranslatedResponseImpl &&
            (identical(other.original, original) ||
                other.original == original) &&
            const DeepCollectionEquality()
                .equals(other._translated, _translated) &&
            (identical(other.example, example) || other.example == example) &&
            (identical(other.exampleTranslated, exampleTranslated) ||
                other.exampleTranslated == exampleTranslated) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.originalLang, originalLang) ||
                other.originalLang == originalLang) &&
            (identical(other.translateLang, translateLang) ||
                other.translateLang == translateLang));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      original,
      const DeepCollectionEquality().hash(_translated),
      example,
      exampleTranslated,
      type,
      originalLang,
      translateLang);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TranslatedResponseImplCopyWith<_$TranslatedResponseImpl> get copyWith =>
      __$$TranslatedResponseImplCopyWithImpl<_$TranslatedResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TranslatedResponseImplToJson(
      this,
    );
  }
}

abstract class _TranslatedResponse implements TranslatedResponse {
  const factory _TranslatedResponse(
          {required final String original,
          required final List<String> translated,
          required final String example,
          @JsonKey(name: 'example_translated')
          required final String exampleTranslated,
          required final TranslatedResponseType type,
          @JsonKey(name: 'original_lang')
          required final TranslateLanguage originalLang,
          @JsonKey(name: 'translate_lang')
          required final TranslateLanguage translateLang}) =
      _$TranslatedResponseImpl;

  factory _TranslatedResponse.fromJson(Map<String, dynamic> json) =
      _$TranslatedResponseImpl.fromJson;

  @override
  String get original;
  @override
  List<String> get translated;
  @override
  String get example;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'example_translated')
  String get exampleTranslated;
  @override
  TranslatedResponseType get type;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'original_lang')
  TranslateLanguage get originalLang;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'translate_lang')
  TranslateLanguage get translateLang;
  @override
  @JsonKey(ignore: true)
  _$$TranslatedResponseImplCopyWith<_$TranslatedResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

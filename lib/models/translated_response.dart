import 'package:freezed_annotation/freezed_annotation.dart';

part 'translated_response.freezed.dart';
part 'translated_response.g.dart';

@freezed
class TranslatedResponse with _$TranslatedResponse {
  const factory TranslatedResponse({
    @JsonKey(name: 'source_language') required String sourceLanguage,
    @JsonKey(name: 'target_language') required String targetLanguage,
    required String original,
    required List<String> translated,
    required String example,
    @JsonKey(name: 'example_translated') required String exampleTranslated,
    String? suggestion,
  }) = _TranslatedResponse;

  factory TranslatedResponse.fromJson(Map<String, dynamic> json) =>
      _$TranslatedResponseFromJson(json);
}

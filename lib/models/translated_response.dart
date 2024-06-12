import 'package:freezed_annotation/freezed_annotation.dart';

part 'translated_response.freezed.dart';
part 'translated_response.g.dart';

enum TranslatedResponseType {
  translated,
  suggestion,
}

@freezed
class TranslatedResponse with _$TranslatedResponse {
  const factory TranslatedResponse({
    required String original,
    required List<String> translated,
    required String example,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'example_translated') required String exampleTranslated,
    required TranslatedResponseType type,
  }) = _TranslatedResponse;

  factory TranslatedResponse.fromJson(Map<String, dynamic> json) =>
      _$TranslatedResponseFromJson(json);
}

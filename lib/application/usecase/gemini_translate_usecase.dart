import 'dart:convert';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:worbbing/env/env.dart';
import 'package:worbbing/models/translated_response.dart';

class Gemini {
  final apiKey = Env.geminiApiKey;

  Future<TranslatedResponse?> translateWithGemini(String inputWord) async {
    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
    final prompt =
        '''下記のjsonフォーマットで"$inputWord"（対象の単語）をEnglish->Japaneseに翻訳してください。
        "$inputWord"が"source_language"で存在しない単語の場合は、"input"の"translated","example"は"-"となり、"suggestion"の"translated","example"が必須となる。
        "input"->"$inputWord"がoriginalとなる。
        "translated"->originalを"target_language"で翻訳した3つの単語（翻訳出来ない場合は、"-"）。
        "example"->originalを必ず使用した簡単な例文。（originalが存在しない単語の場合は、"-"）
        "example_translated"->exampleの翻訳（exampleが"-"の場合は、"-"）。
        "suggestion"->"$inputWord"が存在しない単語の場合、または、"$inputWord"にスペルミスの可能性がある場合は、"suggestion"を出力する。"$inputWord"にスペルミスが無いと判断した場合は"suggestion":nullとする。"suggestion"の"original"は"$inputWord"から似たスペルの単語を"original"とする
{
  "input": {
    "source_language": "English",
    "target_language": "Japanese",
    "original": "rekuest",
    "translated": [
      "-",
      "-",
      "-"
    ],
    "example": "-",
    "example_translated": "-"
  },
  "suggestion": {
    "source_language": "English",
    "target_language": "Japanese",
    "original": "request",
    "translated": [
      "リクエスト",
      "依頼",
      "質問"
    ],
    "example": "I have a request to make.",
    "example_translated": "お願いがあります。"
  }
}
''';

    final content = [
      Content.text(prompt),
    ];

    final response = await model.generateContent(content);
    if (response.text == null) {
      throw Exception('Failed to translate : response is null');
    }
    print(response.text);
    try {
      final translatedResponse =
          TranslatedResponse.fromJson(jsonDecode(response.text!)["input"]);
      return translatedResponse;
    } catch (e) {
      throw Exception('Failed to translate : $e');
    }
  }

  /// no use
  Future<String?> getTextWithImage(String prompt, Uint8List image) async {
    final model = GenerativeModel(
      model: 'gemini-pro-vision',
      apiKey: apiKey,
    );

    final textPart = TextPart(prompt);
    final dataPart = DataPart('image/png', image);
    final content = [
      Content.multi([textPart, dataPart])
    ];

    final response = await model.generateContent(content);
    return response.text;
  }
}

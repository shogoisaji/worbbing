import 'package:dio/dio.dart';
import 'package:worbbing/env/env.dart';

class TranslateApi {
  static Future<Map<String, dynamic>> postRequest(String text,
      String originalLang, String translateLang, String appLang) async {
    final response = await Dio().post(
      'https://worbbing-api.simacsimac9.workers.dev/api/translate',
      data: {
        'word': text,
        'originalLang': originalLang,
        'translateLang': translateLang,
        'appLang': appLang,
      },
      options: Options(headers: {'X-API-Key': Env.xApiKey}),
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to translate');
    }
  }
}

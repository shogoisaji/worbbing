import 'package:dio/dio.dart';
import 'package:worbbing/core/exceptions/registration_page_exception.dart';
import 'package:worbbing/env/env.dart';

class TranslateApi {
  static Future<Map<String, dynamic>> postRequest(String text,
      String originalLang, String translateLang, String appLang) async {
    try {
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
      {
        if (response.data["type"] == "failed") {
          print(response.data["comment"]);
          throw TranslateException(response.data["comment"]);
        }
      }
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 502) {
        print(e.response?.data['error']);
        throw TranslateException(e.response?.data['error'] ?? 'SAFETY error');
      } else {
        throw TranslateException(null);
      }
    }
  }
}

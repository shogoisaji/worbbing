import 'package:dio/dio.dart';
import 'package:worbbing/env/env.dart';

class TranslateApi {
  static Future<Map<String, dynamic>> postRequest(String text) async {
    final response = await Dio().post(
      'https://worbbing-api.simacsimac9.workers.dev/api/translate',
      data: {
        'word': text,
      },
      options: Options(headers: {'X-API-Key': Env.xApiKey}),
    );
    return response.data;
  }
}

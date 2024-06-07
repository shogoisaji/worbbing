import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'TRANSLATION_API_KEY', obfuscate: true)
  static String translationApiKey = _Env.translationApiKey;
}

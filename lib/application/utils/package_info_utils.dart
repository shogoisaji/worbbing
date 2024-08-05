import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'package_info_utils.g.dart';

@Riverpod(keepAlive: true)
PackageInfoUtils packageInfoUtils(PackageInfoUtilsRef ref) {
  throw UnimplementedError();
}

class PackageInfoUtils {
  PackageInfoUtils(this._packageInfo);

  final PackageInfo _packageInfo;
  String get appName => _packageInfo.appName;
  String get appVersion => _packageInfo.version;
  String get packageName => _packageInfo.packageName;
  String get buildNumber => _packageInfo.buildNumber;
}

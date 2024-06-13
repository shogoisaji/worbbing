/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/account.png
  AssetGenImage get account => const AssetGenImage('assets/images/account.png');

  /// File path: assets/images/config.png
  AssetGenImage get config => const AssetGenImage('assets/images/config.png');

  /// File path: assets/images/custom_arrow.png
  AssetGenImage get customArrow =>
      const AssetGenImage('assets/images/custom_arrow.png');

  /// File path: assets/images/deepL.png
  AssetGenImage get deepL => const AssetGenImage('assets/images/deepL.png');

  /// File path: assets/images/detail.png
  AssetGenImage get detail => const AssetGenImage('assets/images/detail.png');

  /// File path: assets/images/ebbinghaus.png
  AssetGenImage get ebbinghaus =>
      const AssetGenImage('assets/images/ebbinghaus.png');

  /// File path: assets/images/google_translate.png
  AssetGenImage get googleTranslate =>
      const AssetGenImage('assets/images/google_translate.png');

  /// File path: assets/images/notice.png
  AssetGenImage get notice => const AssetGenImage('assets/images/notice.png');

  /// File path: assets/images/registration.png
  AssetGenImage get registration =>
      const AssetGenImage('assets/images/registration.png');

  /// File path: assets/images/settings.png
  AssetGenImage get settings =>
      const AssetGenImage('assets/images/settings.png');

  /// File path: assets/images/spacedRepetition.png
  AssetGenImage get spacedRepetition =>
      const AssetGenImage('assets/images/spacedRepetition.png');

  /// File path: assets/images/translate.png
  AssetGenImage get translate =>
      const AssetGenImage('assets/images/translate.png');

  /// File path: assets/images/translate_a.png
  AssetGenImage get translateA =>
      const AssetGenImage('assets/images/translate_a.png');

  /// File path: assets/images/worbbing_icon_android.png
  AssetGenImage get worbbingIconAndroid =>
      const AssetGenImage('assets/images/worbbing_icon_android.png');

  /// File path: assets/images/worbbing_icon_ios.png
  AssetGenImage get worbbingIconIos =>
      const AssetGenImage('assets/images/worbbing_icon_ios.png');

  /// File path: assets/images/worbbing_icon_ios_2.png
  AssetGenImage get worbbingIconIos2 =>
      const AssetGenImage('assets/images/worbbing_icon_ios_2.png');

  /// File path: assets/images/worbbing_logo.png
  AssetGenImage get worbbingLogo =>
      const AssetGenImage('assets/images/worbbing_logo.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        account,
        config,
        customArrow,
        deepL,
        detail,
        ebbinghaus,
        googleTranslate,
        notice,
        registration,
        settings,
        spacedRepetition,
        translate,
        translateA,
        worbbingIconAndroid,
        worbbingIconIos,
        worbbingIconIos2,
        worbbingLogo
      ];
}

class $AssetsLottieGen {
  const $AssetsLottieGen();

  /// File path: assets/lottie/w_loading.json
  String get wLoading => 'assets/lottie/w_loading.json';

  /// List of all assets
  List<String> get values => [wLoading];
}

class $AssetsRiveGen {
  const $AssetsRiveGen();

  /// File path: assets/rive/worbbing.riv
  String get worbbing => 'assets/rive/worbbing.riv';

  /// List of all assets
  List<String> get values => [worbbing];
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/a.svg
  String get a => 'assets/svg/a.svg';

  /// File path: assets/svg/a_j.svg
  String get aJ => 'assets/svg/a_j.svg';

  /// List of all assets
  List<String> get values => [a, aJ];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLottieGen lottie = $AssetsLottieGen();
  static const $AssetsRiveGen rive = $AssetsRiveGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size = null});

  final String _assetName;

  final Size? size;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

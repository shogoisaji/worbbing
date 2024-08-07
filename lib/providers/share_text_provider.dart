import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'share_text_provider.g.dart';

@Riverpod(keepAlive: true)
class ShareText extends _$ShareText {
  @override
  String build() {
    _init();
    return "";
  }

  void _init() {
    FlutterSharingIntent.instance.getInitialSharing().then((value) {
      if (value.isNotEmpty) {
        state = value.first.value!;
      }
    });

    FlutterSharingIntent.instance.getMediaStream().listen((value) {
      if (value.isNotEmpty) {
        state = value.first.value!;
      }
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });
  }

  void reset() {
    state = "";
  }
}

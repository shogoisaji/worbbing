import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'share_text_state.g.dart';

@Riverpod(keepAlive: true)
class ShareTextState extends _$ShareTextState {
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

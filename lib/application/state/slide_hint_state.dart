import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'slide_hint_state.g.dart';

@Riverpod(keepAlive: true)
class SlideHintState extends _$SlideHintState {
  @override
  bool build() => true;

  void setSlideHintState(bool slideHintState) {
    state = slideHintState;
  }
}

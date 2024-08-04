import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_tag_state.g.dart';

@Riverpod(keepAlive: true)
class HomeTagState extends _$HomeTagState {
  @override
  int build() => 0;

  void setTagState(int tagState) {
    state = tagState;
  }
}

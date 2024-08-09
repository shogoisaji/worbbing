import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tag_state_provider.g.dart';

@Riverpod(keepAlive: true)
class TagState extends _$TagState {
  @override
  int build() => 0;

  void setTagState(int tagState) {
    state = tagState;
  }
}

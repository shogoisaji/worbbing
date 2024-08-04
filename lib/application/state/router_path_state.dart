import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router_path_state.g.dart';

@Riverpod(keepAlive: true)
class RouterPathState extends _$RouterPathState {
  @override
  String build() => '/';

  void setPathState(String pathState) {
    state = pathState;
    print('pathState $pathState');
  }
}

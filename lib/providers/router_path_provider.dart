import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router_path_provider.g.dart';

@Riverpod(keepAlive: true)
class RouterPath extends _$RouterPath {
  @override
  String build() => '/';

  void setPathState(String pathState) {
    state = pathState;
    print('pathState $pathState');
  }
}

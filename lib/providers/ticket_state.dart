import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_keys.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_repository.dart';

part 'ticket_state.g.dart';

const int initialTicket = 10;

@Riverpod(keepAlive: true)
class TicketState extends _$TicketState {
  @override
  int build() {
    return ref
            .read(sharedPreferencesRepositoryProvider)
            .fetch<int>(SharedPreferencesKey.ticket) ??
        0;
  }

  Future<void> addInitialTicket() async {
    await ref
        .read(sharedPreferencesRepositoryProvider)
        .save<int>(SharedPreferencesKey.ticket, state + initialTicket);
    state = state + initialTicket;
  }

  Future<void> useTicket() async {
    final currentTicket = ref
            .read(sharedPreferencesRepositoryProvider)
            .fetch<int>(SharedPreferencesKey.ticket) ??
        0;
    if (currentTicket <= 0) {
      return;
    }
    await ref
        .read(sharedPreferencesRepositoryProvider)
        .save<int>(SharedPreferencesKey.ticket, currentTicket - 1);
    state = currentTicket - 1;
  }

  Future<void> earnTicket(int earnTicket) async {
    final currentTicket = ref
            .read(sharedPreferencesRepositoryProvider)
            .fetch<int>(SharedPreferencesKey.ticket) ??
        0;
    final earnedTicket = (currentTicket + earnTicket).clamp(0, 99);
    await ref
        .read(sharedPreferencesRepositoryProvider)
        .save<int>(SharedPreferencesKey.ticket, earnedTicket);
    state = earnedTicket;
  }
}

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_keys.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_repository.dart';

part 'ticket_manager.g.dart';

@riverpod
class TicketManager extends _$TicketManager {
  static const initialTicket = 10;

  @override
  Future<int> build() async {
    return loadTicket();
  }

  int loadTicket() {
    final repository = ref.read(sharedPreferencesRepositoryProvider);
    return repository.fetch<int>(SharedPreferencesKey.ticket) ?? 0;
  }

  Future<void> addInitialTicket() async {
    final repository = ref.read(sharedPreferencesRepositoryProvider);
    final newTicket = state.value! + initialTicket;
    await repository.save<int>(SharedPreferencesKey.ticket, newTicket);
    state = AsyncData(newTicket);
  }

  Future<void> useTicket() async {
    if (state.value! <= 0) return;
    final repository = ref.read(sharedPreferencesRepositoryProvider);
    final newTicket = state.value! - 1;
    await repository.save<int>(SharedPreferencesKey.ticket, newTicket);
    state = AsyncData(newTicket);
  }

  Future<void> earnTicket(int earnTicket) async {
    final repository = ref.read(sharedPreferencesRepositoryProvider);
    final newTicket = (state.value! + earnTicket).clamp(0, 99);
    await repository.save<int>(SharedPreferencesKey.ticket, newTicket);
    state = AsyncData(newTicket);
  }
}

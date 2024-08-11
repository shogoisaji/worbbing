import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_keys.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_repository.dart';

part 'ticket_state.g.dart';

const int initialTicket = 10;
const int dailyTicket = 3;

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

  Future<int?> checkDailyTicket() async {
    final getDayString = ref
        .read(sharedPreferencesRepositoryProvider)
        .fetch<String>(SharedPreferencesKey.ticketGetDate);
    if (getDayString == null) {
      await ref.read(sharedPreferencesRepositoryProvider).save<String>(
          SharedPreferencesKey.ticketGetDate, DateTime.now().toIso8601String());
      await earnTicket(dailyTicket);
      await ref.read(sharedPreferencesRepositoryProvider).save<String>(
          SharedPreferencesKey.ticketGetDate, DateTime.now().toIso8601String());
      return dailyTicket;
    }
    final getDay = DateTime.parse(getDayString);
    final today = DateTime.now();
    if (getDay.day == today.day &&
        getDay.month == today.month &&
        getDay.year == today.year) {
      return null;
    }
    await earnTicket(dailyTicket);
    await ref.read(sharedPreferencesRepositoryProvider).save<String>(
        SharedPreferencesKey.ticketGetDate, DateTime.now().toIso8601String());
    return dailyTicket;
  }
}

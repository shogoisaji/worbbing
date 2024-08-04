import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:worbbing/repository/shared_preferences/shared_preferences_keys.dart';
import 'package:worbbing/repository/shared_preferences/shared_preferences_repository.dart';

part 'ticket_state.g.dart';

const int initialTicket = 10;

@Riverpod(keepAlive: true)
class TicketState extends _$TicketState {
  @override
  int build() {
    loadTicket();
    return state;
  }

  void setTicketState(int ticketState) {
    state = ticketState;
  }

  void loadTicket() {
    final ticket =
        SharedPreferencesRepository().fetch<int>(SharedPreferencesKey.ticket) ??
            0;
    state = ticket;
  }

  void addInitialTicket() async {
    await SharedPreferencesRepository()
        .save<int>(SharedPreferencesKey.ticket, state + initialTicket);
    state = state + initialTicket;
  }

  void useTicket() async {
    final currentTicket =
        SharedPreferencesRepository().fetch<int>(SharedPreferencesKey.ticket) ??
            0;
    if (currentTicket <= 0) {
      return;
    }
    SharedPreferencesRepository()
        .save<int>(SharedPreferencesKey.ticket, currentTicket - 1);
    state = currentTicket - 1;
  }

  void earnTicket(int earnTicket) async {
    final currentTicket =
        SharedPreferencesRepository().fetch<int>(SharedPreferencesKey.ticket) ??
            0;
    final earnedTicket = (currentTicket + earnTicket).clamp(0, 99);
    SharedPreferencesRepository()
        .save<int>(SharedPreferencesKey.ticket, earnedTicket);
    state = earnedTicket;
  }
}

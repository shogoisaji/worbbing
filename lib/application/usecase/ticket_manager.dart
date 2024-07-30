import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:worbbing/application/usecase/app_state_usecase.dart';
import 'package:worbbing/repository/shared_preferences/shared_preferences_keys.dart';
import 'package:worbbing/repository/shared_preferences/shared_preferences_repository.dart';

class TicketManager {
  static const initialTicket = 10;
  static final ValueNotifier<int> ticketNotifier = ValueNotifier<int>(0);

  static Future<void> loadTicket() async {
    final bool isFirst = AppStateUsecase().isFirst();
    // TODO: hint実装時、表示後にfalseにする
    // 初回実行時の処理
    // if (isFirst) {
    //   ticketNotifier.value = initialTicket;

    //   SharedPreferencesRepository()
    //       .save<int>(SharedPreferencesKey.ticket, initialTicket);
    //   return;
    // }
    final ticket =
        SharedPreferencesRepository().fetch<int>(SharedPreferencesKey.ticket) ??
            0;
    ticketNotifier.value = ticket;
  }

  static Future<void> useTicket() async {
    final currentTicket =
        SharedPreferencesRepository().fetch<int>(SharedPreferencesKey.ticket) ??
            0;
    if (currentTicket <= 0) {
      return;
    }
    SharedPreferencesRepository()
        .save<int>(SharedPreferencesKey.ticket, currentTicket - 1);
    ticketNotifier.value = currentTicket - 1;
  }

  static Future<void> earnTicket(int earnTicket) async {
    final currentTicket =
        SharedPreferencesRepository().fetch<int>(SharedPreferencesKey.ticket) ??
            0;
    final earnedTicket = (currentTicket + earnTicket).clamp(0, 99);
    SharedPreferencesRepository()
        .save<int>(SharedPreferencesKey.ticket, earnedTicket);
    ticketNotifier.value = earnedTicket;
  }
}

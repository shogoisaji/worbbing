import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketManager {
  static const initialTicket = 10;
  static final ValueNotifier<int> ticketNotifier = ValueNotifier<int>(0);

  static Future<void> loadTicket() async {
    final prefs = await SharedPreferences.getInstance();
    final getTicketDate = prefs.getString("ticketGetDate") ?? "";
    if (getTicketDate.isEmpty) {
      // 初回実行時の処理
      final today = DateTime.now();
      await prefs.setInt("ticket", initialTicket);
      await prefs.setString("ticketGetDate", today.toIso8601String());
      ticketNotifier.value = initialTicket;
      return;
    }

    final ticket = prefs.getInt("ticket") ?? 0;
    ticketNotifier.value = ticket;
  }

  static Future<void> useTicket() async {
    final prefs = await SharedPreferences.getInstance();
    final currentTicket = prefs.getInt("ticket") ?? 0;
    if (currentTicket <= 0) {
      return;
    }
    await prefs.setInt("ticket", currentTicket - 1);
    ticketNotifier.value = currentTicket - 1;
  }

  static Future<void> earnTicket(int earnTicket) async {
    final prefs = await SharedPreferences.getInstance();
    final currentTicket = prefs.getInt("ticket") ?? 0;
    final earnedTicket = (currentTicket + earnTicket).clamp(0, 99);
    await prefs.setInt("ticket", earnedTicket);
    ticketNotifier.value = earnedTicket;
  }
}

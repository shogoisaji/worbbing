import 'package:shared_preferences/shared_preferences.dart';

class TicketManager {
  static const dailyTicket = 10;

  static Future<int> loadTicket() async {
    final prefs = await SharedPreferences.getInstance();
    final getTicketDate = prefs.getString("ticketGetDate") ?? "";
    if (getTicketDate.isEmpty) {
      // 初回実行時の処理
      final today = DateTime.now();
      await prefs.setInt("ticket", dailyTicket);
      await prefs.setString("ticketGetDate", today.toIso8601String());
      return dailyTicket;
    }

    final getDate = DateTime.parse(getTicketDate);
    final today = DateTime.now();
    final diff = today.difference(getDate).inDays;

    if (diff != 0) {
      await prefs.setInt("ticket", dailyTicket);
      await prefs.setString("ticketGetDate", today.toIso8601String());
      return dailyTicket;
    } else {
      return prefs.getInt("ticket") ?? 0;
    }
  }

  static Future<int> useTicket() async {
    final prefs = await SharedPreferences.getInstance();
    final currentTicket = prefs.getInt("ticket") ?? 0;
    if (currentTicket <= 0) {
      return 0;
    }
    await prefs.setInt("ticket", currentTicket - 1);
    return currentTicket - 1;
  }

  static Future<void> earnTicket(int earnTicket) async {
    final prefs = await SharedPreferences.getInstance();
    final currentTicket = prefs.getInt("ticket") ?? 0;
    final earnedTicket = (currentTicket + earnTicket).clamp(0, 99);
    await prefs.setInt("ticket", earnedTicket);
  }
}

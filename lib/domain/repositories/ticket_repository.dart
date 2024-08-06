abstract class TicketRepository {
  Future<void> useTicket();
  Future<void> earnTicket(int count);
}

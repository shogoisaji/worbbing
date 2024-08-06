import 'package:worbbing/domain/repositories/ticket_repository.dart';

class EarnTicketUsecase {
  final TicketRepository ticketRepository;

  EarnTicketUsecase(this.ticketRepository);

  Future<void> execute(int count) async {
    print('EarnTicketUsecase');
    await ticketRepository.earnTicket(count);
  }
}

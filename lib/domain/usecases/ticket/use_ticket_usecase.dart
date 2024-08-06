import 'package:worbbing/domain/repositories/ticket_repository.dart';

class UseTicketUsecase {
  final TicketRepository ticketRepository;

  UseTicketUsecase(this.ticketRepository);

  Future<void> execute() async {
    await ticketRepository.useTicket();
  }
}

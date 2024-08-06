import 'package:worbbing/domain/repositories/ticket_repository.dart';

class AddInitialTicketUsecase {
  final TicketRepository ticketRepository;

  AddInitialTicketUsecase(this.ticketRepository);

  Future<void> execute() async {
    await ticketRepository.addInitialTicket();
  }
}

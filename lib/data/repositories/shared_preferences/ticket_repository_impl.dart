import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:worbbing/core/constants/ticket_constans.dart';
import 'package:worbbing/domain/repositories/ticket_repository.dart';
import 'package:worbbing/repository/shared_preferences/shared_preferences_keys.dart';
import 'package:worbbing/repository/shared_preferences/shared_preferences_repository.dart';

part 'ticket_repository_impl.g.dart';

@Riverpod(keepAlive: true)
TicketRepositoryImpl ticketRepositoryImpl(TicketRepositoryImplRef ref) {
  throw UnimplementedError();
}

class TicketRepositoryImpl extends TicketRepository {
  final SharedPreferencesRepository _sharedPreferencesRepository;

  TicketRepositoryImpl(this._sharedPreferencesRepository);

  @override
  Future<void> earnTicket(int count) async {
    final ticket =
        await _sharedPreferencesRepository.fetch(SharedPreferencesKey.ticket);
    await _sharedPreferencesRepository.save(
        SharedPreferencesKey.ticket, ticket + count);
  }

  @override
  Future<void> useTicket() async {
    final ticket =
        await _sharedPreferencesRepository.fetch(SharedPreferencesKey.ticket);
    await _sharedPreferencesRepository.save(
        SharedPreferencesKey.ticket, ticket - 1);
  }
}

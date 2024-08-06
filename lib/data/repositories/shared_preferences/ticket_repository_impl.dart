import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:worbbing/core/constants/ticket_constants.dart';
import 'package:worbbing/domain/repositories/ticket_repository.dart';
import 'package:worbbing/repository/shared_preferences/shared_preferences_keys.dart';
import 'package:worbbing/repository/shared_preferences/shared_preferences_repository.dart';

part 'ticket_repository_impl.g.dart';

@Riverpod(keepAlive: true)
TicketRepositoryImpl ticketRepositoryImpl(TicketRepositoryImplRef ref) {
  return TicketRepositoryImpl(ref.watch(sharedPreferencesRepositoryProvider));
}

class TicketRepositoryImpl extends TicketRepository {
  final SharedPreferencesRepository _sharedPreferencesRepository;

  TicketRepositoryImpl(this._sharedPreferencesRepository);

  @override
  Future<void> addInitialTicket() async {
    final ticket =
        await _sharedPreferencesRepository.fetch(SharedPreferencesKey.ticket);
    await _sharedPreferencesRepository.save(
        SharedPreferencesKey.ticket, ticket + TicketConstants.initialTicket);
  }

  @override
  Future<void> earnTicket(int count) async {
    final ticket =
        _sharedPreferencesRepository.fetch<int>(SharedPreferencesKey.ticket) ??
            0;
    await _sharedPreferencesRepository.save(
        SharedPreferencesKey.ticket, ticket + count);
  }

  @override
  Future<void> useTicket() async {
    final ticket =
        _sharedPreferencesRepository.fetch<int>(SharedPreferencesKey.ticket) ??
            0;
    if (ticket <= 0) return;
    await _sharedPreferencesRepository.save(
        SharedPreferencesKey.ticket, ticket - 1);
  }
}

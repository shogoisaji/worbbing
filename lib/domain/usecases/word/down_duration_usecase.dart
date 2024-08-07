import 'package:worbbing/domain/entities/word_model.dart';
import 'package:worbbing/domain/repositories/word_list_repository.dart';
import 'package:worbbing/domain/usecases/word/update_word_usecase.dart';

class DownDurationUsecase {
  final WordListRepository wordListRepository;

  DownDurationUsecase(this.wordListRepository);

  Future<void> execute(WordModel wordModel) async {
    final updatedWordModel = wordModel.downNoticeDuration();
    await UpdateWordUsecase(wordListRepository).execute(updatedWordModel);
  }
}

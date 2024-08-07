import 'package:worbbing/domain/repositories/word_list_repository.dart';
import 'package:worbbing/domain/usecases/word/update_word_usecase.dart';
import 'package:worbbing/models/word_model.dart';

class UpDurationUsecase {
  final WordListRepository wordListRepository;

  UpDurationUsecase(this.wordListRepository);

  Future<void> execute(WordModel wordModel) async {
    final updatedWordModel = wordModel.upNoticeDuration();
    await UpdateWordUsecase(wordListRepository).execute(updatedWordModel);
  }
}

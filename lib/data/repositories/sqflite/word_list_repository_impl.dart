import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'package:worbbing/core/exceptions/database_exception.dart';
import 'package:worbbing/domain/repositories/word_list_repository.dart';
import 'package:worbbing/domain/entities/translate_language.dart';
import 'package:worbbing/models/word_model.dart';

part 'word_list_repository_impl.g.dart';

@riverpod
WordListRepositoryImpl wordListRepositoryImpl(WordListRepositoryImplRef ref) {
  throw UnimplementedError();
}

class WordListRepositoryImpl implements WordListRepository {
  static const _databaseName = "Words_Database.db";
  static const _databaseVersion = 1;

  static const table = 'data_table';
  static const columnId = 'id';
  static const noticeDuration = 'notice_duration';
  static const updateCount = 'update_count';
  static const flag = 'flag';
  static const originalWord = 'original_word';
  static const translatedWord = 'translated_word';
  static const updateDate = 'update_date';
  static const registrationDate = 'registration_date';
  static const example = 'example';
  static const exampleTranslated = 'example_translated';
  static const originalLang = 'original_lang';
  static const translatedLang = 'translated_lang';

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId TEXT PRIMARY KEY,
            $noticeDuration INTEGER,
            $updateCount INTEGER,
            $flag INTEGER,
            $originalWord TEXT,
            $translatedWord TEXT,
            $updateDate TEXT,
            $registrationDate TEXT,
            $example TEXT,
            $exampleTranslated TEXT,
            $originalLang TEXT,
            $translatedLang TEXT
          )
          ''');

    // シードデータの挿入
    await _seedData(db);
  }

  Future<void> _seedData(Database db) async {
    final sampleWord1 = WordModel(
      id: const Uuid().v4(),
      noticeDuration: 7,
      updateCount: 0,
      flag: false,
      originalWord: "sample",
      translatedWord: "サンプル",
      example: "This is a sample sentence.",
      exampleTranslated: "これはサンプル文です。",
      originalLang: TranslateLanguage.english,
      translatedLang: TranslateLanguage.japanese,
      updateDate: DateTime.now().subtract(const Duration(days: 10)),
      registrationDate: DateTime.now().subtract(const Duration(days: 10)),
    );
    await db.insert(table, sampleWord1.toJson());
    final sampleWord2 = WordModel(
      id: const Uuid().v4(),
      noticeDuration: 1,
      updateCount: 0,
      flag: true,
      originalWord: "notice",
      translatedWord: "通知",
      example: "This app has a notification feature.",
      exampleTranslated: "このアプリは通知機能を備えています",
      originalLang: TranslateLanguage.english,
      translatedLang: TranslateLanguage.japanese,
      updateDate: DateTime.now(),
      registrationDate: DateTime.now(),
    );
    await db.insert(table, sampleWord2.toJson());
  }

  @override
  Future<String?> addWord(WordModel wordModel) async {
    Database db = await database;

    /// check duplicate
    final maps = await db.query(
      table,
      columns: [columnId],
      where: '$originalWord = ?',
      whereArgs: [wordModel.originalWord],
    );
    if (maps.isNotEmpty) {
      throw DuplicateItemException(wordModel.originalWord);
    }

    final row = wordModel.toJson();

    await db.insert(table, row).catchError((e) {
      throw Exception('sqflite error: $e');
    });
    return null;
  }

  @override
  Future<List<WordModel>> getWordList(
      {String? orderBy, bool isDesc = true, bool isFlag = false}) async {
    final db = await database;
    final dataList = await db.query(table,
        where: isFlag ? '$flag = ?' : null,
        whereArgs: isFlag ? [1] : null,
        orderBy: '$orderBy ?? $registrationDate ${isDesc ? 'DESC' : 'ASC'}');
    return dataList.map((e) => WordModel.fromJson(e)).toList();
  }

  @override
  Future<WordModel> getWordById(String id) async {
    Database db = await database;
    final data = await db.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    return WordModel.fromJson(data.first);
  }

  @override
  Future<void> deleteWord(String id) async {
    Database db = await database;
    await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    ).catchError((e) {
      throw Exception('sqflite error: $e');
    });
  }

  @override
  Future<void> updateWord(WordModel wordModel) async {
    Database db = await database;
    await db
        .update(
      table,
      {
        originalWord: wordModel.originalWord,
        translatedWord: wordModel.translatedWord,
        example: wordModel.example,
        exampleTranslated: wordModel.exampleTranslated,
        updateDate: wordModel.updateDate,
        originalLang: wordModel.originalLang,
        translatedLang: wordModel.translatedLang,
        updateCount: wordModel.updateCount,
        flag: wordModel.flag ? 1 : 0,
        noticeDuration: wordModel.noticeDuration,
      },
      where: '$columnId = ?',
      whereArgs: [wordModel.id],
    )
        .catchError((e) {
      throw Exception('sqflite error: $e');
    });
  }

  @override
  Future<int> getTotalWords() async {
    Database db = await database;
    final List<Map<String, Object?>> result = await db.query(
      table,
      columns: ['COUNT(*) AS count'],
    );
    return result.first['count'] as int;
  }

  @override
  Future<Map<int, int>> countByNotices() async {
    Database db = await database;
    final List<Map<String, Object?>> result = await db.query(table,
        columns: [noticeDuration, 'COUNT(*) AS count'],
        groupBy: noticeDuration);

    Map<int, int> noticeCounts = {};
    for (var row in result) {
      noticeCounts[row[noticeDuration] as int] = row['count'] as int;
    }
    return noticeCounts;
  }

  @override
  Future<WordModel> getRandomWord() async {
    final db = await database;
    String query = "SELECT * FROM $table ORDER BY RANDOM() LIMIT 1";
    Map<String, Object?> result =
        await db.rawQuery(query).then((value) => value.first);
    return WordModel.fromJson(result);
  }
}

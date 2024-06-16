import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'package:worbbing/models/translate_language.dart';
import 'package:worbbing/models/word_model.dart';

class SqfliteRepository {
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

  SqfliteRepository._privateConstructor();
  static final SqfliteRepository instance =
      SqfliteRepository._privateConstructor();

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
      updateDate: DateTime(2024, 1, 1),
      registrationDate: DateTime(2024, 1, 1),
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

  /// insert database row
  Future<String?> insertData(WordModel wordModel) async {
    Database db = await instance.database;

    /// 重複チェック
    final maps = await db.query(
      table,
      columns: [columnId],
      where: '$originalWord = ?',
      whereArgs: [wordModel.originalWord],
    );
    if (maps.isNotEmpty) {
      return 'exist';
    }

    final row = wordModel.toJson();

    await db.insert(table, row).catchError((e) {
      throw Exception('sqflite error: $e');
    });
    return null;
  }

// get database
  Future<List<WordModel>> queryAllRows({bool isDesc = true}) async {
    Database db = await instance.database;
    final dataList = await db.query(table,
        orderBy:
            '${SqfliteRepository.registrationDate} ${isDesc ? 'DESC' : 'ASC'}');
    return dataList.map((e) => WordModel.fromJson(e)).toList();
  }

  // get database alphabet sort
  Future<List<WordModel>> queryAllRowsAlphabet() async {
    Database db = await instance.database;
    final dataList =
        await db.query(table, orderBy: '${SqfliteRepository.originalWord} ASC');
    return dataList.map((e) => WordModel.fromJson(e)).toList();
  }

// get database noticeDuration sort
  Future<List<WordModel>> queryAllRowsNoticeDuration() async {
    Database db = await instance.database;
    final dataList = await db.query(table,
        orderBy:
            '${SqfliteRepository.noticeDuration} ASC,${SqfliteRepository.registrationDate} DESC');
    return dataList.map((e) => WordModel.fromJson(e)).toList();
  }

// get database registration sort
  Future<List<WordModel>> queryAllRowsRegistration() async {
    Database db = await instance.database;
    final dataList = await db.query(table,
        orderBy: '${SqfliteRepository.registrationDate} DESC');
    return dataList.map((e) => WordModel.fromJson(e)).toList();
  }

// get database flag is 1
  Future<List<WordModel>> queryAllRowsFlag() async {
    Database db = await instance.database;
    final dataList = await db.query(table,
        orderBy: '${SqfliteRepository.noticeDuration} ASC',
        where: "$flag = ?",
        whereArgs: [1]);
    return dataList.map((e) => WordModel.fromJson(e)).toList();
  }

// get Row
  Future<WordModel> queryRows(String id) async {
    Database db = await instance.database;
    final data = await db.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    return WordModel.fromJson(data.first);
  }

// delete row
  Future<void> deleteRow(String id) async {
    Database db = await instance.database;
    await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    ).catchError((e) {
      throw Exception('sqflite error: $e');
    });
  }

  // count up duration
  Future<void> upDuration(String id) async {
    Database db = await instance.database;
    final res = await db.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    final wordModel = WordModel.fromJson(res.first);
    final updateWordModel = wordModel.upNoticeDuration();
    final row = updateWordModel.toJson();

    await db.update(
      table,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    ).catchError((e) {
      throw Exception('sqflite error: $e');
    });
  }

  Future<void> downDuration(String id) async {
    Database db = await instance.database;
    final res = await db.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    final wordModel = WordModel.fromJson(res.first);
    final updateWordModel = wordModel.downNoticeDuration();
    final row = updateWordModel.toJson();

    await db.update(
      table,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    ).catchError((e) {
      throw Exception('sqflite error: $e');
    });
  }

  // update flag
  Future<void> updateFlag(String id, bool flagState) async {
    Database db = await instance.database;
    await db
        .update(
      table,
      {
        flag: flagState ? 1 : 0,
      },
      where: '$columnId = ?',
      whereArgs: [id],
    )
        .catchError((e) {
      throw Exception('sqflite error: $e');
    });
  }

  // update original,translated,memo
  Future<void> updateWords(String id, String newOriginal, String newTranslated,
      String newExample, String newExampleTranslated) async {
    Database db = await instance.database;
    await db
        .update(
      table,
      {
        originalWord: newOriginal,
        translatedWord: newTranslated,
        example: newExample,
        exampleTranslated: newExampleTranslated,
      },
      where: '$columnId = ?',
      whereArgs: [id],
    )
        .catchError((e) {
      throw Exception('sqflite error: $e');
    });
  }

  // total words
  Future<int> totalWords() async {
    Database db = await instance.database;
    final List<Map<String, Object?>> result = await db.query(
      table,
      columns: ['COUNT(*) AS count'],
    );
    return result.first['count'] as int;
  }

  // Total by noticeDuration
  Future<Map<int, int>> countNoticeDuration() async {
    Database db = await instance.database;
    final List<Map<String, Object?>> result = await db.query(table,
        columns: [noticeDuration, 'COUNT(*) AS count'],
        groupBy: noticeDuration);

    Map<int, int> noticeCounts = {};
    for (var row in result) {
      noticeCounts[row[noticeDuration] as int] = row['count'] as int;
    }
    return noticeCounts;
  }

// notification words get random words
  Future<List<WordModel>> getRandomWords(int count) async {
    final db = await database;
    String query = "SELECT * FROM $table ORDER BY RANDOM() LIMIT $count";
    List<Map<String, Object?>> result = await db.rawQuery(query);
    return result.map((e) => WordModel.fromJson(e)).toList();
  }
}

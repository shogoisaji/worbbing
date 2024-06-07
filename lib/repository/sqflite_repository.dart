import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:worbbing/models/word_model.dart';

class SqfliteRepository {
  static const _databaseName = "test1_Database.db";
  static const _databaseVersion = 1;

  static const table = 'data_table';
  static const columnId = 'id';
  static const noticeDuration = 'duration';
  static const updateCount = 'count';
  static const flag = 'flag';
  static const originalWord = 'original';
  static const translatedWord = 'translated';
  static const updateDate = 'date';
  static const registrationDate = 'registration';
  static const memo = 'memo';

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
            $memo TEXT
          )
          ''');
  }

  /// insert database row
  Future<void> insertData(WordModel wordModel) async {
    final row = wordModel.toJson();
    Database db = await instance.database;

    await db.insert(table, row).catchError((e) {
      throw Exception('sqflite error: $e');
    });
  }
  // Future<String> addData(List<dynamic> addData) async {
  //   // final int _noticeDuration = 2;
  //   final int noticeDuration = addData[0];
  //   final int updateCount = addData[1];
  //   final int flag = addData[2];
  //   final String originalWord = addData[3];
  //   final String translatedWord = addData[4];
  //   // final String _updateDate = "2023-08-20T06:00:00.000Z";
  //   final String updateDate = addData[5];
  //   final String registrationDate = addData[6];
  //   final String memo = addData[7];

  //   final row = {
  //     SqfliteRepository.noticeDuration: noticeDuration,
  //     SqfliteRepository.updateCount: updateCount,
  //     SqfliteRepository.flag: flag,
  //     SqfliteRepository.originalWord: originalWord,
  //     SqfliteRepository.translatedWord: translatedWord,
  //     SqfliteRepository.updateDate: updateDate,
  //     SqfliteRepository.registrationDate: registrationDate,
  //     SqfliteRepository.memo: memo,
  //   };

  //   Database db = await instance.database;

  //   final maps = await db.query(
  //     table,
  //     columns: [columnId],
  //     where: '$originalWord = ?',
  //     whereArgs: [originalWord],
  //   );

  //   if (maps.isNotEmpty) {
  //     return 'exist';
  //   }

  //   final id = await db.insert(table, row);

  //   debugPrint('挿入された行のid: $id');
  //   debugPrint(
  //       '挿入されたデータ: \n$noticeDuration \n$updateCount \n$flag \n$originalWord \n$translatedWord \n$updateDate \n$registrationDate \n$memo');

  //   return 'success';
  // }

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
      String newMemo) async {
    Database db = await instance.database;
    await db
        .update(
      table,
      {
        originalWord: newOriginal,
        translatedWord: newTranslated,
        memo: newMemo,
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
    String query =
        "SELECT $originalWord, $translatedWord FROM $table ORDER BY RANDOM() LIMIT $count";
    List<Map<String, Object?>> result = await db.rawQuery(query);
    return result.map((e) => WordModel.fromJson(e)).toList();
  }
}

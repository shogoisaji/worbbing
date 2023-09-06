import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:worbbing/application/date_format.dart';
import 'package:worbbing/models/notice_model.dart';

class DatabaseHelper {
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

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

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
            $columnId INTEGER PRIMARY KEY,
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

  // add database row
  Future<String> addData(List<dynamic> addData) async {
    final int _noticeDuration = addData[0];
    final int _updateCount = addData[1];
    final int _flag = addData[2];
    final String _originalWord = addData[3];
    final String _translatedWord = addData[4];
    final String _updateDate = addData[5];
    final String _registrationDate = addData[6];
    final String _memo = addData[7];

    final row = {
      DatabaseHelper.noticeDuration: _noticeDuration,
      DatabaseHelper.updateCount: _updateCount,
      DatabaseHelper.flag: _flag,
      DatabaseHelper.originalWord: _originalWord,
      DatabaseHelper.translatedWord: _translatedWord,
      DatabaseHelper.updateDate: _updateDate,
      DatabaseHelper.registrationDate: _registrationDate,
      DatabaseHelper.memo: _memo,
    };

    Database db = await instance.database;

    final maps = await db.query(
      table,
      columns: [columnId],
      where: '$originalWord = ?',
      whereArgs: [_originalWord],
    );

    if (maps.isNotEmpty) {
      return 'exist';
    }

    final id = await db.insert(table, row);

    debugPrint('挿入された行のid: $id');
    debugPrint(
        '挿入されたデータ: \n$_noticeDuration \n$_updateCount \n$_flag \n$_originalWord \n$_translatedWord \n$_updateDate \n$_registrationDate \n$_memo');

    return 'success';
  }

// get database
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // get database alphabet sort
  Future<List<Map<String, dynamic>>> queryAllRowsAlphabet() async {
    Database db = await instance.database;

    return await db.query(table, orderBy: '${DatabaseHelper.originalWord} ASC');
  }

// get database noticeDuration sort
  Future<List<Map<String, dynamic>>> queryAllRowsNoticeDuration() async {
    Database db = await instance.database;
    return await db.query(table,
        orderBy:
            '${DatabaseHelper.noticeDuration} ASC,${DatabaseHelper.registrationDate} DESC');
  }

// get database registration sort
  Future<List<Map<String, dynamic>>> queryAllRowsRegistration() async {
    Database db = await instance.database;
    return await db.query(table,
        orderBy: '${DatabaseHelper.registrationDate} DESC');
  }

// get datebase flag is 1
  Future<List<Map<String, dynamic>>> queryAllRowsFlag() async {
    Database db = await instance.database;
    return await db.query(table,
        orderBy: '${DatabaseHelper.noticeDuration} ASC',
        where: "$flag = ?",
        whereArgs: [1]);
  }

// get Row
  Future<List<Map<String, dynamic>>> queryRows(int id) async {
    Database db = await instance.database;
    return await db.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

// delete row
  Future<int> deleteRow(int id) async {
    Database db = await instance.database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // count up duration
  Future<int> updateNoticeUp(int id) async {
    NoticeModel noticeModel = NoticeModel();
    final String currentDate = getCurrentDate();
    Database db = await instance.database;
    List<Map<String, dynamic>> queryResult = await db.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    int currentCount = queryResult.first['count'];
    int currentDuration = queryResult.first['duration'];
    int updateDuration = currentDuration < noticeModel.noticeDuration.length - 1
        ? currentDuration + 1
        : currentDuration;
    debugPrint('currentDuration変更: $currentDuration');
    debugPrint('noticeDuration変更: $updateDuration');

    return await db.update(
      table,
      {
        noticeDuration: updateDuration,
        updateCount: currentCount + 1,
        updateDate: currentDate
      },
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // count down duration
  Future<int> updateNoticeDown(int id) async {
    final String currentDate = getCurrentDate();
    Database db = await instance.database;
    List<Map<String, dynamic>> queryResult = await db.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    int currentCount = queryResult.first['count'];
    int currentDuration = queryResult.first['duration'];
    int updateDuration = currentDuration != 0 ? currentDuration - 1 : 0;
    debugPrint('currentDuration変更: $currentDuration');
    debugPrint('noticeDuration変更: $updateDuration');

    return await db.update(
      table,
      {
        noticeDuration: updateDuration,
        updateCount: currentCount + 1,
        updateDate: currentDate
      },
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // update flag
  Future<int> updateFlag(int id, int flagState) async {
    Database db = await instance.database;
    debugPrint('flag変更: $flagState');
    return await db.update(
      table,
      {
        flag: flagState,
      },
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // update original,translated,memo
  Future<int> updateWords(
      int id, String newOriginal, String newTranslated, String newMemo) async {
    Database db = await instance.database;
    debugPrint('Words変更: $newOriginal, $newTranslated, $newMemo}');
    return await db.update(
      table,
      {
        originalWord: newOriginal,
        translatedWord: newTranslated,
        memo: newMemo,
      },
      where: '$columnId = ?',
      whereArgs: [id],
    );
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

// notificaton words get random words
  Future<List<Map>> getRandomWords(int num) async {
    final db = await database;
    String query =
        "SELECT $originalWord, $translatedWord FROM $table ORDER BY RANDOM() LIMIT $num";
    List<Map> result = await db.rawQuery(query);
    return result;
  }
}

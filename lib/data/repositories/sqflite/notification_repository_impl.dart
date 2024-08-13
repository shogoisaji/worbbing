import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:worbbing/domain/entities/notice_data_model.dart';
import 'package:worbbing/domain/repositories/notification_repository.dart';

part 'notification_repository_impl.g.dart';

@riverpod
NotificationRepository notificationRepository(NotificationRepositoryRef ref) {
  return NotificationRepositoryImpl();
}

class NotificationRepositoryImpl implements NotificationRepository {
  static const _databaseName = "Notification_Database.db";
  static const _databaseVersion = 1;

  static const table = 'data_table';
  static const noticeId = 'notice_id';
  static const wordId = 'word_id';
  static const original = 'original';
  static const translated = 'translated';
  static const time = 'time';

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
            $noticeId INTEGER PRIMARY KEY AUTOINCREMENT,
            $wordId TEXT NOT NULL,
            $original TEXT NOT NULL,
            $translated TEXT NOT NULL,
            $time TEXT NOT NULL
          )
          ''');
  }

  /// insert database row
  @override
  Future<int> addNotice(NoticeDataModel noticeDataModel) async {
    Database db = await database;

    final row = noticeDataModel.toJson();

    final id = await db.insert(table, row).catchError((e) {
      throw Exception('sqflite error: $e');
    });
    return id;
  }

  @override
  Future<List<NoticeDataModel>> getAllNotices({bool isDesc = false}) async {
    Database db = await database;
    final dataList = await db
        .query(table, orderBy: '$time ${isDesc ? 'DESC' : 'ASC'}')
        .catchError((e) {
      throw Exception('sqflite error: $e');
    });
    return dataList.map((e) => NoticeDataModel.fromJson(e)).toList();
  }

  @override
  Future<NoticeDataModel> getNoticeById(int id) async {
    Database db = await database;
    final data = await db.query(
      table,
      where: '$noticeId = ?',
      whereArgs: [id],
    ).catchError((e) {
      throw Exception('sqflite error: $e');
    });
    return NoticeDataModel.fromJson(data.first);
  }

  @override
  Future<void> deleteNotice(int id) async {
    Database db = await database;
    await db.delete(
      table,
      where: '$noticeId = ?',
      whereArgs: [id],
    ).catchError((e) {
      throw Exception('sqflite error: $e');
    });
  }

  @override
  Future<void> updateNotice(NoticeDataModel noticeDataModel) async {
    Database db = await database;
    await db.update(
      table,
      noticeDataModel.toJson(),
      where: '$noticeId = ?',
      whereArgs: [noticeDataModel.noticeId],
    ).catchError((e) {
      throw Exception('sqflite error: $e');
    });
  }

  @override
  Future<int> getTotalNotice() async {
    Database db = await database;
    final List<Map<String, Object?>> result = await db.query(
      table,
      columns: ['COUNT(*) AS count'],
    );
    return result.first['count'] as int;
  }
}

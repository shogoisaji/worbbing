import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "t_Database.db";
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
            $flag BOOLEAN,
            $originalWord TEXT,
            $translatedWord TEXT, 
            $updateDate TEXT,
            $registrationDate TEXT,
            $memo TEXT
          )
          ''');
  }

  // add database row
  Future<void> addData(List<dynamic> addData) async {
    final int _noticeDuration = addData[0];
    final int _updateCount = addData[1];
    final bool _flag = addData[2];
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
    final id = await db.insert(table, row);

    print('挿入された行のid: $id');
    print(
        '挿入されたデータ: \n$_noticeDuration \n$_updateCount \n$_flag \n$_originalWord \n$_translatedWord \n$_updateDate \n$_registrationDate \n$_memo');
  }

// get database
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }
}

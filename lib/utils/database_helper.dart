import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:gas_io/components/refuel_card.dart';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'card_database.db';
  static const String tableName = 'cards';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), dbName);
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            price REAL,
            liters REAL,
            date TEXT,
            location TEXT,
            euroPerLiter REAL
          )
        ''');
      },
    );
  }

  Future<int> insertCard(CardData card) async {
    print("insert card");
    final db = await database;
    return db.insert(tableName, card.toMap());
  }

  Future<List<CardData>> getCards() async {
    print("get db data");
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) {
      return CardData.fromMap(maps[i]);
    });
  }

  Future<int> deleteCard(CardData card) async {
    print("remove db data");
    final db = await database;
    return db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [card.id], // Assuming you have an 'id' field in your CardData
    );
  }
}
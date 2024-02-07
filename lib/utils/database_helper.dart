import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:gas_io/components/refuel_card.dart';
import 'package:gas_io/components/car_card.dart';
import 'package:gas_io/components/user_schema.dart';
import 'package:gas_io/utils/key_parameters.dart';

class DatabaseHelper with DatabaseCardKeys, DatabaseUserKeys, DatabaseCarKeys {
  static Database? _database;
  static const String dbName = 'card_database.db';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      return initDatabase();
    }
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), dbName);
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $userTableName (
          $userIdKey INTEGER PRIMARY KEY AUTOINCREMENT,
          $userNameKey TEXT,
          $userSurnameKey TEXT,
          $userUsernameKey TEXT
        )
        ''');
        await db.execute('''
        CREATE TABLE $carTableName (
          $carIdKey INTEGER PRIMARY KEY AUTOINCREMENT,
          $carUserIdKey INTEGER,
          $carBrandKey TEXT,
          $carModelKey REAL,
          $carYearKey INT,
          $carInitialKmKey REAL
        )
        ''');
        await db.execute('''
        CREATE TABLE $cardTableName(
          $idKey INTEGER PRIMARY KEY AUTOINCREMENT,
          $relatedCarIdKey INTEGER,
          $priceKey REAL,
          $litersKey REAL,
          $dateKey TEXT,
          $locationKey TEXT,
          $euroPerLiterKey REAL,
          $kmKey REAL
        )
        ''');
        await db.execute(
            '''INSERT INTO $userTableName($userNameKey, $userSurnameKey, $userUsernameKey) VALUES("Name", "Surname", "Username");''');
        await db.execute(
            '''INSERT INTO $carTableName($carUserIdKey, $carBrandKey, $carModelKey, $carYearKey, $carInitialKmKey) VALUES(0,"Fiat", "Panda", 0000, 0.0);''');
        await db.execute(
            '''INSERT INTO $carTableName($carUserIdKey, $carBrandKey, $carModelKey, $carYearKey , $carInitialKmKey) VALUES(1,"Lancia", "Delta", 0000, 0.0);''');
      },
    );
  }

  Future<int> insertCard(CardData card) async {
    print("insert card");
    final db = await database;
    return db.insert(cardTableName, card.toMap());
  }

  Future<List<CardData>> getCardsByCar(selectedCarId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      cardTableName,
      where: '$relatedCarIdKey = ?',
      whereArgs: [selectedCarId],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) {
      return CardData.fromMap(maps[i]);
    });
  }

  Future<List<CardData>> getYearCard(selectedCarId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT $idKey, $relatedCarIdKey, ROUND(SUM($priceKey), 2) AS $priceKey, ROUND(SUM($litersKey), 2) AS $litersKey, $dateKey, $locationKey, $euroPerLiterKey, $kmKey FROM $cardTableName WHERE $relatedCarIdKey = $selectedCarId GROUP BY STRFTIME('%mm', $dateKey);");
    return List.generate(maps.length, (i) {
      return CardData.fromMap(maps[i]);
    });
  }

  Future<List<CardData>> getMonthCard(selectedCarId) async {
    final db = await database;
    int month = DateTime.now().month;
    String formattedMonth = '';
    if (month <= 9) {
      formattedMonth = '0$month';
    } else {
      formattedMonth = month.toString();
    }
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM $cardTableName WHERE $relatedCarIdKey = $selectedCarId AND STRFTIME('%m', $dateKey) = '$formattedMonth';");
    return List.generate(maps.length, (i) {
      return CardData.fromMap(maps[i]);
    });
  }

  Future<int> deleteCard(CardData card) async {
    final db = await database;
    return db.delete(
      cardTableName,
      where: 'id = ?',
      whereArgs: [card.id], // Assuming you have an 'id' field in your CardData
    );
  }

  Future<List<UserData>> getUserData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      userTableName,
      orderBy: 'username DESC',
    );
    return List.generate(maps.length, (i) {
      return UserData.fromMap(maps[i]);
    });
  }

  Future<Map<int, String>> getCarsMap() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      carTableName,
      columns: [carIdKey, carBrandKey, carModelKey],
    );

    return {
      for (var car in maps)
        car[carIdKey]: '${car[carBrandKey]} ${car[carModelKey]}'
    };
  }

  // New method to update total kilometers traveled by a car
  Future<void> updateTotalKm(int carId, double totalKm) async {
    final db = await database;
    await db.update(
      carTableName,
      {carInitialKmKey: totalKm},
      where: '$carIdKey = ?',
      whereArgs: [carId],
    );
  }

  Future<Map<String, CardData?>> getPreviousAndNextRefuel(
      int selectedCarId, DateTime currentDate,
      {int? excludeRefuelId}) async {
    final db = await database;

    // Get the previous refuel
    final List<Map<String, dynamic>> previousRefuelMap = await db.rawQuery(
      "SELECT * FROM $cardTableName WHERE $relatedCarIdKey = $selectedCarId AND $dateKey < ?"
      "${excludeRefuelId != null ? ' AND $idKey != $excludeRefuelId' : ''}"
      " ORDER BY $dateKey DESC LIMIT 1;",
      [currentDate.toIso8601String()],
    );
    CardData? previousRefuel;
    if (previousRefuelMap.isNotEmpty) {
      previousRefuel = CardData.fromMap(previousRefuelMap.first);
    }

    // Get the next refuel
    final List<Map<String, dynamic>> nextRefuelMap = await db.rawQuery(
      "SELECT * FROM $cardTableName WHERE $relatedCarIdKey = $selectedCarId AND $dateKey > ?"
      "${excludeRefuelId != null ? ' AND $idKey != $excludeRefuelId' : ''}"
      " ORDER BY $dateKey ASC LIMIT 1;",
      [currentDate.toIso8601String()],
    );
    CardData? nextRefuel;
    if (nextRefuelMap.isNotEmpty) {
      nextRefuel = CardData.fromMap(nextRefuelMap.first);
    }

    return {'previousRefuel': previousRefuel, 'nextRefuel': nextRefuel};
  }

  // USER SECTION

  Future<void> updateUsername(int userId, String newUsername) async {
    final db = await database;
    await db.update(
      userTableName,
      {userUsernameKey: newUsername},
      where: '$userIdKey = ?',
      whereArgs: [userId],
    );
  }

  Future<int> insertUser(UserData user) async {
    Database db = await database;
    return await db.insert(userTableName, user.toMap());
  }

  Future<UserData?> getUser() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(userTableName, limit: 1);
    if (maps.length > 0) {
      return UserData.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUser(UserData user) async {
    Database db = await database;
    return await db.update(userTableName, user.toMap(),
        where: '$userIdKey = ?', whereArgs: [user.id]);
  }

  // CAR SECTION

  Future<int> insertCar(CarData car) async {
    Database db = await database;
    return await db.insert(carTableName, car.toMap());
  }

  Future<Map<String, dynamic>> getCarDetailsById(int carId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      carTableName,
      where: '$carIdKey = ?',
      whereArgs: [carId],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      throw Exception("Car with ID $carId not found");
    }
  }

  Future<void> updateCard(CardData newCard) async {
    final db = await database;

    // // Ensure that the card has a valid ID
    // if (newCard.id == null) {
    //   throw ArgumentError("Card ID cannot be null for update operation");
    // }

    await db.update(
      cardTableName,
      newCard.toMap(),
      where: '$idKey = ?',
      whereArgs: [newCard.id],
    );
  }

  Future<List<CarData>> getCarsByUser(int userId) async {
    print("get db data");
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      carTableName,
      where: '$carUserIdKey = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );
    return List.generate(maps.length, (i) {
      return CarData.fromMap(maps[i]);
    });
  }
}

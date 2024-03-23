import 'package:homework_6_1/app/data/medicine.dart';
import 'package:homework_6_1/app/data/notification.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DbHelper {
  static const _databaseName = "medicine_notification.db";
  static const _databaseVersion = 1;

  static const medicineTableName = "medicine";
  static const notificationTableName = "notification";

  static const medicineColumnId = 'id';
  static const medicineColumnName = 'name';
  static const medicineColumnFrequency = 'frequency';

  static const notificationColumnId = 'id';
  static const notificationColumnIdMedicine = 'id_medicine';
  static const notificationColumnTime = 'time';

  Database? _database;

  Future<Database> get database async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, _databaseName);
    _database = await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
    return _database!;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
		  CREATE TABLE $medicineTableName (
		    $medicineColumnId INTEGER PRIMARY KEY AUTOINCREMENT,
		    $medicineColumnName TEXT NOT NULL,
		    $medicineColumnFrequency INTEGER NOT NULL
		  )
	  ''');

    await db.execute('''
		  CREATE TABLE $notificationTableName (
        $notificationColumnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $notificationColumnIdMedicine INTEGER NOT NULL,
        $notificationColumnTime String NOT NULL,
        FOREIGN KEY ($notificationColumnIdMedicine) REFERENCES $medicineTableName($medicineColumnId)
      )
	  ''');
  }

  Future<void> insertMedicine(Medicine medicine) async {
    final db = await database;
    await db.insert(
      medicineTableName,
      medicine.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Medicine>> queryAllRowsMedicine() async {
    final db = await database;

    List<Map<String, dynamic>> medicines =
        await db.query(medicineTableName, orderBy: "$medicineColumnId DESC");
    return List.generate(
        medicines.length,
        (index) => Medicine(
            id: medicines[index]['id'],
            name: medicines[index]['name'],
            frequency: medicines[index]['frequency']));
  }

  Future<int> getLastMedicineId() async {
    final db = await database;

    List<Map<String, dynamic>> medicine = await db.query(medicineTableName,
        orderBy: "$medicineColumnId DESC", limit: 1);
    return medicine[0]['id'];
  }

  Future<Medicine> queryOneMedicine(int id) async {
    final db = await database;

    List<Map<String, dynamic>> medicine = await db.query(medicineTableName,
        orderBy: "$medicineColumnId DESC",
        where: '$medicineColumnId == ?',
        whereArgs: [id]);
    return Medicine(
        id: medicine[0]['id'],
        name: medicine[0]['name'],
        frequency: medicine[0]['frequency']);
  }

  Future<void> deleteMedicine(int id) async {
    final db = await database;
    await db.delete(
      medicineTableName,
      where: '$medicineColumnId == ?',
      whereArgs: [id],
    );
  }

  Future<void> insertNotification(Notification notification) async {
    final db = await database;
    await db.insert(
      notificationTableName,
      notification.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Notification>> queryAllRowsNotification() async {
    final db = await database;

    List<Map<String, dynamic>> notifications = await db
        .query(notificationTableName, orderBy: "$notificationColumnId DESC");
    return List.generate(
        notifications.length,
        (index) => Notification(
            id: notifications[index]['id'],
            idMedicine: notifications[index]['id_medicine'],
            time: notifications[index]['time']));
  }

  Future<List<Notification>> getNotificationsByMedicineId(
      int idMedicince) async {
    final db = await database;

    List<Map<String, dynamic>> notifications = await db.query(
        notificationTableName,
        orderBy: "$notificationColumnId ASC",
        where: '$notificationColumnIdMedicine == ?',
        whereArgs: [idMedicince]);
    return List.generate(
        notifications.length,
        (index) => Notification(
            id: notifications[index]['id'],
            idMedicine: notifications[index]['id_medicine'],
            time: notifications[index]['time']));
  }

  Future<void> deleteNotificationByMedicineId(int id) async {
    final db = await database;
    await db.delete(
      notificationTableName,
      where: '$notificationColumnIdMedicine == ?',
      whereArgs: [id],
    );
  }
}
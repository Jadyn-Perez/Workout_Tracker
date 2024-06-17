import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workout_tracker/Models/workout_set.dart'; // Replace with your actual model file

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'workoutdatabase.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate,
        onOpen: (db) async {
      await _checkAndUpdateSchema(db);
    });
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE workoutsets (
        id TEXT,
        date TEXT,
        number INTEGER,
        exercise TEXT,
        reps INTEGER,
        weight INTEGER
      )
    ''');
  }

  Future<int> insertItem(WorkoutSet item) async {
    Database db = await database;
    return await db.insert('workoutsets', item.toMap());
  }

  Future<List<WorkoutSet>> getItems() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('workoutsets');

    return List.generate(maps.length, (i) {
      return WorkoutSet.fromMap(maps[i]);
    });
  }

  Future<int> updateItem(WorkoutSet workoutSet) async {
    Database db = await database;
    return await db.update(
      'items',
      workoutSet.toMap(),
      where: 'id = ?',
      whereArgs: [workoutSet.id],
    );
  }

  Future<int> deleteItem(String id) async {
    Database db = await database;
    return await db.delete(
      'workoutsets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> addWeightColumn() async {
    Database db = await database;
    await db.execute('ALTER TABLE workoutsets ADD COLUMN weight TEXT');
  }

  Future<void> _checkAndUpdateSchema(Database db) async {
    List<Map<String, dynamic>> result =
        await db.rawQuery('PRAGMA table_info(workoutsets)');
    bool weightColumnExists =
        result.any((column) => column['name'] == 'weight');
    if (!weightColumnExists) {
      await addWeightColumn();
    }
  }
}

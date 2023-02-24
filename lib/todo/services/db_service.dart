import 'package:blog/todo/services/tachesqlite.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
class DatabaseHelper  {
DatabaseHelper._privateConstructor();
 static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
 static Database? _database;
 Future<Database> get database async => _database ??= await _initDatabase();


 Future<Database> _initDatabase() async {

  return await openDatabase(
      join(await getDatabasesPath(), 'taches.db'),
      version: 1,
      onCreate: (db, version) {
       db.execute(
        'CREATE TABLE taches(id INTEGER PRIMARY KEY AUTOINCREMENT,titre VARCHAR(255), description TEXT)',
      );
    },
    );
  }
  //insertion
  Future<void> insertTache(TacheSqlite tache) async {
    final db = await instance.database;
    await db.insert(
      'taches',
      tache.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
   
  }

  //insertion
  
  Future<List<TacheSqlite>> fetch() async {
    final db = await instance.database;
 final List<Map<String, dynamic>> maps = await db.query('messages',orderBy: 'id DESC');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return TacheSqlite.fromMap(maps[i]);
    });

  }






}
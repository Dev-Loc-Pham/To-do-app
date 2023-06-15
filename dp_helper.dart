

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app/colors/color.dart';

import '../model/note.dart';
class DBhelper{
  static final String _dbName = 'Note.db';
  static final int _version = 1;

    Future<Database> getDB() async {
    final dbPath = getDatabasesPath();
    return openDatabase(join(await dbPath, _dbName),
        onCreate: (db, version) async => db.execute(
            "CREATE TABLE Note( id INTEGER PRIMARY KEY AUTOINCREMENT , title TEXT , description TEXT , status INTEGER );"),
        version: _version);
  }
    Future<int> AddNote(Note note) async {
    final db = await getDB();

    return await db.insert("Note", note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

   Future<int> Update(Note note) async {
    final db = await getDB();
    return await db.update("Note", note.toMap(),
        where: "id = ?",
        whereArgs: [note.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

   Future<int> Delete(Note note) async {
    final db = await getDB();
    return await db.delete("Note", where: "id = ?", whereArgs: [note.id]);
  }

   Future<List<Note>> getAll() async {
    final db = await getDB();
    final List<Map<String, dynamic>> item = await db.query("Note",orderBy: 'id DESC');

    return List.generate(item.length, (i) => Note(id: item[i]['id'], title: item[i]['title'] , description: item[i]['description'], status: item[i]['status'] == 1 ? true:false));
  }
}
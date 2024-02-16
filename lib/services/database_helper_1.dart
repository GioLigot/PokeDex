import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:listview_test/models/queries.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:xml/xml.dart' as xml;

class SQLHelper{

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS mons (
		id INTEGER PRIMARY KEY,
		name TEXT,
		type TEXT,
		description TEXT
		);""");
  }

  static Future<sql.Database> db() async{
    return sql.openDatabase('pokemon.db',
      version: 1,
      onCreate: (sql.Database database,
          int version) async {
        print("creating a table");
        await createTables(database);
      },
    );
  }

  Future<List<Queries>> getQueriesFromXML(BuildContext context) async {
    try {
      String xmlString = await DefaultAssetBundle.of(context).loadString('assets/data/queries.xml');
      var raw = xml.XmlDocument.parse(xmlString);
      var elements = raw.findAllElements("queries");
      print("parsing xml success");

      final queries = raw.findAllElements('queries').map((queryElement) {
        final name = queryElement.getAttribute('name').toString();
        final text = queryElement.text.trim();
        return Queries(name: name, text: text);
      }).toList();

      return queries;

    } catch (error) {
      print("Error reading XML: $error");
      return [];
    }
  }




  static Future<bool> addPokemon(String name, String type, String description) async{
    final db = await SQLHelper.db();

    // Check for duplicate name before inserting
    final existingPokemon = await db.query('mons', where: 'name = ?', whereArgs: [name]);
    if (existingPokemon.isNotEmpty) {

      print('Pokemon with name $name already exists!');
      return false;
    }

    final data = {
      'name' : name,
      'type' : type,
      "description" : description};
    final id = await db.insert(
        'mons',
        data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return true;
  }

  static Future<List<Map<String, dynamic>>> getPokemons() async{
    final db = await SQLHelper.db();
    return db.query('mons', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getPokemon(int id) async{
    final db = await SQLHelper.db();
    return db.query('mons', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<bool> updatePokemon(int id, String name, String type, String description) async{
    final db = await SQLHelper.db();

    // Check for duplicate name before updating
    final existingPokemon = await db.query('mons', where: 'name = ? AND id != ?', whereArgs: [name, id]);
    if (existingPokemon.isNotEmpty) {
      return false;
    }

    final data = {
      'name' : name,
      'type' : type,
      'description' : description,
    };

    final result = await db.update('mons', data, where: "id = ?", whereArgs: [id]);
    return true;
  }

  static Future<void> deletePokemon(int id) async{
    final db = await SQLHelper.db();

    try{
      await db.delete("mons", where: "id = ?", whereArgs: [id]);
    }catch(err){
      debugPrint("Something went wrong while deleting an item: $err");
    }
  }




}
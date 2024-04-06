//responsible for managing the places added by the user.
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import '../models/place.dart';

Future<Database> _getDataBase() async {
  final dbPath = await sql.getDatabasesPath(); //using sql to store the data.
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version)
        //ye jb execute hota hai jb hum pheli baar kr rhe hote hai toh kuch pre cheeze execute krne ke liye.
        {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT)');
    },
    version: 1,
  );
  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);
  Future<void> loadPlaces() async {
    final db = await _getDataBase();
    final data = await db.query('user_places');
    final places = data.map((row) {
      return Place(
          id: row['id'] as String,
          title: row['title'] as String,
          image: (row['image'] as String) as File);
    }).toList();

    state = places;
  }

  void addPlace(String title, File image) async {
    final Directory addDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);

    final copiedImage = await image.copy('${addDir.path}/$fileName');

    final newPlace = Place(title: title, image: copiedImage);

    final db = await _getDataBase();
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image,
    });
    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier(),
);

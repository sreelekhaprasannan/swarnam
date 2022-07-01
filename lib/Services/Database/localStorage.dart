import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class LocalStorage {
  Future<Database> swarnamDB() async {
    Future<Database> swarnamDB =
        openDatabase(path.join(await getDatabasesPath(), 'swaranamDB.db'),
            onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE itemsorderlistshop(id INTEGER PRIMARY KEY AUTOINCREMENT,shop_name TEXT,shop_code TEXT,item_group TEXT,item_name TEXT,item_code TEXT,rate TEXT,qty TEXT)");
      await db.execute(
          "CREATE TABLE itemsorderlistdistributor(id INTEGER PRIMARY KEY AUTOINCREMENT,distributor_name TEXT,item_group TEXT,item_name TEXT,item_code TEXT,rate TEXT,qty TEXT)");
      // await db.execute("CREATE TABLE swarnam_offlinedb(shop Text,branch TEXT,Mobile TEXT,distributor Text,route TEXT)");
      // await db.execute("CREATE TABLE swarnam_ofline_itemdb(item_code TEXT,item_name TEXT,item_group TEXT,rate TEXT)");
    }, version: 1);
    return swarnamDB;
  }
}

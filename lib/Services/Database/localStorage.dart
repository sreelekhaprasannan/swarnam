import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

import '../../Model/Order/distributorOrderList.dart';
import '../../Model/Order/shopOrderListModel.dart';

class LocalStorage {
  Future<Database> swarnamDB() async {
    Future<Database> swarnamDB =
        openDatabase(path.join(await getDatabasesPath(), 'swaranamDB.db'),
            onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE itemsorderlistshop(id INTEGER PRIMARY KEY AUTOINCREMENT,shop_name TEXT,shop_code TEXT,item_group TEXT,item_name TEXT,item_code TEXT,rate TEXT,qty TEXT,longitude TEXT,latitude TEXT,distributor TEXT)");
      await db.execute(
          "CREATE TABLE itemsorderlistdistributor(id INTEGER PRIMARY KEY AUTOINCREMENT,distributor_name TEXT,item_group TEXT,item_name TEXT,item_code TEXT,rate TEXT,qty TEXT)");
      await db.execute(
          "CREATE TABLE distributor_detais(distributor_code TEXT,name TEXT,mobile TEXT,executive TEXT);");
      await db.execute(
          "CREATE TABLE item_deiais(item_code TEXT,item_name TEXT,item_group TEXT,item_price TEXT)");
      await db.execute(
          "CREATE TABLE shop_details(shop_code TEXT,name TEXT,branch TEXT,phone TEXT,executive TEXT,distributor TEXT,route TEXT)");
    }, version: 1);
    return swarnamDB;
  }
  Future insertOrderList(
      {NewOrderListShop? itemsOrderListShop,
      NewOrderListDistributor? itemOrderListDistributor}) async {
    Database db = await swarnamDB();
    if (itemsOrderListShop != null) {
      await db.insert('itemsorderlistshop', itemsOrderListShop.toMap());
    }
    if (itemOrderListDistributor != null) {
      await db.insert(
          'itemsorderlistdistributor', itemOrderListDistributor.toMap());
    }
  }
}

import 'package:flutter/src/widgets/framework.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:swarnamordermanagement/Model/Item/itemListModel.dart';
import 'package:swarnamordermanagement/Model/Item/itemModel.dart';
import 'package:swarnamordermanagement/Model/Shop/shopmodel.dart';

import '../../Model/Order/distributorOrderList.dart';
import '../../Model/Order/shopOrderListModel.dart';

class LocalStorage {
  Future<Database> swarnamDB() async {
    Future<Database> swarnamDB =
        openDatabase(path.join(await getDatabasesPath(), 'swaranamDB.db'),
            onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE itemsorderlistshop(id INTEGER PRIMARY KEY AUTOINCREMENT,shop_code TEXT,item_group TEXT,item_name TEXT,item_code TEXT,rate TEXT,qty TEXT,longitude TEXT,latitude TEXT,distributor TEXT)");
      await db.execute(
          "CREATE TABLE itemsorderlistdistributor(id INTEGER PRIMARY KEY AUTOINCREMENT,distributor_name TEXT,item_group TEXT,item_name TEXT,item_code TEXT,rate TEXT,qty TEXT)");
      await db.execute(
          "CREATE TABLE distributor_detais(distributor_code TEXT,name TEXT,mobile TEXT,executive TEXT);");
      await db.execute(
          "CREATE TABLE item_deiais(item_code TEXT,item_name TEXT,item_group TEXT,item_price REAL)");
      await db.execute(
          "CREATE TABLE shop_details(shop_code TEXT,name TEXT,branch TEXT,phone TEXT,executive TEXT,distributor TEXT,route TEXT)");
    }, version: 1);
    return swarnamDB;
  }

  Future insertToDB(
      {NewOrderListShop? itemsOrderListShop,
      NewOrderListDistributor? itemOrderListDistributor,
      ShopModel? shoplist,
      ItemModel? itemModel}) async {
    Database db = await swarnamDB();
    if (itemsOrderListShop != null) {
      await db.insert('itemsorderlistshop', itemsOrderListShop.toMap());
    }
    if (itemOrderListDistributor != null) {
      await db.insert(
          'itemsorderlistdistributor', itemOrderListDistributor.toMap());
    }
    if (shoplist != null) {
      await db.insert('shop_details', shoplist.tomap());
    }
    if (itemModel != null) {
      await db.insert('item_deiais', itemModel.tomap());
    }
  }

  Future<List<NewOrderListShop>> getShopOrderListDb(selectedShop) async {
    Database db = await swarnamDB();
    List<Map<String, dynamic>> orderList = await db.query('itemsorderlistshop',
        where: 'shop_code= ?', whereArgs: [selectedShop]);
    // for(var ol in orderList){}
    return List.generate(orderList.length, (index) {
      return NewOrderListShop(
          id: orderList[index]['id'].toString(),
          shop_code: orderList[index]['shop_code'],
          item_group: orderList[index]['item_group'],
          item: orderList[index]['item_name'],
          item_code: orderList[index]['item_code'],
          rate: orderList[index]['rate'],
          qty: orderList[index]['qty']);
    });
  }

  Future<List<NewOrderListDistributor>> getDistributorOrderListDb(
      distributor) async {
    Database db = await swarnamDB();
    List<Map<String, dynamic>> orderList = await db.query(
        'itemsorderlistdistributor',
        where: 'distributor_name= ?',
        whereArgs: [distributor]);
    // for(var ol in orderList){}
    return List.generate(orderList.length, (index) {
      return NewOrderListDistributor(
          id: orderList[index]['id'].toString(),
          distributor_name: orderList[index]['distributor_name'],
          item_group: orderList[index]['item_group'],
          item: orderList[index]['item_name'],
          item_code: orderList[index]['item_code'],
          rate: orderList[index]['rate'],
          qty: orderList[index]['qty']);
    });
  }

  Future getShopList({executive, distributor, route}) async {
    Database db = await swarnamDB();
    List<Map<String, dynamic>> shops = await db.query('shop_details',
        distinct: true,
        where: 'executive=? AND distributor=? AND route=?',
        whereArgs: [executive, distributor, route]);
    return List.generate(shops.length, (index) {
      return ShopModel(
          shop_code: shops[index]['shop_code'],
          name: shops[index]['name'],
          branch: shops[index]['branch'],
          phone: shops[index]['phone'],
          distributor: shops[index]['distributor'],
          executive: shops[index]['executive'],
          route: shops[index]['route']);

      //,phone TEXT,executive TEXT,distributor TEXT,route TEXT)
    });
  }

  Future getItemGroupList() async {
    Database db = await swarnamDB();
    Set itemGroups = {};
    List<Map<String, dynamic>> itemList = await db.query(
      'item_deiais',
      distinct: true,
    );
    for (var i in itemList) {
      itemGroups.add(i['item_group']);
    }
    //,phone TEXT,executive TEXT,distributor TEXT,route TEXT)

    return itemGroups.toList();
  }

  Future deleteShops() async {
    Database db = await swarnamDB();
    db.delete('shop_details');
  }

  Future getDistributors(executive) async {
    Database db = await swarnamDB();
    Set distributor = {};
    var li = await db.query(
      'shop_details',
      where: 'executive=?',
      whereArgs: [executive],
      distinct: true,
    );
    for (var i in li) {
      distributor.add(i['distributor']);
    }
    return distributor.toList();
  }

  Future getExecutive() async {
    Database db = await swarnamDB();
    Set executive = {};
    var li = await db.query(
      'shop_details',
      distinct: true,
    );
    for (var i in li) {
      executive.add(i['executive']);
    }
    return executive.toList();
  }

  Future getRouteList(distributor) async {
    Database db = await swarnamDB();
    Set route = {};
    var li = await db.query(
      'shop_details',
      where: 'distributor=?',
      whereArgs: [distributor],
      distinct: true,
    );
    for (var i in li) {
      route.add(i['route']);
    }
    return route.toList();
  }

  Future getItems() async {
    Database db = await swarnamDB();
    List<ItemModel> items = [];
    List<Map<String, dynamic>> itemList = await db.query(
      'item_deiais',
      distinct: true,
    );
    print('itemList form database: $itemList');
    for (var i in itemList) {
      items.add(ItemModel(
          item_code: i['item_code'].toString(),
          item_group: i['item_group'].toString(),
          item_name: i['item_name'].toString(),
          item_Price: '${i['item_price']}'));
    }
    return items;
  }

  deleteItemfromShopOrder(selectedShop, String? item_code) {}
}

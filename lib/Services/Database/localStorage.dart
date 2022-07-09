import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:swarnamordermanagement/Model/Distributor/distributorModel.dart';
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
          "CREATE TABLE itemsorderlistshop(id INTEGER PRIMARY KEY AUTOINCREMENT,shop_code TEXT,item_group TEXT,item_name TEXT,item_code TEXT,rate TEXT,qty TEXT,longitude TEXT,latitude TEXT,distributor TEXT,isSubmited INTEGER)");
      await db.execute(
          "CREATE TABLE itemsorderlistdistributor(id INTEGER PRIMARY KEY AUTOINCREMENT,distributor_name TEXT,distributor_code TEXT,item_group TEXT,item_name TEXT,item_code TEXT,rate TEXT,qty TEXT,isSubmited INTEGER)");
      await db.execute(
          "CREATE TABLE distributor_details(distributor_code TEXT,name TEXT,mobile TEXT,executive TEXT);");
      await db.execute(
          "CREATE TABLE item_deiails(item_code TEXT,item_name TEXT,item_group TEXT,item_price REAL)");
      await db.execute(
          "CREATE TABLE shop_details(shop_code TEXT,name TEXT,branch TEXT,phone TEXT,executive TEXT,distributor TEXT,route TEXT)");
    }, version: 1);
    return swarnamDB;
  }

  Future insertToDB(
      {NewOrderListShop? itemsOrderListShop,
      NewOrderListDistributor? itemOrderListDistributor,
      DistributorModel? distributorModel,
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
      await db.insert('item_deiails', itemModel.tomap());
    }
    if (distributorModel != null) {
      await db.insert('distributor_details', distributorModel.tomap());
    }
  }

  Future<List<NewOrderListShop>> getShopOrderListDb(
      selectedShop, status) async {
    Database db = await swarnamDB();
    List<Map<String, dynamic>> orderList = await db.query('itemsorderlistshop',
        where: 'shop_code= ? AND isSubmited=?',
        whereArgs: [selectedShop, status],
        distinct: true);
    // for(var ol in orderList){}
    return List.generate(orderList.length, (index) {
      return NewOrderListShop(
          id: orderList[index]['id'].toString(),
          shop_code: orderList[index]['shop_code'],
          item_group: orderList[index]['item_group'],
          item: orderList[index]['item_name'],
          item_code: orderList[index]['item_code'],
          rate: orderList[index]['rate'],
          latitude: orderList[index]['latitude'],
          longitude: orderList[index]['longitude'],
          isSubmited: orderList[index]['isSubmited'],
          qty: orderList[index]['qty']);
    });
  }

  Future<List<NewOrderListDistributor>> getDistributorOrderListDb(
      distributor) async {
    Database db = await swarnamDB();
    List<Map<String, dynamic>> orderList = await db.query(
        'itemsorderlistdistributor',
        where: 'distributor_code= ? AND isSubmited=?',
        whereArgs: [distributor, 0]);
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

  Future getDistributorsList(executive) async {
    Database db = await swarnamDB();
    List distributors = await db.query('distributor_details',
        distinct: true, where: 'executive = ?', whereArgs: [executive]);
    print(distributors);
    return List.generate(distributors.length, (index) {
      return DistributorModel(
          distributor_code: distributors[index]['distributor_code'],
          name: distributors[index]['name'],
          executive: distributors[index]['executive'],
          mobile: distributors[index]['mobile']);
    });
    // return distributors;
  }

  Future getItemGroupList() async {
    Database db = await swarnamDB();
    Set itemGroups = {};
    List<Map<String, dynamic>> itemList = await db.query(
      'item_deiails',
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
      distinct: true,
      where: 'executive=?',
      whereArgs: [executive],
    );
    print(li);
    for (var i in li) {
      distributor.add(i['distributor']);
    }
    return distributor.toList();
  }

  Future getExecutive() async {
    Database db = await swarnamDB();
    Set executive = {};
    var li =
        await db.query('shop_details', columns: ['executive'], distinct: true);
    for (var i in li) {
      executive.add(i['executive']);
    }
    // var li1 = await db.query('distributor_details', distinct: true);
    // for (var i in li1) {
    //   executive.add(i['executive']);
    // }

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
      'item_deiails',
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

  deleteItemfromShopOrder(String? selectedShop, String? item_code) async {
    Database db = await swarnamDB();
    db.delete('itemsorderlistshop',
        where: 'shop_code = ? and item_code = ?',
        whereArgs: [selectedShop, item_code]);
  }

  Future deleteShopOrder(selectedShop) async {
    Database db = await swarnamDB();
    db.delete('itemsorderlistshop',
        where: 'shop_code= ?', whereArgs: [selectedShop]);
  }

  Future deleteDistributorOrder(selectedDistributor) async {
    Database db = await swarnamDB();
    db.delete('itemsorderlistdistributor',
        where: 'distributor_code= ?', whereArgs: [selectedDistributor]);
  }

  deleteItemfromDistributorOrder(distributor, item_code) async {
    Database db = await swarnamDB();
    db.delete('itemsorderlistdistributor',
        where: 'distributor_code = ? and item_code = ?',
        whereArgs: [distributor, item_code]);
  }

  updateDistributor(distributor) async {
    Database db = await swarnamDB();
    db.update('itemsorderlistdistributor', {"isSubmited": 1},
        where: 'distributor_code = ?', whereArgs: [distributor]);
  }

  getSubmittedordersinShop() async {
    Database db = await swarnamDB();
    List<Map<String, Object?>> submittedShopList = await db.query(
        'itemsorderlistshop',
        columns: ['shop_code'],
        where: "isSubmited=?",
        whereArgs: [1]);
    print(submittedShopList);
    if (submittedShopList.isNotEmpty) {
      submittedShopList.forEach((element) async {
        print('element:$element');
        List li = [];
        // await LocalStorage()
        //     .getShopOrderListDb(element['shop_code'], 1)
        //     .then((value) {
        //   print(value);
        //   for (var i in value) {
        //     li.add({
        //       "item_code": value,
        //       "qty": double.parse(value.toString()),
        //       "rate": double.parse(value.toString())
        //     });
        //   }
        // });
      });
    }
  }

  updateShopOrder(shop) async {
    Database db = await swarnamDB();
    db.update('itemsorderlistshop', {"isSubmited": 1},
        where: 'shop_code = ?', whereArgs: [shop]);
  }
}

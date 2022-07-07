import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:swarnamordermanagement/Model/Api/shopApiModel.dart';
import 'package:swarnamordermanagement/Model/Distributor/distributorModel.dart';
import 'package:swarnamordermanagement/Model/Item/itemModel.dart';
import 'package:swarnamordermanagement/Model/Shop/shopmodel.dart';
import 'package:swarnamordermanagement/Services/Database/localStorage.dart';
import '../../Model/Api/loginApiModel.dart';
import '../../View/Login/loginScreen.dart';
import '../../main.dart';

class ApiServices {
  //http://103.160.107.158
  //https://swarnam.frappe.cloud
  // http://103.86.176.198:8002

  final urlHead = 'https://swarnam.frappe.cloud';
  final pathname = '/api/method/swarnam.api.v1.';

  //for getting tocken from sharedprferences
  Map<String, String>? headers = {};
  Future getToken() async {
    await MyApp().getToken().then((token) {
      headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ${token}'
      };
    });
  }

// Api call For Login
  Future Login(username, password) async {
    var response;
    LoginApiModel? result;
    var userdetails;
    var url = Uri.parse('$urlHead' + '$pathname' + 'auth.authenticate');
    try {
      response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({'username': '$username', 'password': '$password'}));
      if (response.statusCode == 200) {
        userdetails = jsonDecode(response.body);
        // result = LoginApiModel.fromJson(userdetails['message']);
      }
      return userdetails['message'];
    } on SocketException {
      EasyLoading.showToast('Check Your NetConnection');
    }
  }

  Future getItemGroupList(BuildContext context) async {
    var response;
    Map itemGroups = {};
    response = await getResponse(context, 'generic.get_item_groups', body: {});
    itemGroups = jsonDecode(response.body);
    // print(itemGroups);
    return itemGroups;
  }

  //getting Responce of Apis
  Future? getResponse(BuildContext context, String endpoint,
      {Map? body}) async {
    var response;
    await getToken();
    var url = Uri.parse('$urlHead' + '$pathname' + '$endpoint');
    try {
      response = await http.post(url, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 403) {
        // MyApp().savePage('LoginScreen1()');
        // _SimpleUri (https://swarnam.frappe.cloud/api/method/swarnam.api.v1.generic.get_sales_executives)
        MyApp().saveAttendaceStatus(0);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        return response;
      }
    } on SocketException {
      EasyLoading.showToast('Check Your Internet Conectivity',
          dismissOnTap: true);
    } catch (e) {
      EasyLoading.showToast('Connection Error!!!',
          duration: Duration(seconds: 1));
    }
  }

  Future getShopList(BuildContext context) async {
    var response;
    Map result = {};
    var li;
    List<ShopModel> shopList = [];

    response = await getResponse(context, 'shop.get_all_shops', body: {});
    result = jsonDecode(response.body);
    li = result['message'];
    ShopModel shopdetais = ShopModel();
    shopList.clear();
    for (var i in li['shops']) {
      shopdetais.shop_code = i['shop_code'].toString();
      shopdetais.name = i['name'].toString();
      shopdetais.branch = i['branch'].toString();
      shopdetais.phone = i['mobile_number'].toString();
      shopdetais.route = i['route'].toString();
      shopdetais.distributor = i['distributor'].toString();
      shopdetais.executive = i['sales_person'].toString();
      await LocalStorage().insertToDB(shoplist: shopdetais);
      print(shopdetais);
    }

    return result['message'];
  }

  //get_distributor_master
  getDistributors(BuildContext context) async {
    var response;
    Map result = {};
    List distributorList = [];
    response = await getResponse(context, 'distributor.get_distributor_master',
        body: {});

    result = jsonDecode(response.body);
    distributorList = result['message']['distributors'];
    print(distributorList);
    DistributorModel disributors = DistributorModel();
    distributorList.forEach((element) async {
      disributors.distributor_code = element['distributor_code'];
      disributors.executive = element['sales_person'];
      disributors.name = element['distributor_name'];
      disributors.mobile = element['mobile_no'];
      await LocalStorage().insertToDB(distributorModel: disributors);
    });
  }

  getItemList(BuildContext context) async {
    Map result = {};
    List<ItemModel> itemList = [];
    var response =
        await getResponse(context, 'generic.get_item_master', body: {});
    result = jsonDecode(response.body);
    var li = result['message']['items'];
    ItemModel itemdetais = ItemModel();
    itemList.clear();
    for (var i in li) {
      itemdetais.item_code = i['item_code'].toString();
      itemdetais.item_name = i['item_name'].toString();
      itemdetais.item_group = i['item_group'].toString();
      itemdetais.item_Price = i['rate'].toString();
      await LocalStorage().insertToDB(itemModel: itemdetais);
    }

    return result['message'];
  }

  getAttendanceStatus(BuildContext context) async {
    var response;
    var attendenceStatus;
    response = await getResponse(context, 'generic.get_attendance_status');
    attendenceStatus = jsonDecode(response.body);
    print(attendenceStatus['message']);
    return attendenceStatus['message'];
  }

  Future markAttendence(BuildContext context, Position position) async {
    var response;
    var attendencedetails;
    response = await getResponse(context, 'generic.mark_attendance', body: {
      'longitude': '${position.longitude}',
      'latitude': '${position.latitude}'
    });
    attendencedetails = jsonDecode(response.body);
    print(attendencedetails['message']);
    return attendencedetails['message'];
  }

  Future placeOrderShop(BuildContext context, shop, distributor, orderlist,
      latitude, longitude) async {
    var response;
    if (orderlist.isNotEmpty) {
      var order;
      try {
        response = await getResponse(context, 'shop.create_shop_order', body: {
          'distributor': '${distributor}',
          'latitude': '${latitude}',
          'longitude': '${longitude}',
          'shop_code': '${shop}',
          'items': orderlist
        });
        print('$orderlist');
        order = jsonDecode(response.body);
        return order['message'];
      } catch (e) {
        print(e);
        EasyLoading.showToast('Connection Error');
      }
    }
  }

  Future getDistributorHistory(BuildContext context, distributor) async {
    var response;
    var distributorOrderList;
    response = await getResponse(context, 'distributor.get_distributor_orders',
        body: {'distributor': '$distributor'});
    distributorOrderList = jsonDecode(response.body);
    return distributorOrderList['message'];
  }

  Future getShopHistory(BuildContext context, shop_code) async {
    var response;
    var distributorOrderList;
    response = await getResponse(context, 'shop.get_shop_orders',
        body: {'shop': '$shop_code'});
    distributorOrderList = jsonDecode(response.body);
    return distributorOrderList['message'];
  }

  placeOrderDistributor(
      BuildContext context, distributor, List<Map> orderlist, executive) async {
    var response;
    if (orderlist.isNotEmpty) {
      var order;
      try {
        response = await getResponse(context, 'distributor.sales_order', body: {
          'distributor': '${distributor}',
          'sales_person': '${executive}',
          'items': orderlist
        });
        print('$orderlist');
        order = jsonDecode(response.body);
        return order['message'];
      } catch (e) {
        print(e);
        EasyLoading.showToast('Connection Error');
      }
    }
  }
}

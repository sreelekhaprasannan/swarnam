import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:swarnamordermanagement/Model/Api/shopApiModel.dart';
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
    response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'username': '$username', 'password': '$password'}));
    if (response.statusCode == 200) {
      userdetails = jsonDecode(response.body);
      result = LoginApiModel.fromJson(userdetails['message']);
    }
    return userdetails['message'];
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
    } catch (e) {
      EasyLoading.showToast('Connection Error!!!',
          duration: Duration(seconds: 1));
    }
    if (response.statusCode == 403) {
      // MyApp().savePage('LoginScreen1()');
      // _SimpleUri (https://swarnam.frappe.cloud/api/method/swarnam.api.v1.generic.get_sales_executives)
      MyApp().saveAttendaceStatus(0);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      return response;
    }
  }

  Future getShopList(BuildContext context) async {
    var response;
    Map result = {};
    var li;
    List<ShopModel> shopList = [];

    response = await getResponse(context, 'shop.get_all_shops', body: {});
    result = jsonDecode(response.body);
    li = result['message']['shops'];
    ShopModel shopdetais = ShopModel();
    shopList.clear();
    for (var i in li) {
      shopdetais.shop_code = i['shop_code'].toString();
      shopdetais.name = i['name'].toString();
      shopdetais.branch = i['branch'].toString();
      shopdetais.phone = i['mobile_number'].toString();
      shopdetais.route = i['route'].toString();
      shopdetais.distributor = i['distributor'].toString();
      shopdetais.executive = i['sales_person'].toString();
      LocalStorage().insertToDB(shoplist: shopdetais);
      print(shopdetais);
    }

    return result['message'];
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
      itemdetais.item_Price = i['rate'];
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
}

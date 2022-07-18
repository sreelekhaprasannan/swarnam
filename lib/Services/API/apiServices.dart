import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:swarnamordermanagement/Model/Distributor/distributorModel.dart';
import 'package:swarnamordermanagement/Model/Item/itemModel.dart';
import 'package:swarnamordermanagement/Model/Shop/shopmodel.dart';
import 'package:swarnamordermanagement/Services/Database/localStorage.dart';
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
    // LoginApiModel? result;
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
    return itemGroups;
  }

  //getting Responce of Apis
  Future? getResponse(BuildContext context, String endpoint,
      {Map? body}) async {
    var response;
    await getToken();
    var url = Uri.parse('$urlHead' + '$pathname' + '$endpoint');

    response = await http.post(url, headers: headers, body: jsonEncode(body));

    if (response.statusCode == 403) {
      // MyApp().savePage('LoginScreen1()');
      // _SimpleUri (https://swarnam.frappe.cloud/api/method/swarnam.api.v1.generic.get_sales_executives)

      await LocalStorage().logOutfromApp();
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
    try {
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
      }

      return result['message'];
    } on SocketException catch (e) {
      EasyLoading.showToast('You are Offline');
    } catch (e) {
      EasyLoading.showToast('Something Went Wrong');
    }
  }

  //get_distributor_master
  getDistributors(BuildContext context) async {
    var response;
    Map result = {};
    List distributorList = [];
    try {
      response = await getResponse(
          context, 'distributor.get_distributor_master',
          body: {});
      result = jsonDecode(response.body);
      var i;
      distributorList = result['message']['distributors'];
      DistributorModel disributors = DistributorModel();
      for (var element in distributorList) {
        disributors.distributor_code = element['distributor_code'];
        disributors.executive = element['sales_person'];
        disributors.name = element['distributor_name'];
        disributors.mobile = element['mobile_no'];
        await LocalStorage().insertToDB(distributorModel: disributors);
      }
    } on SocketException catch (e) {
      EasyLoading.showToast('You are Offline');
    } catch (e) {
      EasyLoading.showToast('Something Went Wrong');
    }
  }

  getItemList(BuildContext context) async {
    Map result = {};
    List<ItemModel> itemList = [];
    try {
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
    } on SocketException catch (e) {
      EasyLoading.showToast('You are Offline');
    } catch (e) {
      EasyLoading.showToast('Something Went Wrong');
    }
  }

  getAttendanceStatus(BuildContext context) async {
    var response;
    var attendenceStatus;
    try {
      response =
          await getResponse(context, 'generic.get_attendance_status', body: {});
      attendenceStatus = jsonDecode(response.body);
      return attendenceStatus['message'];
    } on SocketException catch (e) {
      EasyLoading.showToast('You are Offline');
    } catch (e) {
      EasyLoading.showToast('Something Went Wrong');
    }
  }

  Future markAttendence(BuildContext context, Position position) async {
    var response;
    var attendencedetails;
    try {
      response = await getResponse(context, 'generic.mark_attendance', body: {
        'longitude': '${position.longitude}',
        'latitude': '${position.latitude}'
      });
      attendencedetails = jsonDecode(response.body);
      return attendencedetails['message'];
    } on SocketException catch (e) {
      EasyLoading.showToast('You are Offline');
    } catch (e) {
      EasyLoading.showToast('Something Went Wrong');
    }
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
        order = jsonDecode(response.body);
        return order['message'];
      } on SocketException catch (e) {
        await LocalStorage().updateShopOrder(shop);
        EasyLoading.showToast(
            'You are Offline \n Your Orders willbe Updated Latter');
      } catch (e) {
        EasyLoading.showToast('Something Went Wrong');
      }
    }
  }

  Future getDistributorHistory(BuildContext context, distributor) async {
    var response;
    var distributorOrderList;
    try {
      response = await getResponse(
          context, 'distributor.get_distributor_orders',
          body: {'distributor': '$distributor'});
      distributorOrderList = jsonDecode(response.body);
      return distributorOrderList['message'];
    } on SocketException catch (e) {
      EasyLoading.showToast('You are Offline');
    } catch (e) {
      EasyLoading.showToast('Something Went Wrong');
    }
  }

  Future getShopHistory(BuildContext context, shop_code) async {
    var response;
    var distributorOrderList;
    try {
      response = await getResponse(context, 'shop.get_shop_orders',
          body: {'shop': '$shop_code'});
      distributorOrderList = jsonDecode(response.body);
      return distributorOrderList['message'];
    } on SocketException catch (e) {
      EasyLoading.showToast('You are Offline');
    } catch (e) {
      EasyLoading.showToast('Something Went Wrong');
    }
  }

  placeOrderDistributor(BuildContext context,
      {distributor, required List<Map> orderlist, executive}) async {
    var response;
    if (orderlist.isNotEmpty) {
      var order;
      try {
        response = await getResponse(context, 'distributor.sales_order', body: {
          'distributor': '${distributor}',
          'sales_person': '${executive}',
          'items': orderlist
        });
        order = jsonDecode(response.body);
        return order['message'];
      } on SocketException catch (e) {
        await LocalStorage().updateDistributor(distributor);
        EasyLoading.showToast(
            'You are Offline\n Your Orders will be Created Latter');
      } catch (e) {
        EasyLoading.showToast('Something Went Wrong');
      }
    }
  }

  downloadOrderHistory(BuildContext context, ordertype, orderId) async {
    try {
      var responce = await getResponse(context, 'generic.get_order_pdf_link',
          body: {"order_type": ordertype, "order_id": orderId});
      var result = await jsonDecode(responce.body);
      var resulturl = result['message']['url'];
      Directory dir = (Platform.isAndroid
          ? await getExternalStorageDirectory() //FOR ANDROID
          : await getApplicationSupportDirectory())!;

      String newPath = "";
      String filepath = "";
      List<String> paths = dir.path.split("/");
      for (int x = 1; x < paths.length; x++) {
        String folder = paths[x];
        if (folder != "Android") {
          newPath = newPath + "/" + folder;
        } else {
          break;
        }
      }
      newPath = newPath + "/Download";
      dir = Directory(newPath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      if (await dir.exists()) {
        filepath = dir.path;
        // your logic for saving the file.
      }
      

      final taskId = await FlutterDownloader.enqueue(
        url: resulturl,
        savedDir: '${dir.path}',
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );
    } on SocketException catch (e) {
      EasyLoading.showToast('You are Offline');
    } catch (e) {
      EasyLoading.showToast('Something Went Wrong');
    }
  }

  shopVisit(BuildContext context,
      {shop_code, executive, longitude, latitude}) async {
    var response, result;
    response = await getResponse(context, 'shop.shop_visit', body: {
      'shop_code': '$shop_code',
      'sales_person': '$executive',
      'latitude': '$latitude',
      'longitude': '$longitude'
    });
    result = jsonDecode(response.body);
    if (result['message']['success']) {
      EasyLoading.showToast('${result['message']['message']}');
      await LocalStorage().deletevisitedShop(shop_code);
    }
  }
}

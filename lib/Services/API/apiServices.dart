import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:swarnamordermanagement/Model/Api/shopApiModel.dart';
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
    response = await http.post(url, headers: headers, body: jsonEncode(body));
    if (response.statusCode == 403) {
      // MyApp().savePage('LoginScreen1()');
      MyApp().saveAttendaceStatus(0);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      return response;
    }
  }

  Future getExecutiveList(BuildContext context) async {
    var response;
    Map executive = {};
    response =
        await getResponse(context, 'generic.get_sales_executives', body: {});
    executive = jsonDecode(response.body);
    // print("executive['message']:${executive['message']}");

    return executive['message'];
  }

  Future getDistributors(BuildContext context) async {
    var response;
    Map distributorList = {};
    response =
        await getResponse(context, 'distributor.get_distributors', body: {});
    // print(response);
    distributorList = jsonDecode(response.body);

    return distributorList['message'];
  }

  Future getRouteList(BuildContext context, selectedDistributor) async {
    var response;
    Map routeList = {};
    response = await getResponse(context, 'distributor.get_distributor_route',
        body: {'distributor': '$selectedDistributor'});
    routeList = jsonDecode(response.body);
    return routeList['message'];
  }

  Future getShopList(BuildContext context, route) async {
    var response;
    Map result = {};

    response = await getResponse(context, 'shop.get_route_shop',
        body: {'route': '$route'});
    result = jsonDecode(response.body);

    return result['message'];
  }

  getAttendanceStatus(BuildContext context) async {
    var response;
    var attendenceStatus;
    response = await getResponse(context, 'generic.get_attendance_status');
    attendenceStatus = jsonDecode(response.body);
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

  getItemList(BuildContext context, String? selectedItemGroup) {}
}

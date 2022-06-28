import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
    print(itemGroups);
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
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      return response;
    }
  }
}

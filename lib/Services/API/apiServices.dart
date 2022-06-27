import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Model/Api/loginApiModel.dart';

class ApiServices {
  //http://103.160.107.158
  //https://swarnam.frappe.cloud
  // http://103.86.176.198:8002

  final urlHead = 'https://swarnam.frappe.cloud';
  final pathname = '/api/method/swarnam.api.v1.';

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
      // print(result);
    }
    // userdetails = jsonDecode(response.body);
    // print(userdetails['message']);
    return userdetails['message'];
  }
}

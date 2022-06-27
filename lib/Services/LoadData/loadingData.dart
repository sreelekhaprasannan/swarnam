import 'package:flutter/cupertino.dart';
import 'package:swarnamordermanagement/Model/Api/loginApiModel.dart';
import 'package:swarnamordermanagement/Services/API/apiServices.dart';

class LoadData extends ChangeNotifier {
  bool loading = false;
  Future getLoginData(username, password) async {
    var get;
    loading = true;
    get = (await ApiServices().Login(username, password))!;
    loading = false;
    notifyListeners();
    return get;
  }
}

import 'dart:async';

import 'package:swarnamordermanagement/Services/API/apiServices.dart';
import 'package:swarnamordermanagement/View/Login/loginScreen.dart';

import '../Model/Api/loginApiModel.dart';

class LoginBloc {
  late bool sucess;
  late var username, password;
  final _stateStreamController = StreamController<LoginApiModel>();
  StreamSink<LoginApiModel> get counterSink => _stateStreamController.sink;
  Stream<LoginApiModel> get counterStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<LoginAction>();
  StreamSink<LoginAction> get eventSink => _eventStreamController.sink;
  Stream<LoginAction> get eventStream => _eventStreamController.stream;
  void dispose() {
    _stateStreamController.close();
  }

  LoginBloc() {
    sucess = false;

    eventStream.listen((event) async {
      if (event == LoginAction.Loginfetch) {
        await getusernameandpassword();
        ApiServices().Login(username, password).then((value) {
          if(value[sucess]){

          }
        });
      }
    });
  }

  Future getusernameandpassword() async {
    await LoginScreenState().getUserNameandPassword().then((value) {
      username = value['User'];
      password = value['password'];
    });
  }
}

enum LoginAction { Loginfetch, Logedin }

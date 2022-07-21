import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:swarnamordermanagement/Model/Storage/storageModel.dart';
import 'package:swarnamordermanagement/View/Login/resetPassword.dart';
import '../../Services/API/apiServices.dart';
import '../../main.dart';
import '../AppColors/appColors.dart';
import '../Home/loginHome.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  Timer? timer;
  var username, password;
  final _storage = const FlutterSecureStorage();
  List<StorageModel> _items = [];
  bool iswrongCredential = false,
      isVisible = false,
      isloading = false,
      isLogedin = false,
      canlogin = true;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    EasyLoading.addStatusCallback((status) {
      if (status == EasyLoadingStatus.dismiss) {
        timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        maintainBottomViewPadding: false,
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              //-------------Login Signup Tabs---------------//
              Positioned(
                  top: MediaQuery.of(context).size.height / 4.5,
                  left: 0,
                  right: 0,
                  // bottom: MediaQuery.of(context).size.height / 4.5,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    height: MediaQuery.of(context).size.height / 1.8,
                    width: MediaQuery.of(context).size.width - 40,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: App_Colors().appBackground1,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 5)
                        ]),
                    //            Login Tab           //
                    child: SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 12),
                        child: Column(
                          children: [
                            Container(child: loginContainer()),
                          ],
                        ),
                      ),
                    ),
                  )),

              //-----------------Logo----------------------//

              Positioned(
                top: MediaQuery.of(context).size.height / 6.5,
                right: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.all(18),
                  height: MediaQuery.of(context).size.height / 7,
                  width: MediaQuery.of(context).size.width / 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),

                  child: Image(
                      image: AssetImage('lib/Images/swarnam_logo.png'),
                      height: 10,
                      width: 10),
                  // ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //  ---------------- Container to Enter the Login Credentials -------//
  loginContainer() {
    return Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: 5),
            TextFormField(
                cursorColor: App_Colors().appTextColorYellow,
                controller: usernameController,
                style: TextStyle(
                    color: App_Colors().appTextColorYellow, fontSize: 20),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  prefixIcon: Icon(
                    Icons.mail_outline,
                    color: Color.fromARGB(255, 221, 177, 43),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: iswrongCredential
                              ? Colors.red
                              : Color.fromARGB(255, 2, 92, 29)),
                      borderRadius: BorderRadius.all(Radius.circular(35))),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 2, 92, 29)),
                      borderRadius: BorderRadius.all(Radius.circular(35))),
                  border: UnderlineInputBorder(),
                  hintText: 'Username',
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 221, 177, 43)),
                )),
            Padding(padding: EdgeInsets.all(15)),
            //                  Password TextField                       //
            TextFormField(
                controller: passwordController,
                cursorColor: App_Colors().appTextColorYellow,
                obscureText: !isVisible,
                keyboardType: TextInputType.visiblePassword,
                style: TextStyle(
                    color: App_Colors().appTextColorYellow, fontSize: 20),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: iswrongCredential
                                ? Colors.red
                                : Color.fromARGB(255, 2, 92, 29)),
                        borderRadius: BorderRadius.all(Radius.circular(35))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: iswrongCredential
                                ? Colors.red
                                : Color.fromARGB(255, 2, 92, 29)),
                        borderRadius: BorderRadius.all(Radius.circular(35))),
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      icon: isVisible
                          ? Icon(Icons.visibility_off_outlined)
                          : Icon(Icons.visibility_outlined),
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                    ),
                    prefixIcon: Icon(Icons.lock_outline,
                        color: App_Colors().appTextColorYellow),
                    hintStyle:
                        TextStyle(color: App_Colors().appTextColorYellow))),
            Container(
              padding: EdgeInsets.all(2),
              margin: EdgeInsets.only(top: 10),
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResetPasswordPage()));
                  },
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(color: Colors.blue),
                  )),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 30),

            Center(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: ElevatedButton(
                        onPressed: () {
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                          loginbuttonPressed();
                        },
                        child: Text('Login'),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                App_Colors().appTextColorYellow))))),
            SizedBox(height: 120, child: loadingindicator())
          ]),
        ));
  }

  loadingindicator() {
    Widget? widget;
    if (isloading) {
      widget = Center(
          child: CircularProgressIndicator(
              color: App_Colors().appTextColorYellow));
      setState(() {});
    } else {
      widget = Container();
      setState(() {});
    }
    return widget;
  }
  // ------------ Function call For Login Button Press  //

  loginbuttonPressed() async {
    var userType, token, salesPerson;
    setState(() {
      isloading = true;
    });
    try {
      await ApiServices()
          .Login(usernameController.text, passwordController.text)
          .then((loginvalue) async {
        if (loginvalue['success']) {
          iswrongCredential = false;
          userType = loginvalue['user_type'];
          token = loginvalue['token'];
          try {
            await _storage.write(
                key: "auth_token",
                value: token,
                iOptions: _getIOSOptions(),
                aOptions: _getAndroidOptions());
            MyApp().saveLoginStatus(1);
          } catch (e) {
            print(e);
          }
          await ApiServices().getShopList(context).then((value) {
            if (value['message'] == 0) {
              canlogin = false;
              isloading = false;
              setState(() {});
            } else {
              canlogin = true;
            }
          });
          await ApiServices().getItemList(context).then((value) {
            if (value['message'] == 0) {
              canlogin = false;
              isloading = false;
              setState(() {});
            } else {
              canlogin = true;
            }
          });
          if (userType == 1) {
            await ApiServices().getDistributors(context);
          }
          if (canlogin) {
            await MyApp().saveUserType(userType);
            await MyApp().saveSalesPerson(loginvalue['sales_person']);
            Navigator.of(context).pushReplacement(PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 300),
                reverseTransitionDuration: Duration(milliseconds: 300),
                transitionsBuilder: (context, animation, secAnimation, child) {
                  return SlideTransition(
                    position:
                        Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
                            .animate(animation),
                    child: child,
                  );
                },
                pageBuilder: (context, animation, secAnimation) {
                  return LoginHome();
                }));
          } else {
            EasyLoading.showToast('Try Again Later');
            isloading = false;
            setState(() {});
          }
        } else {
          iswrongCredential = true;
          MyApp().saveLoginStatus(0);
          timer?.cancel();
          await EasyLoading.showToast('${loginvalue['message']}',
              toastPosition: EasyLoadingToastPosition.bottom);
          setState(() {
            isloading = false;
          });
        }
      });
    } on SocketException {
      EasyLoading.showToast(
          'Please Check your Internet Connection \n And Try Again',
          dismissOnTap: true);
      isloading = false;
    } catch (e) {
      print(e);
    }
    setState(() {});

    //   setState(() {});
  }

  IOSOptions _getIOSOptions() =>
      const IOSOptions(accessibility: IOSAccessibility.first_unlock);

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  String? _getAccountName() =>
      usernameController.text.isEmpty ? null : usernameController.text;

  Future getToken() async {
    try {
      var value = await _storage.read(
          key: "auth_token",
          iOptions: _getIOSOptions(),
          aOptions: _getAndroidOptions());
      final v1 = await _storage.readAll(
          iOptions: _getIOSOptions(), aOptions: _getAndroidOptions());
      _items = v1.entries
          .map((entry) => StorageModel(entry.key, entry.value))
          .toList(growable: false);
      return value;
    } catch (e) {
      print(e);
    }
  }

  Future deleteToken() async {
    await _storage.delete(
        key: "auth_token",
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions());
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Services/LoadData/loadingData.dart';
import 'View/AppColors/appColors.dart';
import 'View/Login/loginScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: App_Colors().appLightBlue,
  ));
  configLoading();
  getLocation();
}

//       initializing the Toast display EasyLoading     //
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 1500)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

//   initializing the Location Package for getting Location  //
Future getLocation() async {
  Location location = new Location();

  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  locationData = await location.getLocation();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  void saveUserType(userType) async {
    var prefUser = await SharedPreferences.getInstance();
    await prefUser.setInt('User', userType);
  }

  Future getUserType() async {
    var prf_userType = await SharedPreferences.getInstance();
    int? userType = prf_userType.getInt('User');
    return userType;
  }

  saveOrderType(orderType) async {
    var prefOrderType = await SharedPreferences.getInstance();
    await prefOrderType.setInt('OrderType', orderType);
  }

  Future getOrderType() async {
    var prf_orderType = await SharedPreferences.getInstance();
    int? orderType = prf_orderType.getInt('OrderType');
    return orderType;
  }

  Future saveToken(token) async {
    var prefToken = await SharedPreferences.getInstance();
    await prefToken.setString('token', token);
  }

  Future getToken() async {
    var prf_Token = await SharedPreferences.getInstance();
    String? token = prf_Token.getString('token');
    return token;
  }

  Future saveSalesPerson(salesPerson) async {
    var prefPerson = await SharedPreferences.getInstance();
    await prefPerson.setString('Name', salesPerson);
  }

  Future getSalesPerson() async {
    var prf_person = await SharedPreferences.getInstance();
    String? person = prf_person.getString('Name');
    return person;
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(App_Colors().appLightBlue);
    return
        // ChangeNotifierProvider(
        //     create: (context) => LoadData(),
        //     child:
        MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(), //LoginHome(),
      builder: EasyLoading.init(),
      // )
    );
  }
}
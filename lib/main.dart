import 'dart:async';

import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swarnamordermanagement/Services/Database/localStorage.dart';
import 'package:swarnamordermanagement/View/Home/loginHome.dart';

import 'Services/LoadData/loadingData.dart';
import 'View/AppColors/appColors.dart';
import 'View/Login/loginScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cron = Cron();

  cron.schedule(Schedule.parse('*/3 * * * *'), () async {
    print(DateTime.now());
    await LocalStorage().getSubmittedordersinShop();
  });

  cron.schedule(Schedule.parse('8-11 * * * *'), () async {
    print('between every 8 and 11 minutes');
  });
  await FlutterDownloader.initialize(
      debug:
          true // optional: set to false to disable printing logs to console (default: true)
      );
  runApp(MyApp());
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
  MyApp({Key? key}) : super(key: key);

  bool isLogedin = false;

  Future saveUserType(userType) async {
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

  Future saveSelectedRoute(String route) async {
    var prefSelectedRoute = await SharedPreferences.getInstance();
    await prefSelectedRoute.setString('route', route);
  }

  Future getSelectedRoute() async {
    var prf_selectedRoute = await SharedPreferences.getInstance();
    String? route = await prf_selectedRoute.getString('route');
    return route;
  }

  Future saveAttendaceStatus(int attendanceStatus) async {
    var prefSelectedRoute = await SharedPreferences.getInstance();
    await prefSelectedRoute.setInt('Attendance', attendanceStatus);
  }

  Future getAttendaceStatus() async {
    var prf_selectedRoute = await SharedPreferences.getInstance();
    int? attendanceStatus = await prf_selectedRoute.getInt('Attendance');
    return attendanceStatus;
  }

  Future saveSelectedExecutive(String executive) async {
    var prf_SelectedExcutive = await SharedPreferences.getInstance();
    await prf_SelectedExcutive.setString('Executive', executive);
  }

  Future getSelectedExecutive() async {
    var prf_selectedExecutive = await SharedPreferences.getInstance();
    String? executive = await prf_selectedExecutive.getString('Executive');
    return executive;
  }

  Future saveSelectedDistributor(distributor) async {
    var prf_SelectedDistributor = await SharedPreferences.getInstance();
    await prf_SelectedDistributor.setString('Distributor', distributor);
  }

  Future getSelectedDistributor() async {
    var prf_selectedDistributor = await SharedPreferences.getInstance();
    String? disrtributor =
        await prf_selectedDistributor.getString('Distributor');
    return disrtributor;
  }

  Future saveDistributorDetails(distributor_code, name, mobile) async {
    var prf_Distributorname = await SharedPreferences.getInstance();
    await prf_Distributorname.setString('Distributor_Name', name);
    var prf_code = await SharedPreferences.getInstance();
    await prf_code.setString('Distributor_code', distributor_code);
    var prf_mobile = await SharedPreferences.getInstance();
    prf_mobile.setString('Distributor_Mobile', mobile);
  }

  Future getDistributorsDetails() async {
    var distributorName, distributormobileno, distributor_code;
    var prf_shopDetails = await SharedPreferences.getInstance();
    distributorName = prf_shopDetails.getString('Distributor_Name');
    distributormobileno = prf_shopDetails.getString('Distributor_Mobile');
    distributor_code = prf_shopDetails.getString('Distributor_code');
    return {
      "Distributor_name": distributorName,
      "Distributor_Mobile": distributormobileno,
      "Distributor_code": distributor_code
    };
  }

  Future saveShopDetails(shop_code, shop_name, branch, mobile) async {
    var prf_shopname = await SharedPreferences.getInstance();
    await prf_shopname.setString('Shop_name', shop_name);
    var prf_shopcode = await SharedPreferences.getInstance();
    await prf_shopname.setString('Shop_code', shop_code);
    var prf_branch = await SharedPreferences.getInstance();
    prf_branch.setString('Branch', branch);
    var prf_mobile = await SharedPreferences.getInstance();
    prf_mobile.setString('Mobile', mobile);
  }

  Future getShopDetails() async {
    var shopName, branch, mobileno, shop_code;
    var prf_shopDetails = await SharedPreferences.getInstance();
    shopName = prf_shopDetails.getString('Shop_name');
    branch = prf_shopDetails.getString('Branch');
    mobileno = prf_shopDetails.getString('Mobile');
    shop_code = prf_shopDetails.getString('Shop_code');
    return {
      "shop_name": shopName,
      "branch": branch,
      "mobile": mobileno,
      "Shop_code": shop_code
    };
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
    getToken().then((value) {
      if (value == null || value == '') {
        isLogedin = false;
      } else {
        isLogedin = true;
      }
    });
    FlutterStatusbarcolor.setStatusBarColor(App_Colors().appTextColorYellow);
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
      home: isLogedin ? LoginScreen() : LoginHome(), //LoginHome(),
      builder: EasyLoading.init(),
      // )
    );
  }
}

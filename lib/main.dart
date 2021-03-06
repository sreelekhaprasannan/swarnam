import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swarnamordermanagement/View/Home/loginHome.dart';
import 'View/AppColors/appColors.dart';
import 'View/Login/loginScreen.dart';

bool isLogedin = false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize(
      debug:
          true // optional: set to false to disable printing logs to console (default: true)
      );
  await MyApp().getLoginStatus().then((value) {
    if (value == 0 || value == null) {
      isLogedin = false;
    } else {
      isLogedin = true;
    }
  });
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: App_Colors().appStatuusBarColor,
  ));
  configLoading();
  await MyApp().determinePosition();
  await MyApp().getStoragePermission();
  // getLocation();
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

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
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

  Future saveSalesPerson(salesPerson) async {
    var prefPerson = await SharedPreferences.getInstance();
    await prefPerson.setString('Name', salesPerson);
  }

  Future getSalesPerson() async {
    var prf_person = await SharedPreferences.getInstance();
    String? person = prf_person.getString('Name');
    return person;
  }

  Future saveSelectedRoute(String? route) async {
    var prefSelectedRoute = await SharedPreferences.getInstance();
    await prefSelectedRoute.setString('route', route!);
  }

  Future getSelectedRoute() async {
    var prf_selectedRoute = await SharedPreferences.getInstance();
    String? route = await prf_selectedRoute.getString('route');
    return route;
  }

  Future saveLoginStatus(int? loginStatus) async {
    var prefLoginStatus = await SharedPreferences.getInstance();
    await prefLoginStatus.setInt('Login', loginStatus!);
  }

  Future getLoginStatus() async {
    var prf_Login = await SharedPreferences.getInstance();
    int? login = await prf_Login.getInt('Login');
    return login;
  }

  Future saveAttendaceStatus(int? attendanceStatus) async {
    var prefSelectedRoute = await SharedPreferences.getInstance();
    await prefSelectedRoute.setInt('Attendance', attendanceStatus!);
  }

  Future getAttendaceStatus() async {
    var prf_selectedRoute = await SharedPreferences.getInstance();
    int? attendanceStatus = await prf_selectedRoute.getInt('Attendance');
    return attendanceStatus;
  }

  Future saveSelectedExecutive(String? executive) async {
    var prf_SelectedExcutive = await SharedPreferences.getInstance();
    await prf_SelectedExcutive.setString('Executive', executive!);
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

  Future saveDistributorDetails(
      String? distributor_code, String? name, String? mobile) async {
    var prf_Distributorname = await SharedPreferences.getInstance();
    await prf_Distributorname.setString('Distributor_Name', name!);
    var prf_code = await SharedPreferences.getInstance();
    await prf_code.setString('Distributor_code', distributor_code!);
    var prf_mobile = await SharedPreferences.getInstance();
    prf_mobile.setString('Distributor_Mobile', mobile!);
  }

  Future getDistributorsDetails() async {
    var distributorName, distributormobileno, distributor_code;
    var prf_distributorDetails = await SharedPreferences.getInstance();
    distributorName = prf_distributorDetails.getString('Distributor_Name');
    distributormobileno =
        prf_distributorDetails.getString('Distributor_Mobile');
    distributor_code = prf_distributorDetails.getString('Distributor_code');
    return {
      "Distributor_name": distributorName,
      "Distributor_Mobile": distributormobileno,
      "Distributor_code": distributor_code
    };
  }

  Future saveShopDetails(shop_code, shop_name, mobile) async {
    var prf_shopname = await SharedPreferences.getInstance();
    await prf_shopname.setString('Shop_name', shop_name);
    var prf_shopcode = await SharedPreferences.getInstance();
    await prf_shopcode.setString('Shop_code', shop_code);
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

  getStoragePermission() async {
    bool serviveEnabled;
    PermissionStatus permission;
    serviveEnabled = await Permission.storage.isGranted;
    if (!serviveEnabled) {
      await Permission.storage.request();
      // return Future.error('Storage Permission Denaid');
    }
    permission = await Permission.storage.status;
    if (permission == Permission.storage.isDenied) {
      permission = await Permission.storage.request();
      if (permission == Permission.storage.isDenied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Storage permissions are denied');
      }
    }

    if (permission == Permission.storage.isPermanentlyDenied) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Storage permissions are permanently denied, we cannot request permissions.');
    }
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
    getLoginStatus().then((value) {
      if (value == null || value == '') {
        isLogedin = false;
      } else {
        isLogedin = true;
      }
    });
    FlutterStatusbarcolor.setStatusBarColor(App_Colors().appStatuusBarColor);
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
      home: isLogedin ? LoginHome() : LoginScreen(), //LoginHome(),
      builder: EasyLoading.init(),
      // )
    );
  }
}

import 'package:cron/cron.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:swarnamordermanagement/Services/API/apiServices.dart';
import 'package:swarnamordermanagement/Services/Database/localStorage.dart';
import 'package:swarnamordermanagement/View/Order/shopOrderPage.dart';
import 'package:swarnamordermanagement/View/Widgets/appWidgets.dart';
import 'package:swarnamordermanagement/main.dart';

import '../AppColors/appColors.dart';
import '../Login/loginScreen.dart';
import '../Order/distributorOrderPage.dart';

class LoginHome extends StatefulWidget {
  const LoginHome({Key? key}) : super(key: key);

  @override
  State<LoginHome> createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
  String? salesPersonName,
      selectedOrderType,
      selectedExecutive,
      selectedRoute,
      selectedDistributor;
  int? userType;
  List? listofOrderType = [];
  List executives = [];
  List routeList = [];
  var distributorList = [];
  var attendanceStatus;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserType();
    getSallesPerson();
    getAttendanceStatus();
    final cron = Cron();

    cron.schedule(Schedule.parse('*/15 * * * *'), () async {
      print(DateTime.now());
      if (userType == 1) {
        await LocalStorage().getSubmittedordersinDistributor(context);
      }
      await LocalStorage().getSubmittedordersinShop(context);
      await LocalStorage().getVisitedShops(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
          color: App_Colors().appWhite,
          child: Column(
            children: [
              getAppBar(context),
              Expanded(
                child: Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: Column(children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: AppWidgets().logo(
                                  height:
                                      MediaQuery.of(context).size.height / 4,
                                  width: MediaQuery.of(context).size.width / 4),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Center(
                            child: AppWidgets().text(
                                text: '${salesPersonName}',
                                textsize:
                                    MediaQuery.of(context).size.height / 35,
                                fontWeight: FontWeight.w600),
                          )),
                      selectUserDisplay()
                    ])),
              ),
            ],
          )),
    ));
  }

  // Displays widgets According to the user
  Widget selectUserDisplay() {
    switch (userType) {
      // User is an executive
      case 0:
        {
          selectedOrderType = 'Shop Order';
          getDistributorsList(salesPersonName);
          return Expanded(
              flex: 10,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(children: [
                  distributorDropDown(),
                  Padding(padding: EdgeInsets.all(15)),
                  routeDropDown(),
                  Padding(padding: EdgeInsets.all(8)),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      App_Colors().appTextColorViolet)),
                              onPressed: () {},
                              child: AppWidgets().text(
                                  text: 'Target',
                                  textsize: 16,
                                  color: App_Colors().appBackground1))),
                    ],
                  ),
                  navigationCards()
                ]),
              ));
        }
      // user is an officer
      case 1:
        {
          getExecutiveList();
          return Expanded(
              flex: 10,
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      orderSelectionDropDown(),
                      Padding(padding: EdgeInsets.all(10)),
                      executiveDropDown(),
                      officersMenuDisplay(),
                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              App_Colors().appTextColorViolet)),
                                  onPressed: () {},
                                  child: AppWidgets().text(
                                      text: 'Target',
                                      textsize: 16,
                                      color: App_Colors().appBackground1))),
                        ],
                      ),
                      // Padding(padding: EdgeInsets.all(10)),
                      SingleChildScrollView(
                        child: navigationCards(),
                      )
                      // Padding(padding: EdgeInsets.all(5)),
                    ],
                  )));
        }
      default:
        {
          getUserType();
          return Expanded(flex: 10, child: Container());
        }
    }
  }

  Widget orderSelectionDropDown() {
    return Container(
      padding: EdgeInsets.all(5),
      height: 40,
      decoration: BoxDecoration(
          color: App_Colors().appWhite,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: Offset(0.0, 1.0),
                //Tween<Offset>(begin: Offset(0.0, 3.0),end: Offset(0.0, 0.0)),
                color: Color(0xFF000000).withOpacity(0.4),
                blurRadius: 1,
                spreadRadius: 1)
          ]),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          dropdownMaxHeight: MediaQuery.of(context).size.height / 6,
          style: Theme.of(context).textTheme.titleMedium,

          underline: Container(),
          hint: Center(child: AppWidgets().text(text: 'Select OrderType')),
          // isExpanded: true,
          value: selectedOrderType,
          items: listofOrderType!
              .map((e) => DropdownMenuItem(
                  value: e,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: AppWidgets().text(
                      text: e,
                      maxLines: 1,
                    ),
                  ),
                  alignment: AlignmentDirectional.bottomStart))
              .toList(),
          onChanged: (value) async {
            selectedOrderType = value!.toString();
            selectedExecutive = null;
            if (selectedOrderType == 'Distributor Order') {
              selectedExecutive = null;
              await MyApp().saveOrderType(1);
            }
            if (selectedOrderType == 'Shop Order') {
              await MyApp().saveOrderType(0);
              selectedExecutive = null;
              selectedDistributor = null;
              selectedRoute = null;
            }

            setState(() {});
          },
        ),
      ),
    );
  }

  Widget executiveDropDown() {
    // getExecutiveList(context);
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: App_Colors().appWhite,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: Offset(0.0, 1.0),
                //Tween<Offset>(begin: Offset(0.0, 3.0),end: Offset(0.0, 0.0)),
                color: Color(0xFF000000).withOpacity(0.4),
                blurRadius: 1,
                spreadRadius: 1)
          ]),
      child: DropdownButton2(
        underline: Container(),
        hint: Center(child: AppWidgets().text(text: 'Select Executive')),
        isExpanded: true,
        items: executives
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: AppWidgets().text(
                        text: e,
                        maxLines: 1,
                      )),
                  alignment: Alignment.center,
                ))
            .toList(),
        onChanged: (value) async {
          await MyApp().saveSelectedExecutive(value.toString());
          setState(() {
            selectedExecutive = value!.toString();
            getDistributorsList(selectedExecutive);
            selectedDistributor = null;
            selectedRoute = null;
          });
        },
        value: selectedExecutive,
      ),
    );
  }

  Widget distributorDropDown() {
    if (userType == 0) {
      getDistributorsList(salesPersonName);
    }
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: App_Colors().appWhite,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: Offset(0.0, 1.0),
                //Tween<Offset>(begin: Offset(0.0, 3.0),end: Offset(0.0, 0.0)),
                color: Color(0xFF000000).withOpacity(0.4),
                blurRadius: 1,
                spreadRadius: 1)
          ]),
      child: DropdownButton2(
        underline: Container(),
        hint: Center(child: AppWidgets().text(text: 'Select Distributor')),
        isExpanded: true,
        items: distributorList
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: AppWidgets().text(
                    text: e,
                    maxLines: 1,
                  ),
                  alignment: Alignment.center,
                ))
            .toList(),
        onChanged: (value) async {
          await MyApp().saveSelectedDistributor(value.toString());
          setState(() {
            selectedRoute = null;
            selectedDistributor = value!.toString();
            getRouteList(selectedDistributor);
          });
        },
        value: selectedDistributor,
      ),
    );
  }

  Widget routeDropDown() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: App_Colors().appWhite,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: Offset(0.0, 1.0),
                //Tween<Offset>(begin: Offset(0.0, 3.0),end: Offset(0.0, 0.0)),
                color: Color(0xFF000000).withOpacity(0.4),
                blurRadius: 1,
                spreadRadius: 1)
          ]),
      child: DropdownButton2(
        underline: Container(),
        hint: Center(child: AppWidgets().text(text: 'Select Route')),
        isExpanded: true,
        items: routeList
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width / 3,
                      child: AppWidgets().text(
                        text: e,
                        maxLines: 1,
                      )),
                  alignment: Alignment.center,
                ))
            .toList(),
        onChanged: (value) async {
          await MyApp().saveSelectedRoute(value.toString());
          setState(() {
            selectedRoute = value.toString();
          });
        },
        value: selectedRoute,
      ),
    );
  }

  getContext() {
    return context;
  }

  navigationCards() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Column(children: [
        Row(children: [
          Expanded(
            child: GestureDetector(
                child: imageContainer(
                    'lib/Images/ordericon.png', 'ORDER', App_Colors().appWhite),
                onTap: () async {
                  if (selectedOrderType == 'Shop Order') {
                    if (selectedDistributor == '' ||
                        selectedDistributor == null) {
                      EasyLoading.showToast('Select Distributor',
                          duration: Duration(seconds: 1));
                    } else if (selectedRoute == '' || selectedRoute == null) {
                      EasyLoading.showToast('Select Route',
                          duration: Duration(seconds: 1));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShopOrderPage()));
                    }
                  }
                  if (selectedOrderType == 'Distributor Order') {
                    if (selectedExecutive == '' || selectedExecutive == null) {
                      EasyLoading.showToast('Select Executive',
                          duration: Duration(seconds: 1));
                    } else {
                      await MyApp().saveSelectedExecutive(selectedExecutive!);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DisributorOrderPage()));
                    }
                  }
                }),
          ),
          Expanded(
            child: GestureDetector(
              child: imageContainer('lib/Images/stockicon.png', 'STOCK',
                  App_Colors().appStockBackground),
              onTap: () {
                EasyLoading.showToast('Coming soon....',
                    duration: Duration(milliseconds: 300),
                    toastPosition: EasyLoadingToastPosition.bottom);
              },
            ),
          ),
        ]),
        Row(
          children: [
            Expanded(
                child: GestureDetector(
              child: imageContainer('lib/Images/shop.png', 'SHOPS',
                  App_Colors().appShopBackGround),
              onTap: () {
                EasyLoading.showToast('Coming soon....',
                    duration: Duration(milliseconds: 300),
                    toastPosition: EasyLoadingToastPosition.bottom);
              },
            )),
            Expanded(
              child: GestureDetector(
                child: imageContainer('lib/Images/reporticon.png', 'REPORT',
                    App_Colors().appReportBackGround),
                onTap: () {
                  EasyLoading.showToast('Coming soon....',
                      duration: Duration(milliseconds: 300),
                      toastPosition: EasyLoadingToastPosition.bottom);
                },
              ),
            ),
          ],
        )
      ]),
    );
  }

  Container imageContainer(image, text, color) {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.height / 60),
      padding: EdgeInsets.all(MediaQuery.of(context).size.height / 50),
      height: MediaQuery.of(context).size.height / 8,
      width: MediaQuery.of(context).size.width / 3,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                offset: Offset(0.0, 1.0),
                //Tween<Offset>(begin: Offset(0.0, 3.0),end: Offset(0.0, 0.0)),
                color: Colors.black.withOpacity(0.4),
                blurRadius: 5,
                spreadRadius: 1)
          ]),
      child: Column(children: [
        Center(
          child: Image(
            image: AssetImage(image),
            height: MediaQuery.of(context).size.height / 25,
            width: 100,
          ),
        ),
        Padding(padding: EdgeInsets.all(5)),
        AppWidgets().text(
            text: text, textsize: 20, color: App_Colors().appTextColorViolet)
      ]),
    );
  }

  getSallesPerson() async {
    await MyApp().getSalesPerson().then((value) => salesPersonName = value);
    if (userType == 0) {
      getDistributorsList(salesPersonName);
    }
    setState(() {});
  }

  getUserType() async {
    await MyApp().getUserType().then((value) => userType = value);
    if (userType == 1) {
      listofOrderType = ['Distributor Order', 'Shop Order'];
      selectedOrderType = listofOrderType![0];
    }
    if (selectedOrderType == "Distributor Order") {
      await MyApp().saveOrderType(1);
      getExecutiveList();
    }
    if (userType == 0) {
      await MyApp().saveOrderType(0);
    }

    setState(() {});
  }

  officersMenuDisplay() {
    if (selectedOrderType == 'Shop Order') {
      return Column(
        children: [
          Padding(padding: EdgeInsets.all(10)),
          distributorDropDown(),
          Padding(padding: EdgeInsets.all(10)),
          routeDropDown(),
          Padding(padding: EdgeInsets.all(8)),
        ],
      );
    } else {
      return Padding(padding: EdgeInsets.all(10));
    }
  }

  getExecutiveList() async {
    await LocalStorage().getExecutive().then((value) {
      if (executives.length != 0) {
        executives.clear();
      }
      for (var i in value) {
        executives.add(i);
      }
      setState(() {});
    });

    setState(() {});
  }

  Future getDistributorsList(executive) async {
    await LocalStorage().getDistributors(executive).then(
      (value) {
        distributorList.clear();
        for (var i in value) {
          distributorList.add(i);
        }
      },
    );
    setState(() {});
  }

  Future getRouteList(distributor) async {
    await LocalStorage().getRouteList(distributor).then((value) {
      routeList.clear();
      for (var i in value) {
        routeList.add(i);
      }
    });
    setState(() {});
  }

  getAttendanceStatus() async {
    // await MyApp().getAttendaceStatus().then((value) {
    //   if (value == null || value == '') {
    //     attendanceStatus = 0;
    //   } else {
    //     attendanceStatus = value;
    //   }
    // });
    // setState(() {});
    try {
      await ApiServices().getAttendanceStatus(context).then((value) {
        attendanceStatus = value['attendance'];
        MyApp().saveAttendaceStatus(attendanceStatus);
      });
      setState(() {});
    } catch (e) {
      await MyApp()
          .getAttendaceStatus()
          .then((value) => attendanceStatus = value);
    }
  }

  Widget getAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 2, right: 5),
      height: MediaQuery.of(context).size.height / 20,
      color: App_Colors().appWhite,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        IconButton(
            onPressed: () async {
              attendanceStatus = await markAttendance(context);
              await MyApp().saveAttendaceStatus(attendanceStatus);
              LoginHome().createState();
            },
            icon: getAttendanceIcon(context, attendanceStatus)),
        IconButton(
            onPressed: () async {
              await LocalStorage().logOutfromApp();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            icon: FaIcon(
              size: MediaQuery.of(context).size.height / 23,
              Icons.logout,
              color: App_Colors().appTextColorYellow,
            )),
      ]),
    );
  }

  markAttendance(context) async {
    var status;
    await MyApp().determinePosition();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    await ApiServices().markAttendence(context, position).then((value) {
      status = value['attendance'];
      MyApp().saveAttendaceStatus(status);
      EasyLoading.showToast('${value['message']}',
          duration: Duration(seconds: 1));
    });
    setState(() {});
    return status;
  }

  Widget getAttendanceIcon(context, attendanceStatus) {
    if (attendanceStatus == 1) {
      // late Attendance
      return attendanceIcon(
          context, FontAwesomeIcons.userClock, App_Colors().appLightBlue);
    } else if (attendanceStatus == 2) {
      // Present
      return attendanceIcon(
          context, FontAwesomeIcons.userCheck, App_Colors().appLightGreen);
    } else {
      // Absent
      return attendanceIcon(
          context, FontAwesomeIcons.userXmark, App_Colors().appRed);
    }
  }

  FaIcon attendanceIcon(context, icon, color) {
    return FaIcon(
      icon,
      size: MediaQuery.of(context).size.height / 28,
      color: color,
    );
  }
}

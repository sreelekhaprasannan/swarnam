import 'dart:isolate';
import 'dart:ui';

import 'package:file_downloader/file_downloader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swarnamordermanagement/View/AppColors/appColors.dart';
import 'package:swarnamordermanagement/View/Widgets/appWidgets.dart';

import '../../Services/API/apiServices.dart';
import '../../main.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  String? shopName, distributorName, shop_code;
  int? userType, orderType;
  List historyList = [];
  late bool isExecutive;
  ReceivePort _port = ReceivePort();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserType();
    FileDownload().registerPortData(setState);
  }

  @override
  Widget build(BuildContext context) {
    if (userType != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: App_Colors().appTextColorViolet,
          title: AppWidgets().text(
              text: isExecutive ? '$shopName' : '$distributorName',
              color: App_Colors().appBackground1,
              textsize: 16),
          // title: isExecutive
          //     ? Text()
          //     : Text(
          //         ,
          //         textScaleFactor: 2,
          //       ),
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [historyDisplay()],
          ),
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Expanded historyDisplay() {
    if (historyList.length == 0) {
      return Expanded(child: Container());
    } else {
      return Expanded(
          child: ListView.builder(
              itemCount: historyList.length,
              itemBuilder: ((context, index) {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: App_Colors().appWhite,
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(2, 2),
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2)
                      ]),
                  margin: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Row(
                            children: [
                              Expanded(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      AppWidgets().text(text: 'Order id: '),
                                      AppWidgets().text(
                                          text: '${historyList[index]['name']}')
                                    ],
                                  ),
                                  Padding(padding: EdgeInsets.all(5)),
                                  Row(
                                    children: [
                                      AppWidgets().text(text: 'Date: '),
                                      AppWidgets().text(
                                          text:
                                              '${historyList[index]['order_date']}')
                                    ],
                                  )
                                ],
                              ))
                            ],
                          )),
                          IconButton(
                              onPressed: () {
                                downloadPressed(
                                    '${historyList[index]['name']}');
                              },
                              icon: Icon(
                                Icons.download,
                                color: App_Colors().appTextColorViolet,
                              ))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppWidgets().text(
                              text: 'Amount: ',
                              color: App_Colors().appTextColorYellow),
                          AppWidgets().text(
                              text: '${historyList[index]['amount']}',
                              color: App_Colors().appTextColorYellow)
                        ],
                      )
                    ],
                  ),
                  padding: EdgeInsets.all(10),
                );
              })));
    }
  }

  Future getHistory() async {
    if (orderType == 0) {
      isExecutive = true;
      try {
        await ApiServices().getShopHistory(context, shop_code).then((value) {
          for (var i in value['orders']) {
            historyList.add(i);
          }
        });
        setState(() {});
      } catch (e) {}
    }
    if (orderType == 1) {
      isExecutive = false;
      await ApiServices()
          .getDistributorHistory(context, distributorName)
          .then((value) => historyList = value['orders']);
      setState(() {});
    }
  }

  Future getUserType() async {
    await MyApp().getUserType().then((value) async {
      userType = value;
      //------------------ When user is an executive ---------//
      if (userType == 0) {
        isExecutive = true;
        //-------------- get the shop name ----------------//
        orderType = 0;
        await MyApp().getShopDetails().then((value) {
          shop_code = value['Shop_code'];
          shopName = value['shop_name'];
        });
        getHistory();
        setState(() {});
      }
      // ---------------- When User is an Officer -------------//
      if (userType == 1) {
        isExecutive = false;
        await MyApp().getOrderType().then((value) => orderType = value);
        //----------------  shopOrder -----------------//
        if (orderType == 0) {
          isExecutive = true;
          await MyApp().getShopDetails().then((value) {
            shop_code = value['Shop_code'];
            shopName = value['shop_name'];
          });
          getHistory();
          setState(() {});
        }
        //-------------------- Distributor Order -----------------//
        if (orderType == 1) {
          await MyApp().getDistributorsDetails().then((value) {
            distributorName = value['Distributor_name'];
          });
          getHistory();
          setState(() {});
        }
      }
    });
  }

  downloadPressed(ordrId) async {
    await ApiServices().downloadOrderHistory(context, orderType, ordrId);
  }
}

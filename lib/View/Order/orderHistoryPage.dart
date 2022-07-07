import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserType();
  }

  @override
  Widget build(BuildContext context) {
    if (userType != null) {
      return Scaffold(
        appBar: AppBar(
          title: isExecutive ? Text('$shopName') : Text('$distributorName'),
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
                                      Text('Order id: ',
                                          style: GoogleFonts.notoSans(
                                              fontSize: 20)),
                                      Text('${historyList[index]['name']}',
                                          style: GoogleFonts.notoSans(
                                              fontSize: 20)),
                                    ],
                                  ),
                                  Padding(padding: EdgeInsets.all(5)),
                                  Row(
                                    children: [
                                      Text('Date: ',
                                          style: GoogleFonts.notoSans(
                                              fontSize: 20)),
                                      Text(
                                          '${historyList[index]['transaction_date']}',
                                          style: GoogleFonts.notoSans(
                                              fontSize: 20)),
                                    ],
                                  )
                                ],
                              ))
                            ],
                          )),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.download))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Amount: '),
                          Text('${historyList[index]['grand_total']}',
                              style: GoogleFonts.notoSans(fontSize: 20)),
                        ],
                      )
                    ],
                  ),
                  padding: EdgeInsets.all(3),
                );
              })));
    }
  }

  Future getHistory() async {
    if (orderType == 0) {
      await ApiServices().getShopHistory(context, shop_code).then((value) {
        print(value);
      });
    }
    if (orderType == 1) {
      await ApiServices()
          .getDistributorHistory(context, distributorName)
          .then((value) => historyList = value['orders']);
      print(historyList);
      setState(() {});
    }
  }

  Future getUserType() async {
    await MyApp().getUserType().then((value) => userType = value);
    //------------------ When user is an executive ---------//
    if (userType == 0) {
      isExecutive = true;
      //-------------- get the shop name ----------------//
      await MyApp()
          .getShopDetails()
          .then((value) => shop_code = value['Shop_code']);
      getHistory();
      setState(() {});
    }
    // ---------------- When User is an Officer -------------//
    if (userType == 1) {
      isExecutive = false;
      await MyApp().getOrderType().then((value) => orderType = value);
      //----------------  shopOrder -----------------//
      if (orderType == 0) {
        await MyApp()
            .getShopDetails()
            .then((value) => shop_code = value['Shop_code']);
        setState(() {});
      }
      //-------------------- Distributor Order -----------------//
      if (orderType == 1) {
        await MyApp()
            .getSelectedDistributor()
            .then((value) => distributorName = value);
        getHistory();
        setState(() {});
      }
    }
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swarnamordermanagement/Model/Shop/visitedShop.dart';
import 'package:swarnamordermanagement/Services/API/apiServices.dart';
import 'package:swarnamordermanagement/View/Order/shopOrderPage.dart';
import 'package:swarnamordermanagement/main.dart';

import '../../Model/Order/shopOrderListModel.dart';
import '../../Services/Database/localStorage.dart';
import '../AppColors/appColors.dart';
import '../Widgets/appWidgets.dart';
import 'itemOrderPage.dart';

class NewOrderShop extends StatefulWidget {
  const NewOrderShop({Key? key}) : super(key: key);

  @override
  State<NewOrderShop> createState() => _NewOrderShopState();
}

class _NewOrderShopState extends State<NewOrderShop> {
  List<NewOrderListShop> itemOrderList = [];
  TextEditingController qtyController = TextEditingController();
  Map shopDetails = {};
  double totalAmount = 0;
  String? distributor;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getShopDetails();
    getDistributor();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Padding(padding: EdgeInsets.all(5)),
            Container(
              // margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(3),
              height: MediaQuery.of(context).size.height / 7,
              decoration: BoxDecoration(
                  color: App_Colors().appWhite,
                  border: Border.all(color: App_Colors().appBackground1),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 2),
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 1,
                        spreadRadius: 1),
                  ]),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.all(5)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AppWidgets().text(text: 'ORDER', textsize: 25),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('lib/Images/shop.png'),
                                  fit: BoxFit.contain),
                            ),
                          ),
                          flex: 2,
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppWidgets().text(
                                      text: '${shopDetails['shop_name']}',
                                      textsize: 25,
                                      maxLines: 2),
                                  AppWidgets().text(
                                      text: '${shopDetails['mobile']}',
                                      textsize: 14),
                                ]),
                          ),
                          flex: 5,
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    App_Colors().appTextColorViolet)),
                            onPressed: () async {
                              await MyApp().determinePosition();
                              Position position =
                                  await Geolocator.getCurrentPosition(
                                      desiredAccuracy: LocationAccuracy.high);
                              var executive, shop_code;
                              await MyApp()
                                  .getSelectedExecutive()
                                  .then((value) => executive = value);
                              await MyApp().getShopDetails().then((value) {
                                shop_code = value['Shop_code'];
                              });
                              try {
                                await ApiServices().shopVisit(context,
                                    shop_code: shop_code,
                                    executive: executive,
                                    latitude: position.latitude,
                                    longitude: position.longitude);
                              } on SocketException catch (e) {
                                VisitedShop shopVisit = VisitedShop();
                                shopVisit.executive = executive;
                                shopVisit.latitude =
                                    position.latitude.toString();
                                shopVisit.longitude =
                                    position.longitude.toString();
                                shopVisit.shop_code = shop_code;
                                await LocalStorage()
                                    .insertToDB(visitedShop: shopVisit);
                              } catch (e) {}
                            },
                            child: AppWidgets().text(
                                text: 'VISITED',
                                color: App_Colors().appBackground1)),
                        Padding(padding: EdgeInsets.all(5))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(5)),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                App_Colors().appTextColorViolet)),
                        onPressed: () {
                          orderButtonPressed();
                        },
                        child: AppWidgets().text(
                            text: 'ORDER', color: App_Colors().appBackground1)))
              ],
            ),
            Padding(padding: EdgeInsets.all(10)),
            Expanded(
                flex: 18,
                child: Container(
                  child: ListView.builder(
                      itemCount: itemOrderList.length,
                      itemBuilder: ((context, index) {
                        final orderitem = itemOrderList[index];
                        return Dismissible(
                            // onHorizontalDragEnd: (){deleteItemfromShopOrder(index)},
                            key: Key(orderitem.item.toString()),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  height:
                                      MediaQuery.of(context).size.height / 12,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors
                                          .white, //App_Colors().appBackground1,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            blurRadius: 5,
                                            spreadRadius: 2)
                                      ]),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                            decoration: BoxDecoration(),
                                            child: AppWidgets().text(
                                                text:
                                                    '${itemOrderList[index].item}',
                                                textsize: 14,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                            // decoration: BoxDecoration(
                                            //         border: Border.all(
                                            //             style: BorderStyle.solid)
                                            // ),
                                            alignment: Alignment.centerRight,
                                            child: AppWidgets().text(
                                                text:
                                                    '${itemOrderList[index].qty}',
                                                textsize: 16,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Container(
                                              padding:
                                                  EdgeInsets.only(right: 5),
                                              //     height:
                                              //         MediaQuery.of(context).size.width /
                                              //             25,
                                              //     decoration: BoxDecoration(
                                              //         border: Border.all(
                                              //             style: BorderStyle.solid)),
                                              alignment: Alignment.centerRight,
                                              child: AppWidgets().text(
                                                  text:
                                                      '${itemOrderList[index].rate}',
                                                  textsize: 16,
                                                  fontWeight:
                                                      FontWeight.w500))),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                            padding: EdgeInsets.only(right: 5),
                                            //     decoration: BoxDecoration(
                                            //         border: Border.all(
                                            //             style: BorderStyle.solid)),
                                            alignment: Alignment.centerRight,
                                            child: calculateAmount(
                                                itemOrderList[index].qty,
                                                itemOrderList[index].rate)),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(5)),
                              ],
                            ),
                            background: slideRightBackground(),
                            secondaryBackground: slideLeftBackground(),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.endToStart) {
                                // final bool res =
                                await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: AppWidgets().text(
                                            text:
                                                "Are you sure you want to delete ${itemOrderList[index].item}?"),
                                        actions: [
                                          FlatButton(
                                            child: AppWidgets().text(
                                                text: "Cancel",
                                                color: Colors.black),
                                            onPressed: () {
                                              setState(() {
                                                Navigator.of(context)
                                                    .pop(false);
                                              });
                                            },
                                          ),
                                          FlatButton(
                                            child: AppWidgets().text(
                                              text: "Delete",
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              // TODO: Delete the item from DB etc..
                                              setState(() {
                                                deleteItemfromShopOrder(index);
                                                itemOrderList.removeAt(index);
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                                // return res;
                              } else if (direction ==
                                  DismissDirection.startToEnd) {
                                await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: TextFormField(
                                          controller: qtyController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              hintText: 'Enter the Quantity'),
                                        ),
                                        actions: [
                                          FlatButton(
                                            child: AppWidgets().text(
                                              text: "Cancel",
                                              color: Colors.black,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                Navigator.of(context)
                                                    .pop(false);
                                              });
                                            },
                                          ),
                                          FlatButton(
                                            child: AppWidgets().text(
                                              text: "Ok",
                                              color: Colors.green,
                                            ),
                                            onPressed: () {
                                              NewOrderListShop shopOrder =
                                                  NewOrderListShop();
                                              shopOrder.item_code =
                                                  itemOrderList[index]
                                                      .item_code;
                                              shopOrder.distributor =
                                                  itemOrderList[index]
                                                      .distributor;
                                              shopOrder.longitude =
                                                  itemOrderList[index]
                                                      .longitude;
                                              shopOrder.isSubmited = 0;
                                              shopOrder.latitude =
                                                  itemOrderList[index].latitude;
                                              shopOrder.item =
                                                  itemOrderList[index].item;
                                              shopOrder.item_group =
                                                  itemOrderList[index]
                                                      .item_group;
                                              shopOrder.rate =
                                                  itemOrderList[index].rate;
                                              shopOrder.qty =
                                                  qtyController.text;
                                              shopOrder.shop_code =
                                                  itemOrderList[index]
                                                      .shop_code;

                                              deleteItemfromShopOrder(index);
                                              updateNewQty(shopOrder);
                                              setState(() {
                                                qtyController.text = '';
                                                getList();
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              }
                              ;
                            });
                      })),
                ))
          ],
        ),
      )),
      floatingActionButton: getFloatingActionButton(),
    );
  }

  deleteItemfromShopOrder(index) async {
    var item_code = itemOrderList[index].item_code;
    await LocalStorage()
        .deleteItemfromShopOrder(shopDetails['Shop_code'], item_code);
    // setState(() {});
  }

  getFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: App_Colors().appTextColorViolet,
      onPressed: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ItemOrderPage1()));
      },
      child: Icon(Icons.add),
    );
  }

  Future getShopDetails() async {
    await MyApp().getShopDetails().then((value) {
      shopDetails = value;
    });
    getList();
    setState(() {});
  }

  calculateAmount(qty, rate) {
    var amount = int.parse(qty) * double.parse(rate);

    return AppWidgets()
        .text(text: '$amount', textsize: 16, fontWeight: FontWeight.w500);
  }

  //--------- when the List Container Swipes from Left to Right ---------//

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              " Edit",
              style: GoogleFonts.notoSans(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

//--------- when the List Container Swipes from Right to Left -----------//
  Widget slideLeftBackground() {
    return Container(
      color: App_Colors().appRed,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: App_Colors().appBackground1,
            ),
            Text(
              " Delete",
              style: GoogleFonts.notoSans(
                color: App_Colors().appBackground1,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Future getList() async {
    bool isItemPresent = false;
    await LocalStorage()
        .getShopOrderListDb(shopDetails['Shop_code'], 0)
        .then((value) {
      totalAmount = 0;
      itemOrderList.clear();
      for (var item in value) {
        if (itemOrderList.length >= 1) {
          isItemPresent = false;
          for (int i = 0; i < itemOrderList.length; i++) {
            if (itemOrderList[i].item_code == item.item_code) {
              itemOrderList[i].qty =
                  (int.parse(itemOrderList[i].qty.toString()) +
                          int.parse(item.qty.toString()))
                      .toString();
              isItemPresent = true;
            }
          }
          if (!isItemPresent) {
            itemOrderList.add(item);
          }
        } else {
          itemOrderList.add(item);
        }
      }
      for (var item in itemOrderList) {
        totalAmount = totalAmount +
            (int.parse((item.qty).toString()) *
                double.parse((item.rate).toString()));
      }
      setState(() {});
    });
  }

  Future updateNewQty(NewOrderListShop shopOrder) async {
    await LocalStorage().insertToDB(itemsOrderListShop: shopOrder);
    getList();
    setState(() {});
  }

  orderButtonPressed() async {
    if (itemOrderList.isEmpty) {
      EasyLoading.showToast('Please Add Items to Create Order',
          duration: Duration(seconds: 1));
    } else {
      List<Map> li = [];
      var latitude, longitude;
      itemOrderList.forEach((element) {
        li.add({
          "item_code": element.item_code,
          "qty": element.qty,
          "rate": element.rate
        });
        latitude = element.latitude;
        longitude = element.longitude;
      });
      try {
        ApiServices()
            .placeOrderShop(context, shopDetails['Shop_code'], distributor, li,
                latitude, longitude)
            .then((value) {
          if (value['success']) {
            LocalStorage().deleteShopOrder(shopDetails['Shop_code'], 0);
            itemOrderList.clear();
            EasyLoading.showToast('${value['message']}');
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: ((context) => ShopOrderPage())));
          }
        });
      } catch (e) {
        {
          await LocalStorage().updateShopOrder(shopDetails['Shop_code']);
        }
      }
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ShopOrderPage()),
          (route) => false);
    }
  }

  getDistributor() async {
    await MyApp().getSelectedDistributor().then((value) => distributor = value);
    setState(() {});
  }
}

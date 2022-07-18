import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swarnamordermanagement/Model/Order/distributorOrderList.dart';
import 'package:swarnamordermanagement/View/AppColors/appColors.dart';
import 'package:swarnamordermanagement/View/Widgets/appWidgets.dart';
import 'package:swarnamordermanagement/main.dart';

import '../../Services/API/apiServices.dart';
import '../../Services/Database/localStorage.dart';
import 'itemOrderPage.dart';

class NewOrderDistributor extends StatefulWidget {
  const NewOrderDistributor({Key? key}) : super(key: key);

  @override
  State<NewOrderDistributor> createState() => _NewOrderDistributorState();
}

class _NewOrderDistributorState extends State<NewOrderDistributor> {
  List<NewOrderListDistributor> itemOrderList = [];
  TextEditingController qtyController = TextEditingController();
  var name, mobile, distributor_code, executive;
  double totalAmount = 0;
  Map distributorDetails = {};
  @override
  void initState() {
    // TODO: implement initState
    getDistributorDetais();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(padding: EdgeInsets.all(5)),
            Container(
              // margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(3),
              height: MediaQuery.of(context).size.height / 7,
              decoration: BoxDecoration(
                  color: App_Colors().appWhite,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 1.0),
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 1,
                        spreadRadius: 3),
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
                                      text:
                                          '${distributorDetails['Distributor_name']}',
                                      textsize: 16,
                                      maxLines: 2),
                                  AppWidgets().text(
                                      text:
                                          '${distributorDetails['Distributor_Mobile']}',
                                      textsize: 14),
                                ]),
                          ),
                          flex: 5,
                        )
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
                            text: 'ORDERS',
                            color: App_Colors().appBackground1,
                            textsize: 16)))
              ],
            ),
            Padding(padding: EdgeInsets.all(5)),
            Expanded(
                flex: 12,
                child: Container(
                  // margin: EdgeInsets.all(2),
                  // padding: EdgeInsets.all(3),
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
                                  padding: EdgeInsets.all(3),
                                  alignment: Alignment.center,
                                  height:
                                      MediaQuery.of(context).size.height / 12,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors
                                          .white, //App_Colors().appBackground1,
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(2, 3),
                                            color: Colors.grey.withOpacity(0.3),
                                            blurRadius: 1,
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
                                              fontWeight: FontWeight.w500,
                                            )),
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
                                                fontWeight: FontWeight.bold)),
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
                                                      FontWeight.bold))),
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
                                SizedBox(height: 5)
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
                                                color: Colors.red),
                                            onPressed: () {
                                              // TODO: Delete the item from DB etc..
                                              setState(() {
                                                deleteItemfromDistributorOrder(
                                                    index);
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
                                                text: "Ok",
                                                color: Colors.green),
                                            onPressed: () {
                                              NewOrderListDistributor
                                                  distributorOrder =
                                                  NewOrderListDistributor();
                                              var itemOrderList;
                                              distributorOrder.item_code =
                                                  itemOrderList[index]
                                                      .item_code;
                                              distributorOrder
                                                      .distributor_name =
                                                  itemOrderList[index]
                                                      .distributor;

                                              distributorOrder.isSubmited = 0;

                                              distributorOrder.item =
                                                  itemOrderList[index].item;
                                              distributorOrder.item_group =
                                                  itemOrderList[index]
                                                      .item_group;
                                              distributorOrder.rate =
                                                  itemOrderList[index].rate;
                                              distributorOrder.qty =
                                                  qtyController.text;
                                              distributorOrder
                                                      .distributor_code =
                                                  itemOrderList[index]
                                                      .distributor_code;

                                              deleteItemfromDistributorOrder(
                                                  index);
                                              updateNewQty(distributorOrder);
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

  calculateAmount(qty, rate) {
    var amount = int.parse(qty) * double.parse(rate);

    return AppWidgets()
        .text(text: '$amount', textsize: 16, fontWeight: FontWeight.bold);
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

  Future updateNewQty(NewOrderListDistributor distributorOrder) async {
    await LocalStorage().insertToDB(itemOrderListDistributor: distributorOrder);
    getList();
    setState(() {});
  }

  Future getDistributorDetais() async {
    await MyApp().getDistributorsDetails().then((value) {
      distributorDetails = value;
    });
    getList();
    setState(() {});
  }

  deleteItemfromDistributorOrder(index) async {
    var item_code = itemOrderList[index].item_code;
    await LocalStorage().deleteItemfromDistributorOrder(
        distributorDetails['Distributor_code'], item_code);
    // setState(() {});
  }

  Future getList() async {
    bool isItemPresent = false;
    await LocalStorage()
        .getDistributorOrderListDb(distributorDetails['Distributor_code'], 0)
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
    });
    setState(() {});
  }

  orderButtonPressed() async {
    List<Map> orderitemList = [];
    if (itemOrderList.isEmpty) {
      EasyLoading.showToast('Please Add Items to Create Order',
          duration: Duration(seconds: 1));
      setState(() {});
    } else {
      await getEecutive();
      List<Map> li = [];
      itemOrderList.forEach((element) {
        li.add({
          "item_code": element.item_code,
          "qty": double.parse(element.qty.toString()),
          "rate": double.parse(element.rate.toString())
        });
      });
      try {
        ApiServices()
            .placeOrderDistributor(context,
                distributor: distributorDetails['Distributor_code'],
                orderlist: li,
                executive: executive)
            .then((value) async {
          if (value['success']) {
            await LocalStorage().deleteDistributorOrder(
                distributorDetails['Distributor_code'], 0);
            itemOrderList.clear();
            EasyLoading.showToast('${value['message']}');
            // setState(() {});
          }
        });
      } catch (e) {
        await LocalStorage()
            .updateDistributor(distributorDetails['Distributor_code']);
        itemOrderList.clear();
        EasyLoading.showToast(
            'You are ofline now \n Order wil be created latter',
            duration: Duration(seconds: 2),
            toastPosition: EasyLoadingToastPosition.bottom);
      }
      itemOrderList.clear();
      Navigator.pop(context);
    }
  }

  getEecutive() async {
    await MyApp().getSelectedExecutive().then((value) => executive = value);
    setState(() {});
  }
}

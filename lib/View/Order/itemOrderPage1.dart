import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swarnamordermanagement/Model/Item/itemListModel.dart';
import 'package:swarnamordermanagement/Model/Order/distributorOrderList.dart';
import 'package:swarnamordermanagement/Model/Order/shopOrderListModel.dart';
import 'package:swarnamordermanagement/Services/Database/localStorage.dart';
import 'package:swarnamordermanagement/View/Order/newDistributorOrderPage.dart';
import 'package:swarnamordermanagement/View/Order/newShopOrderPage.dart';

import '../../Services/API/apiServices.dart';
import '../../main.dart';
import '../AppColors/appColors.dart';
import '../Widgets/appWidgets.dart';

class ItemOrderPage1 extends StatefulWidget {
  const ItemOrderPage1({Key? key}) : super(key: key);

  @override
  State<ItemOrderPage1> createState() => _ItemOrderPage1State();
}

class _ItemOrderPage1State extends State<ItemOrderPage1>
    with TickerProviderStateMixin {
  List itemGroupList = [];
  List<ItemListModel> itemGroupitemList = [];
  List<TextEditingController> qtyController = [];
  List<ItemListModel> itemList = [];
  Map distributorDetails = {};
  List<Tab> itemGroupTabs = [];
  var tabindex;
  String? shop_code, selectedItemGroup, distributor;
  int? orderType, userType;
  late TabController tabController;
  @override
  void initState() {
    getOrderType();
    // TODO: implement initState
    super.initState();
    getItemGroupList();
    getDistributorDetails();
    getShopname();
    getUserType();

    tabController = TabController(length: itemGroupList.length, vsync: this);
    tabController.addListener(() {
      setState(() {
        tabindex = tabController.index;
        print(tabindex);
        selectedItemGroup = itemGroupList[tabindex];
        // getItemList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              // flex: ,
              child: Container(
            // color: App_Colors().appBlue,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: AppWidgets().text(
              text: 'Add Items',
              textsize: 25,
            ),
          )),
          Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
          Expanded(
            flex: 1,
            child: TabBar(
              labelColor: App_Colors().appBlack,
              isScrollable: true,
              tabs: itemGroupTabs,
              controller: tabController,
              onTap: (i) {
                selectedItemGroup = itemGroupList[i].toString();
                itemGroupitemList.clear();
                // print('print from setState ${itemList}');
                itemList.forEach((element) async {
                  if (element.item_group == selectedItemGroup) {
                    itemGroupitemList.add(element);
                  }
                });

                setState(() {});
                // getItemList();
                // getTextEditingControllerList();
              },
            ),
          ),
          Expanded(
            flex: 10,
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: tabController,
              dragStartBehavior: DragStartBehavior.start,
              children: itemGroupTabs.map((Tab tab) {
                String tablabel = tab.text!;
                return Container(
                  child: ListView.builder(
                      itemCount: itemGroupitemList.length,
                      itemBuilder: ((context, index) {
                        // getTextEditingControllerList();
                        // print(index);
                        if (itemGroupitemList.length > index) {
                          return Container(
                            color: App_Colors().appBackground1,
                            padding: EdgeInsets.all(8),
                            height: MediaQuery.of(context).size.height / 8,
                            child: Column(children: [
                              Expanded(
                                flex: 5,
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 4,
                                        child: Container(
                                          child: AppWidgets().text(
                                              text:
                                                  // 'name',
                                                  '${itemGroupitemList[index].item_name}',
                                              maxLines: 3,
                                              textsize: 14),
                                        )),
                                    Expanded(
                                        flex: 3,
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: AppWidgets().text(
                                              text:
                                                  // 'rate',
                                                  '${itemGroupitemList[index].item_price}',
                                              textsize: 18),
                                        )),
                                    Padding(
                                        padding: EdgeInsets.all(
                                            MediaQuery.of(context).size.width /
                                                12)),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: TextFormField(
                                          controller: itemGroupitemList[index]
                                              .qtyController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ]),
                          );
                        } else {
                          return SizedBox(height: 10);
                        }
                      })),
                );
              }).toList(),
            ),
          ),
          Expanded(
            // flex: 2,
            child: Container(
                padding: EdgeInsets.all(10),
                // height: MediaQuery.of(context).size.height / 30,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () {
                      addButtonPressed();
                    },
                    child: AppWidgets().text(text: 'ADD'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            App_Colors().appTextColorViolet)))),
          ),
        ],
      )),
    );
  }

  void getItemGroupList() async {
    Map result = {};
    if (itemGroupList.isEmpty) {
      await LocalStorage().getItemGroupList().then((value) {
        itemGroupTabs.clear();
        itemGroupList = value;
        for (var i in itemGroupList) {
          itemGroupTabs.add(Tab(text: i));
        }
      });
    }
    getItemList();
    setState(() {
      tabController = TabController(length: itemGroupList.length, vsync: this);
    });
  }

  void getItemList() async {
    await LocalStorage().getItems().then(((value) {
      qtyController.clear();
      int index = 0;
      for (var i in value) {
        qtyController.add(TextEditingController());
        itemList.add(ItemListModel(
            qtyController: qtyController[index],
            item_code: i.item_code.toString(),
            item_name: i.item_name.toString(),
            item_group: i.item_group.toString(),
            item_price: '${i.item_Price}',
            item_qty: qtyController[index].text.toString()));
        index++;
      }
    }));

    setState(() {
      selectedItemGroup = itemGroupList[0];
      itemList.forEach((element) {
        if (element.item_group == selectedItemGroup) {
          itemGroupitemList.add(element);
        }
      });
    });
  }

  void getShopname() async {
    await MyApp().getShopDetails().then((value) {
      shop_code = value['Shop_code'];
    });
    setState(() {});
  }

  void getUserType() async {
    await MyApp().getUserType().then((value) => userType = value);
    // print(userType);
    setState(() {});
  }

  getOrderType() async {
    await MyApp().getOrderType().then((value) => orderType = value);
    setState(() {});
  }

  void addButtonPressed() async {
    if (orderType == 0) {
      await MyApp().determinePosition();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      NewOrderListShop shopOrderlist = NewOrderListShop();
      for (var i in itemList) {
        if (i.qtyController.text != '') {
          shopOrderlist.item_code = i.item_code;
          shopOrderlist.item = i.item_name;
          shopOrderlist.item_group = i.item_group;
          shopOrderlist.qty = i.qtyController.text;
          shopOrderlist.shop_code = shop_code;
          shopOrderlist.rate = i.item_price;
          shopOrderlist.distributor = distributor;
          shopOrderlist.latitude = position.latitude.toString();
          shopOrderlist.longitude = position.longitude.toString();
          await LocalStorage().insertToDB(itemsOrderListShop: shopOrderlist);
        }
      }
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => NewOrderShop()));
    }
    if (orderType == 1) {
      NewOrderListDistributor distributorOrderlist = NewOrderListDistributor();
      for (var i in itemList) {
        if (i.qtyController.text != '') {
          distributorOrderlist.item_code = i.item_code;
          distributorOrderlist.item = i.item_name;
          distributorOrderlist.item_group = i.item_group;
          distributorOrderlist.qty = i.qtyController.text;
          distributorOrderlist.rate = i.item_price;
          distributorOrderlist.isSubmited = 0;
          distributorOrderlist.distributor_name =
              distributorDetails['Distributor_name'];
          distributorOrderlist
            ..distributor_code = distributorDetails['Distributor_code'];
          await LocalStorage()
              .insertToDB(itemOrderListDistributor: distributorOrderlist);
        }
      }
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => NewOrderDistributor()));
    }
  }

  getDistributorDetails() async {
    await MyApp()
        .getDistributorsDetails()
        .then((value) => distributorDetails = value);
  }
}

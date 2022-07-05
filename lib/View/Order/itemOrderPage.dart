import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swarnamordermanagement/View/Order/newShopOrderPage.dart';

import '../../Model/Order/distributorOrderList.dart';
import '../../Model/Order/shopOrderListModel.dart';
import '../../Services/API/apiServices.dart';
import '../../Services/Database/localStorage.dart';
import '../../main.dart';
import '../AppColors/appColors.dart';
import 'newDistributorOrderPage.dart';

class ItemOrderPage extends StatefulWidget {
  const ItemOrderPage({Key? key}) : super(key: key);

  @override
  State<ItemOrderPage> createState() => ItemOrderPageState();
}

List itemGroupList = [];

class ItemOrderPageState extends State<ItemOrderPage>
    with TickerProviderStateMixin {
  // List itemOrderList = [];

  List itemList = [];
  int? userType;
  int? orderType;
  var tabindex;
  late TabController tabController;
  String? selectedItemGroup, shopName, distributorName, shop_code;
  List<TextEditingController> qtyController = [];
  ItemGroupTabsController titleTab = Get.put(ItemGroupTabsController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getItemGroupList();
    getShopname();
    getDistributorname();
    getUserType();
    getOrderType();
    // getItemList();
    tabController = TabController(length: itemGroupList.length, vsync: this);
    tabController.addListener(() {
      setState(() {
        tabindex = tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (itemGroupList.isEmpty) {
      getItemGroupList();
      return Center(child: CircularProgressIndicator());
    } else {
      // getItemList();
      return Scaffold(
        body: SafeArea(
            child: Column(
          children: [
            Expanded(
                // flex: ,
                child: Container(
              color: App_Colors().appBlue,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: Text(
                'Add Items',
                style: GoogleFonts.notoSans(
                    fontSize: 25, fontWeight: FontWeight.w800),
              ),
            )),
            Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
            Expanded(
              flex: 1,
              child: TabBar(
                labelStyle: TextStyle(color: Colors.black),
                isScrollable: true,
                tabs: titleTab.itemGroupTabs,
                controller: tabController,
                onTap: (index) {
                  selectedItemGroup = itemGroupList[index].toString();
                  getItemList();
                  // getTextEditingControllerList();
                },
              ),
            ),
            Expanded(
              flex: 10,
              child: TabBarView(
                controller: tabController,
                children: titleTab.itemGroupTabs.map((Tab tab) {
                  String tablabel = tab.text!;
                  return Container(
                    child: ListView.builder(
                        itemCount: itemList.length,
                        itemBuilder: ((context, index) {
                          getTextEditingControllerList();
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
                                          child: Text(
                                            '${itemList[index]['item_name']}',
                                            style: GoogleFonts.notoSans(
                                                fontSize: 16),
                                          ),
                                        )),
                                    Expanded(
                                        flex: 3,
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            '${itemList[index]['rate']}',
                                            style: GoogleFonts.notoSans(
                                                fontSize: 18),
                                          ),
                                        )),
                                    Padding(
                                        padding: EdgeInsets.all(
                                            MediaQuery.of(context).size.width /
                                                12)),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: TextFormField(
                                          controller: qtyController[index],
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
                      child: Text('ADD'),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              App_Colors().appTextColorYellow)))),
            ),
          ],
        )),
      );
    }
  }

  Expanded rowHead(text, flx) {
    return Expanded(
        flex: flx,
        child: Container(
          color: App_Colors().appBlue,
          alignment: Alignment.center,
          child: Text(
            text,
            style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
          ),
        ));
  }

  void getItemGroupList() async {
    Map result = {};
    if (itemGroupList.isEmpty) {
      await LocalStorage().getItemGroupList().then((value) {
        result = value['message'];
        titleTab.itemGroupTabs.clear();

        for (var item in result['item_group']) {
          // print(item);
          itemGroupList.add(item['name']);
          titleTab.itemGroupTabs.add(Tab(text: item['name']));
        }
      });
    }

    setState(() {
      // titleTab.onInit();
      tabController = TabController(length: itemGroupList.length, vsync: this);
      // titleTab.getTabInitialized();
    });
  }

  void addButtonPressed() async {
    var user;
    if (orderType == 0) {
      // order is a shop Order
      NewOrderListShop orderList = NewOrderListShop();
      for (var index = 0; index <= itemList.length; index++) {
        if ((qtyController[index].text != '0') &&
            (qtyController[index].text != '')) {
          orderList.shop_name = shopName;
          orderList.item_group = selectedItemGroup;
          orderList.item = itemList[index]['item_name'];
          orderList.item_code = itemList[index]['item_code'];
          orderList.rate = itemList[index]['rate'].toString();
          orderList.qty = qtyController[index].text;
          await LocalStorage().insertToDB(itemsOrderListShop: orderList);
        }
      }
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => NewOrderShop()));
    } else {
      NewOrderListDistributor orderList = NewOrderListDistributor();
      for (var index = 0; index <= itemList.length; index++) {
        if ((qtyController[index].text != '0') &&
            (qtyController[index].text != '')) {
          orderList.distributor_name = distributorName;
          orderList.item_group = selectedItemGroup;
          orderList.item = itemList[index]['item_name'];
          orderList.item_code = itemList[index]['item_code'];
          orderList.rate = itemList[index]['rate'].toString();
          orderList.qty = qtyController[index].text;
          await LocalStorage().insertToDB(itemOrderListDistributor: orderList);
        }
      }
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => NewOrderDistributor()));
    }
  }

  void getItemList() async {
    // await ApiServices().getItemList(context, selectedItemGroup).then((value) {
    //   // print(value['items']);
    //   itemList = value['items'];
    // });
    setState(() {});
  }

  void getTextEditingControllerList() {
    if ((itemList.length != 0) && (qtyController.length < itemList.length)) {
      for (int i = 0; i <= itemList.length; i++) {
        qtyController.add(TextEditingController());
      }
      // setState(() {});
    }
  }

  void getShopname() async {
    await MyApp().getShopDetails().then((value) {
      shop_code = value[''];
    });
    setState(() {});
  }

  void getUserType() async {
    await MyApp().getUserType().then((value) => userType = value);
    // print(userType);
    setState(() {});
  }

  void getDistributorname() async {
    // await MyApp()
    //     .getDistributorDetails()
    //     .then((value) => distributorName = value);
    setState(() {});
  }

  getOrderType() async {
    await MyApp().getOrderType().then((value) => orderType = value);
    setState(() {});
  }
}

class ItemGroupTabsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  List<Tab> itemGroupTabs = [];
  TabController? tabController;
  // AnimationController animationController;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // tabController = TabController(length: itemGroupList.length, vsync: this);
  }

  getTabInitialized() {
    tabController!.addListener(() {});
    tabController = TabController(length: itemGroupList.length, vsync: this);
    // itemGroupTabs.clear();
    // for (var name in itemGroupList) {
    //   itemGroupTabs.add(Tab(text: name));
    // }
  }
  // for(var name in itemGroupList){}
}

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swarnamordermanagement/Model/Item/itemListModel.dart';
import 'package:swarnamordermanagement/Services/Database/localStorage.dart';

import '../../Services/API/apiServices.dart';
import '../../main.dart';
import '../AppColors/appColors.dart';

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
  List<Tab> itemGroupTabs = [];
  var tabindex;
  String? shop_code, selectedItemGroup;
  int? orderType, userType;
  late TabController tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getItemGroupList();
    getShopname();
    getUserType();
    getOrderType();

    tabController = TabController(length: itemGroupList.length, vsync: this);
    tabController.addListener(() {
      setState(() {
        tabindex = tabController.index;
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
              labelColor: App_Colors().appBlack,
              isScrollable: true,
              tabs: itemGroupTabs,
              controller: tabController,
              onTap: (index) {
                setState(() {
                  selectedItemGroup = itemGroupList[index].toString();
                  itemGroupitemList.clear();
                  print('${itemList}');
                  itemList.forEach((element) {
                    if (element.item_group == selectedItemGroup) {
                      itemGroupitemList.add(element);
                    }
                  });
                });
                // getItemList();
                // getTextEditingControllerList();
              },
            ),
          ),
          Expanded(
            flex: 10,
            child: TabBarView(
              controller: tabController,
              children: itemGroupTabs.map((Tab tab) {
                String tablabel = tab.text!;
                return Container(
                  child: ListView.builder(
                      itemCount: itemGroupitemList.length,
                      itemBuilder: ((context, index) {
                        // getTextEditingControllerList();
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
                                          // 'name',
                                          '${itemGroupitemList[index].item_name}',
                                          style: GoogleFonts.notoSans(
                                              fontSize: 16),
                                        ),
                                      )),
                                  Expanded(
                                      flex: 3,
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          // 'rate',
                                          '${itemGroupitemList[index].item_price}',
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
      selectedItemGroup = itemGroupList[0];
      itemList.forEach((element) {
        if (element.item_group == selectedItemGroup) {
          itemGroupitemList.add(element);
        }
      });
    }));
    // await ApiServices().getItemList(context, selectedItemGroup).then((value) {
    //   // print(value['items']);
    //   List li = value['items'];
    //   itemList.clear();
    //   List<TextEditingController> qtyController = [];
    //   for (var i = 0; i < li.length; i++) {
    //     qtyController.add(TextEditingController());
    //     itemList.add(ItemListModel(
    //         qtyController: qtyController[i],
    //         item_code: li[i]['item_code'].toString(),
    //         item_name: li[i]['item_name'].toString(),
    //         item_group: li[i]['item_group'].toString(),
    //         item_price: li[i]['rate'].toString(),
    //         item_qty: qtyController[i].text));
    //   }
    //   // itemList = value['items'];
    // });
    setState(() {});
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

  getOrderType() async {
    await MyApp().getOrderType().then((value) => orderType = value);
    setState(() {});
  }

  void addButtonPressed() {}
}

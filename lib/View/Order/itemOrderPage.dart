import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swarnamordermanagement/Services/API/apiServices.dart';

import '../../Model/Item/itemListModel.dart';
import '../AppColors/appColors.dart';
import '../Widgets/appWidgets.dart';

class ItemOrderPage extends StatefulWidget {
  const ItemOrderPage({Key? key}) : super(key: key);

  @override
  State<ItemOrderPage> createState() => _ItemOrderPageState();
}

List itemGroupList = [];

class _ItemOrderPageState extends State<ItemOrderPage> {
  List<Tab> itemGroupTabs = [];
  List<ItemListModel> itemList = [];
  var selectedPage, selectedItemGroup;
  ItemGroupTabsController titleTab = Get.put(ItemGroupTabsController());
  int selectedPageindex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTabName();
    getItemGroupList();
  }

  @override
  Widget build(BuildContext context) {
    if (itemGroupList.isEmpty) {
      getItemGroupList();
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
              child: Column(children: [
            Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: AppWidgets().text(text: 'ORDER'),
                )),
            Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
            Expanded(
              flex: 1,
              child: TabBar(
                isScrollable: true,
                tabs: titleTab.itemGroupTabs,
                controller: titleTab.tabController,
                onTap: (index) {
                  selectedItemGroup = itemGroupList[index].toString();
                  getItemList();
                  // getTextEditingControllerList();
                },
              ),
            ),
          ])));
    }
  }

  getTabName() async {
    for (var i in itemGroupList) {
      itemGroupTabs.add(Tab(
        text: i,
      ));
    }
    setState(() {});
  }

  getItemGroupList() {
    itemGroupList = [
      'Gingely Oil',
      'Coconut Oil',
      'Dish Gold',
      'Bar Soap',
      'Riceban Oil'
    ];
    setState(() {
      titleTab.getTabInitialized();
    });
  }

  getItemList() {
    itemList = [];
  }
}

class ItemGroupTabsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  List<Tab> itemGroupTabs = [];
  ItemGroupTabsController titleTab = Get.put(ItemGroupTabsController());
  TabController? tabController;
  // AnimationController animationController;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    //itemTabController = TabController(length: itemGroupList.length, vsync: this);
  }

  getTabInitialized() {
    // itemGroupTabs.clear();
    // for (var name in itemGroupList) {
    //   itemGroupTabs.add(Tab(text: name));
    // }
  }
  // for(var name in itemGroupList){}
}

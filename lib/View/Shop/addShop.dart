import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:swarnamordermanagement/Model/Shop/shopmodel.dart';
import 'package:swarnamordermanagement/Services/API/apiServices.dart';
import 'package:swarnamordermanagement/View/AppColors/appColors.dart';
import 'package:swarnamordermanagement/View/Order/shopOrderPage.dart';
import 'package:swarnamordermanagement/View/Widgets/appWidgets.dart';

import '../../Services/Database/localStorage.dart';
import '../../main.dart';

class AddShopPage extends StatefulWidget {
  const AddShopPage({Key? key}) : super(key: key);

  @override
  State<AddShopPage> createState() => _AddShopPageState();
}

class _AddShopPageState extends State<AddShopPage> {
  TextEditingController shopNameController = TextEditingController();
  // TextEditingController branchNameController = TextEditingController();
  TextEditingController contactPersonController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  List distributorList = [];
  List routeList = [], shopType = [];
  String? selectedDistributor, selectedRoute, salesPerson, selectedShopType;
  int? orderType;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrderType();
    getSalesPerson();
    getShopTypeList();
  }

  @override
  Widget build(BuildContext context) {
    //
    // WillPopScope(onWillPop: onWillPop)
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    // color: App_Colors().appGreen,
                    child: AppWidgets().text(
                      color: App_Colors().appTextColorViolet,
                      text: 'Add Shop',
                      textsize: 30,
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1.2,
                  width: MediaQuery.of(context).size.width / 1.1,
                  // color: Colors.greenAccent,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        addShopTextFormFields(
                            hint: 'Shop Name',
                            controller: shopNameController),
                        Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.height / 90)),
                        // addShopTextFormFields(
                        //     hint: 'Branch/Location',
                        //     controller: branchNameController),
                        // Padding(
                        //     padding: EdgeInsets.all(
                        //         MediaQuery.of(context).size.height / 90)),
                        addShopTextFormFields(
                            hint: 'Mobile Number',
                            controller: mobileController,
                            isNumKeyBoard: true),
                        Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.height / 90)),
                        addShopTextFormFields(
                            hint: 'Contact Person',
                            controller: contactPersonController),
                        Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.height / 90)),
                        shopTypeDropDown(),
                        Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.height / 90)),
                        distributorDropDown(),
                        Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.height / 90)),
                        routeDropDown(),
                        Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.height / 90)),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    App_Colors().appTextColorViolet)),
                            onPressed: () {
                              addButtonPressed();
                            },
                            child: AppWidgets().text(
                                color: App_Colors().appBackground1,
                                text: 'ADD SHOP')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField addShopTextFormFields(
      {hint, controller, bool isNumKeyBoard = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: App_Colors().appTextColorYellow)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color.fromARGB(255, 2, 92, 29))),
          labelText: hint,
          labelStyle: TextStyle(color: Color.fromARGB(255, 2, 92, 29)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      keyboardType: isNumKeyBoard ? TextInputType.number : TextInputType.name,
    );
  }

  Widget distributorDropDown() {
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
          // await MyApp().saveSelectedDistributor(value.toString());

          selectedRoute = null;
          selectedDistributor = value!.toString();
          // routeList.clear();
          getRouteList(selectedDistributor);
          setState(() {});
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
          // await MyApp().saveSelectedRoute(value.toString());
          setState(() {
            selectedRoute = value.toString();
          });
        },
        value: selectedRoute,
      ),
    );
  }

  Widget shopTypeDropDown() {
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
        hint: Center(child: AppWidgets().text(text: 'Shop Type')),
        isExpanded: true,
        items: shopType
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
          // await MyApp().saveSelectedRoute(value.toString());
          setState(() {
            selectedShopType = value.toString();
          });
        },
        value: selectedShopType,
      ),
    );
  }

  Future<void> getRouteList(distributor) async {
    await LocalStorage().getRouteList(distributor).then((value) {
      routeList.clear();
      for (var i in value) {
        routeList.add(i);
      }
    });
    setState(() {});
    if (_AddShopPageState().mounted) {
      setState(() {});
    }
  }

  Future getDistributorsList() async {
    await LocalStorage().getDistributors(salesPerson).then(
      (value) {
        distributorList.clear();
        for (var i in value) {
          distributorList.add(i);
        }
      },
    );
    if (_AddShopPageState().mounted) {
      setState(() {});
    }
  }

  getOrderType() async {
    await MyApp().getOrderType().then((value) => orderType = value);
    setState(() {});
  }

  Future<void> getSalesPerson() async {
    await MyApp().getUserType().then((value) async {
      if (value == 1) {
        await MyApp()
            .getSelectedExecutive()
            .then((value) => salesPerson = value);
      } else {
        await MyApp().getSalesPerson().then((value) => salesPerson = value);
      }
    });

    setState(() {
      getDistributorsList();
    });
  }

  getShopTypeList() {
    shopType = ["Supermarket", "Retailer", "Wholesaler"];
    setState(() {});
  }

  addButtonPressed() async {
    if (shopNameController.text != '' &&
        mobileController.text.length != 0 &&
        contactPersonController.text != '' &&
        selectedDistributor != null &&
        selectedShopType != null &&
        selectedRoute != null) {
      var result = await ApiServices().addnewShop(context,
          shopname: shopNameController.text,
          mobile: mobileController.text,
          contactPerson: contactPersonController.text,
          distributor: selectedDistributor,
          route: selectedRoute,
          shopType: selectedShopType,
          sales_person: salesPerson);
      if (result['success']) {
        ShopModel newShop = ShopModel();
        newShop.name = shopNameController.text;
        newShop.distributor = selectedDistributor;
        newShop.executive = salesPerson;
        newShop.phone = mobileController.text;
        newShop.route = selectedRoute;
        newShop.shop_code = result['shop_code'].toString();
        await LocalStorage().insertToDB(shoplist: newShop);
        shopNameController.text = '';
        mobileController.text = '';
        contactPersonController.text = '';
        selectedDistributor = null;
        selectedShopType = null;
        selectedRoute = null;
        EasyLoading.showToast(result['message']);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) => ShopOrderPage())));
      } else {
        EasyLoading.showToast(result['message']);
      }
    } else {
      EasyLoading.showToast('All Fields are mandatyry');
    }
  }
}

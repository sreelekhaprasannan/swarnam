import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swarnamordermanagement/Model/Api/shopApiModel.dart';
import 'package:swarnamordermanagement/Model/Shop/shopmodel.dart';
import 'package:swarnamordermanagement/Services/API/apiServices.dart';
import 'package:swarnamordermanagement/Services/Database/localStorage.dart';
import 'package:swarnamordermanagement/View/AppColors/appColors.dart';
import 'package:swarnamordermanagement/View/Order/newShopOrderPage.dart';
import 'package:swarnamordermanagement/View/Order/orderHistoryPage.dart';
import 'package:swarnamordermanagement/View/Widgets/appWidgets.dart';
import 'package:swarnamordermanagement/main.dart';

class ShopOrderPage extends StatefulWidget {
  const ShopOrderPage({Key? key}) : super(key: key);

  @override
  State<ShopOrderPage> createState() => _ShopOrderPageState();
}

class _ShopOrderPageState extends State<ShopOrderPage> {
  List<ShopModel> shopList = [];
  String? executive, distributor, route;
  var userType;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getshopList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 5,
                  child: Container(
                    alignment: Alignment.center,
                    child: AppWidgets().text(text: 'SHOPS', textsize: 28),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: IconButton(
                        onPressed: () {}, icon: FaIcon(FontAwesomeIcons.add)),
                  )),
            ],
          ),
          Expanded(
              child: Container(
            height: 20,
            alignment: Alignment.center,
            padding: EdgeInsets.all(8),
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                  suffixIcon: FaIcon(FontAwesomeIcons.search, size: 32)),
            ),
          )),
          Expanded(
              flex: 10,
              child: Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(5),
                child: ListView.builder(
                    itemCount: shopList.length,
                    itemBuilder: ((context, index) {
                      return Container(
                        padding: EdgeInsets.all(15),
                        color: App_Colors().appShopBackGround,
                        margin: EdgeInsets.all(3),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppWidgets().text(
                                        text: '${shopList[index].name}',
                                        textsize: 20,
                                        color: App_Colors().appTextColorViolet),
                                    AppWidgets().text(
                                        text: '${shopList[index].branch}',
                                        textsize: 18,
                                        color: App_Colors().appTextColorViolet),
                                    AppWidgets().text(
                                        text: '${shopList[index].phone}',
                                        textsize: 14,
                                        color: App_Colors().appTextColorViolet),
                                    Padding(padding: EdgeInsets.all(5))
                                  ]),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                        iconSize: 35,
                                        onPressed: () async {
                                          await MyApp().saveShopDetails(
                                              shopList[index]
                                                  .shop_code
                                                  .toString(),
                                              shopList[index].name.toString(),
                                              shopList[index].branch.toString(),
                                              shopList[index].phone.toString());
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderHistoryPage()));
                                        },
                                        icon: Icon(Icons.history)),
                                  )
                                ],
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(5)),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    App_Colors()
                                                        .appTextColorViolet)),
                                        onPressed: () async {
                                          await MyApp().saveShopDetails(
                                              shopList[index]
                                                  .shop_code
                                                  .toString(),
                                              shopList[index].name.toString(),
                                              shopList[index].branch.toString(),
                                              shopList[index].phone.toString());
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NewOrderShop()));
                                        },
                                        child: AppWidgets().text(
                                            textsize: 12,
                                            text: 'ORDER',
                                            color: App_Colors().appWhite)),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    })),
              ))
        ],
      )),
    );
  }

  Future getshopList() async {
    await MyApp().getUserType().then((value) => userType = value);
    if (userType == 1) {
      await MyApp().getSelectedExecutive().then((value) => executive = value);
    } else {
      await MyApp().getSalesPerson().then((value) => executive = value);
    }
    await MyApp().getSelectedDistributor().then((value) => distributor = value);
    await MyApp().getSelectedRoute().then((value) => route = value);
    await LocalStorage()
        .getShopList(
            executive: executive, distributor: distributor, route: route)
        .then((value) {
      print(value);
      shopList = value;
      print('$shopList');
    });
    // await ApiServices().getShopList(context, route).then((value) {
    //
    //   shopList = value['shops'];
    // });
    setState(() {});
  }
}

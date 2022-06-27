import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swarnamordermanagement/View/AppColors/appColors.dart';
import 'package:swarnamordermanagement/View/Widgets/appWidgets.dart';

class ShopOrderPage extends StatefulWidget {
  const ShopOrderPage({Key? key}) : super(key: key);

  @override
  State<ShopOrderPage> createState() => _ShopOrderPageState();
}

class _ShopOrderPageState extends State<ShopOrderPage> {
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
                    itemCount: 15,
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
                                        text: 'Shop Name',
                                        textsize: 25,
                                        color: App_Colors().appTextColorViolet),
                                    AppWidgets().text(
                                        text: 'Branch',
                                        textsize: 18,
                                        color: App_Colors().appTextColorViolet),
                                    AppWidgets().text(
                                        text: 'Mobile Number',
                                        textsize: 14,
                                        color: App_Colors().appTextColorViolet),
                                    Padding(padding: EdgeInsets.all(5))
                                  ]),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [FaIcon(FontAwesomeIcons.history)],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                        onPressed: () {},
                                        child:
                                            AppWidgets().text(text: 'ORDER')),
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
}
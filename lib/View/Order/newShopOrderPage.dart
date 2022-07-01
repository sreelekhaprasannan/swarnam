import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../AppColors/appColors.dart';
import '../Widgets/appWidgets.dart';
import 'itemOrderPage.dart';

class NewOrderShop extends StatefulWidget {
  const NewOrderShop({Key? key}) : super(key: key);

  @override
  State<NewOrderShop> createState() => _NewOrderShopState();
}

class _NewOrderShopState extends State<NewOrderShop> {
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
              height: MediaQuery.of(context).size.height / 6,
              decoration: BoxDecoration(
                  color: App_Colors().appWhite,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        // offset: Offset(1.0, 1.0),
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
                                  AppWidgets().text(text: 'Name', textsize: 16),
                                  AppWidgets()
                                      .text(text: 'mobile', textsize: 14),
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
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child:
                          AppWidgets().text(text: 'order id : ', textsize: 14),
                    ),
                    Expanded(
                      child: AppWidgets().text(text: 'Total : ', textsize: 14),
                    )
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => ItemOrderPage())));
                        },
                        child: Text('ORDERS')))
              ],
            ),
            Expanded(
              flex: 18,
              child: Row(
                children: [Expanded(child: Container())],
              ),
            )
          ],
        ),
      )),
      floatingActionButton: getFloatingActionButton(),
    );
  }

  getFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {},
      child: Icon(Icons.add),
    );
  }
}

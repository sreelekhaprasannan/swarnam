import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swarnamordermanagement/Services/API/apiServices.dart';

import '../AppColors/appColors.dart';
import '../Widgets/appWidgets.dart';

class ItemOrderPage extends StatefulWidget {
  const ItemOrderPage({Key? key}) : super(key: key);

  @override
  State<ItemOrderPage> createState() => _ItemOrderPageState();
}

class _ItemOrderPageState extends State<ItemOrderPage> {
  late ScrollController itemGroupListScroller;
  late ScrollController itemNameListScroller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    itemGroupListScroller = ScrollController();
    itemNameListScroller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Column(
        children: [
          Padding(padding: EdgeInsets.all(2)),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                    // flex: 1,
                    child: Container(
                  alignment: Alignment.center,
                  child: AppWidgets().text(text: 'ITEM ORDER', textsize: 28),
                )),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                      controller: itemGroupListScroller,
                      scrollDirection: Axis.horizontal,
                      itemCount: 15,
                      itemBuilder: ((context, index) {
                        return Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.all(3),
                                child: AppWidgets().text(
                                    text: 'item Group Name',
                                    textsize: 20,
                                    color: App_Colors().appTextColorViolet),
                              ),
                            ),
                          ],
                        );
                      })),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: 10,
                itemBuilder: ((context, index) {
                  return Container(
                      child: Row(
                    children: [
                      Expanded(child: Text('Item Name')),
                      Expanded(child: Text('Rate')),
                      Expanded(child: Text('Qty')),
                    ],
                  ));
                })),
            flex: 10,
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () {}, child: AppWidgets().text(text: 'Save')),
              ),
            ],
          )
        ],
      )),
    );
  }
}

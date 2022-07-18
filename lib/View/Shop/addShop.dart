import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:swarnamordermanagement/View/AppColors/appColors.dart';
import 'package:swarnamordermanagement/View/Widgets/appWidgets.dart';

class AddShopPage extends StatefulWidget {
  const AddShopPage({Key? key}) : super(key: key);

  @override
  State<AddShopPage> createState() => _AddShopPageState();
}

class _AddShopPageState extends State<AddShopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  // color: App_Colors().appGreen,
                  child: AppWidgets().text(
                    text: 'Add Shop',
                    textsize: 40,
                  ),
                ),
              ),
              Expanded(child: TextFormField())
            ],
          ),
        ),
      ),
    );
  }
}

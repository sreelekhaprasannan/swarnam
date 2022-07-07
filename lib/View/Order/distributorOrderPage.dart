import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swarnamordermanagement/Services/Database/localStorage.dart';
import 'package:swarnamordermanagement/main.dart';

import '../../Model/Distributor/distributorModel.dart';
import '../AppColors/appColors.dart';
import '../Widgets/appWidgets.dart';
import 'newDistributorOrderPage.dart';

class DisributorOrderPage extends StatefulWidget {
  const DisributorOrderPage({Key? key}) : super(key: key);

  @override
  State<DisributorOrderPage> createState() => _DisributorOrderPageState();
}

class _DisributorOrderPageState extends State<DisributorOrderPage> {
  List<DistributorModel> distributorsList = [];
  @override
  void initState() {
    // TODO: implement initState
    getDistributorsList();
    super.initState();
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
                    child:
                        AppWidgets().text(text: 'DISTRIBUTORS', textsize: 28),
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
                    itemCount: distributorsList.length,
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
                                        text: '${distributorsList[index].name}',
                                        textsize: 20,
                                        color: App_Colors().appTextColorViolet),
                                    AppWidgets().text(
                                        text:
                                            '${distributorsList[index].mobile}',
                                        textsize: 14,
                                        color: App_Colors().appTextColorViolet),
                                    Padding(padding: EdgeInsets.all(5))
                                  ]),
                            ),
                            Padding(padding: EdgeInsets.all(3)),
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
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    App_Colors()
                                                        .appTextColorViolet)),
                                        onPressed: () async {
                                          await MyApp().saveDistributorDetails(
                                              distributorsList[index]
                                                  .distributor_code
                                                  .toString(),
                                              distributorsList[index]
                                                  .name
                                                  .toString(),
                                              distributorsList[index]
                                                  .mobile
                                                  .toString());
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: ((context) =>
                                                      NewOrderDistributor())));
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

  getDistributorsList() async {
    var executive;
    await MyApp().getSelectedExecutive().then((value) => executive = value);
    await LocalStorage().getDistributorsList(executive).then((value) {
      distributorsList.clear();
      for (var i = 0; i < value.length; i++) {
        distributorsList.add(value[i]);
      }
    });
    setState(() {});
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:swarnamordermanagement/View/AppColors/appColors.dart';
import 'package:swarnamordermanagement/View/Widgets/appWidgets.dart';
import 'package:swarnamordermanagement/main.dart';

class ReportHomePage extends StatefulWidget {
  const ReportHomePage({Key? key}) : super(key: key);

  @override
  State<ReportHomePage> createState() => _ReportHomePageState();
}

class _ReportHomePageState extends State<ReportHomePage> {
  var userType;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      padding: EdgeInsets.all(5),
      child: SingleChildScrollView(
          child: Column(
        children: [
          Center(
            child: Container(
              child: AppWidgets().text(text: 'REPORT', textsize: 28),
            ),
          ),
          getuserDisplay()
        ],
      )),
    )));
  }

  getUserType() async {
    await MyApp().getUserType().then((value) => userType = value);
    setState(() {});
  }

  Widget getuserDisplay() {
    switch (userType) {
      case 0: //user is Executive
        {
          return Container(
            margin: EdgeInsets.only(top: 25),
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              App_Colors().appTextColorViolet)),
                      onPressed: () {},
                      child: AppWidgets().text(
                          text: 'E P R', color: App_Colors().appBackground1)),
                ),
                Padding(padding: EdgeInsets.all(5)),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              App_Colors().appTextColorViolet)),
                      onPressed: () {},
                      child: AppWidgets().text(
                          text: 'Daily Sales Progress',
                          color: App_Colors().appBackground1)),
                ),
                Padding(padding: EdgeInsets.all(5)),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              App_Colors().appTextColorViolet)),
                      onPressed: () {},
                      child: AppWidgets().text(
                          text: 'Shop Sales Report',
                          color: App_Colors().appBackground1)),
                )
              ],
            ),
          );
        }
      case 1:
        {
          //user is an officer
          return Container();
        }
      default:
        {
          return Container();
        }
    }
  }
}

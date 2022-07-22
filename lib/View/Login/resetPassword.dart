import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:swarnamordermanagement/View/AppColors/appColors.dart';
import 'package:swarnamordermanagement/View/Login/loginScreen.dart';
import 'package:swarnamordermanagement/View/Widgets/appWidgets.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppWidgets().text(text: 'Reset Password', textsize: 20),
        backgroundColor: App_Colors().appStatuusBarColor,
      ),
      body: SafeArea(
          child: Container(
        margin: EdgeInsets.only(top: 15, left: 15, right: 15),
        child: Column(children: [
          Row(
            children: [
              Expanded(
                  child: Center(
                      child: Container(
                child:
                    AppWidgets().text(text: 'User Varification', textsize: 20),
              ))),
            ],
          ),
          Padding(padding: EdgeInsets.all(8)),
          Expanded(
              child: Container(
                  child: TextFormField(
            decoration: InputDecoration(labelText: 'Enter your Email'),
          ))),
          Expanded(
              child: AppWidgets().text(
                  maxLines: 2,
                  text:
                      '   You will get a Reset link in your mail\nfrom there you can reset your  Password')),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            App_Colors().appTextColorViolet)),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: AppWidgets().text(
                        text: 'RESET', color: App_Colors().appBackground1)),
              ),
              Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width / 50)),
              Expanded(
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            App_Colors().appTextColorViolet)),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: AppWidgets().text(
                        text: 'Cancel', color: App_Colors().appBackground1)),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          )
        ]),
      )),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swarnamordermanagement/Services/API/apiServices.dart';
import 'package:swarnamordermanagement/Services/Database/localStorage.dart';
import 'package:swarnamordermanagement/View/AppColors/appColors.dart';
import 'package:swarnamordermanagement/View/Home/loginHome.dart';
import 'package:swarnamordermanagement/View/Login/loginScreen.dart';

import '../../main.dart';

class AppWidgets extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    throw UnimplementedError();
  }

  appBar(context, attendanceStatus) {
    return Container(
      padding: EdgeInsets.only(left: 2, right: 5),
      height: MediaQuery.of(context).size.height / 20,
      color: App_Colors().appWhite,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        IconButton(
            onPressed: () async {
              attendanceStatus = await markAttendance(context);
              await MyApp().saveAttendaceStatus(attendanceStatus);
              LoginHome().createState();
            },
            icon: getAttendanceIcon(context, attendanceStatus)),
        IconButton(
            onPressed: () async {
              await LocalStorage().logOutfromApp();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            icon: FaIcon(
              size: MediaQuery.of(context).size.height / 23,
              Icons.logout,
              color: App_Colors().appTextColorYellow,
            )),
      ]),
    );
  }

  Widget getAttendanceIcon(context, attendanceStatus) {
    if (attendanceStatus == 1) {
      // late Attendance
      return attendanceIcon(
          context, FontAwesomeIcons.userClock, App_Colors().appLightBlue);
    } else if (attendanceStatus == 2) {
      // Present
      return attendanceIcon(
          context, FontAwesomeIcons.userCheck, App_Colors().appLightGreen);
    } else {
      // Absent
      return attendanceIcon(
          context, FontAwesomeIcons.userXmark, App_Colors().appRed);
    }
  }

  FaIcon attendanceIcon(context, icon, color) {
    return FaIcon(
      icon,
      size: MediaQuery.of(context).size.height / 28,
      color: color,
    );
  }

  logo({double? height = 25, double? width = 25}) {
    return Container(
      height: height,
      width: width,
      child: Image(image: AssetImage('lib/Images/swarnam_logo.png')),
    );
  }

  text(
      {String? text,
      double? textsize = 14,
      Color? color: Colors.black,
      FontWeight? fontWeight = FontWeight.normal,
      int? maxLines = 1}) {
    return Text(
      '$text',
      style:
          TextStyle(fontSize: textsize, color: color, fontWeight: fontWeight),
      maxLines: maxLines,
    );
  }

  markAttendance(context) async {
    var status;
    await MyApp().determinePosition();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    await ApiServices().markAttendence(context, position).then((value) {
      status = value['attendance'];
      MyApp().saveAttendaceStatus(status);
      EasyLoading.showToast('${value['message']}',
          duration: Duration(seconds: 1));
    });
    return status;
  }
}

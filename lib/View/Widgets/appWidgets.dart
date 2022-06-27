import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swarnamordermanagement/View/AppColors/appColors.dart';

class AppWidgets extends StatefulWidget {
  int attendanceStatus = 2;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

  appBar(context) {
    return Container(
      padding: EdgeInsets.only(left: 2, right: 5),
      height: MediaQuery.of(context).size.height / 20,
      color: App_Colors().appWhite,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        IconButton(
            onPressed: () {},
            icon: FaIcon(
              size: MediaQuery.of(context).size.height / 23,
              Icons.settings,
              color: App_Colors().appTextColorYellow,
            )),
        IconButton(onPressed: () {}, icon: getAttendanceIcon(context)),
      ]),
    );
  }

  getAttendanceIcon(context) {
    if (attendanceStatus == 0) {
      return attendanceIcon(
          context, FontAwesomeIcons.userXmark, App_Colors().appRed);
    }
    if (attendanceStatus == 1) {
      return attendanceIcon(
          context, FontAwesomeIcons.userClock, App_Colors().appLightBlue);
    }
    if (attendanceStatus == 2) {
      return attendanceIcon(
          context, FontAwesomeIcons.userCheck, App_Colors().appLightGreen);
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
      style: GoogleFonts.robotoSlab(
          fontSize: textsize, color: color, fontWeight: fontWeight),
      maxLines: maxLines,
    );
  }
}

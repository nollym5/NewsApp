import 'package:flutter/material.dart';
import 'package:rich_alert/rich_alert.dart';
const kApiUrl = 'http://api.freshmark/';
const Map<String, String> kPostHeaders = {"Accept": "application/json"};

///COLOURS
const kAppGreenColour = Color(0xFF448c44);
const kAppDarkColour = Color(0xFF000000);
const kAppRedColour = Color(0xFFb90303);
const kAppGreenONE = Color(0xFF5B8C5B);
const kAppGreenTWO = Color(0xFF678867);
const kAppWhiteColour = Color(0xFFFFFFFF);
const kAppGreyColour = Color(0xFF2F4F4F);

/// Form Errors
String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Invalid Email Address';
  } else {
    return null;
  }
}

String validateName(String value) {
  if (value == '') {
    return 'Name cannot be empty';
  } else {
    return null;
  }
}

String validateRole(dynamic value) {
  if (value == null) {
    return 'Please select a role';
  } else {
    return null;
  }
}

const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kNamelNullError = "Please Enter your name";

const defaultDuration = Duration(milliseconds: 250);
const kPrimaryColor = Color(0xFFFF7643);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF83C222), Color(0xFF678864)],
);

const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);
const kAnimationDuration = Duration(milliseconds: 200);

///Border
OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15.0),
    borderSide: BorderSide(color: kTextColor),
  );
}
OutlineInputBorder errorInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(28.0),
    borderSide: BorderSide(color: Colors.red,),
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
    centerTitle: true,
    color: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Color(0xFF8B8B8B),
        fontSize: 18,
      ),
    ),
  );
}

TextTheme textTheme() {
  return TextTheme(
      bodyText1: TextStyle(color: kTextColor),
      bodyText2: TextStyle(color: kTextColor));
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    borderSide: BorderSide(color: kTextColor),
    gapPadding: 10,
  );
  return InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      errorBorder: errorInputBorder(),
      border: outlineInputBorder);
}
TargetPlatform getDevicePlatform(BuildContext context) {
  final ThemeData themeData = Theme.of(context);
  assert(themeData.platform != null);
  return themeData.platform;
}

Widget progressIndicator(){
  return Container(
    color: Colors.white,
    child: Center(
      child: CircularProgressIndicator(
        backgroundColor: kAppGreenColour,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    ),
  );
}

void androidAlertDialog(
    BuildContext context, String bodyText,
    {String titleText, onYesPressed(),onNoPressed()}) {
  showDialog(
    useSafeArea: true,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: titleText != null ? Text(titleText) : Text(''),
        content: Text(bodyText),
        actions: <Widget>[
          FlatButton(
            onPressed: onYesPressed,
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Yes",
                style: TextStyle(
                  fontFamily: 'Muli',
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            color: kAppGreenColour,
            /*shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),*/
          ),
          FlatButton(
            onPressed: onNoPressed,
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "No",
                style: TextStyle(
                  fontFamily: 'Muli',
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            color: kAppGreenColour,
            /*shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),*/
          ),
        ],
      );
    },
  );
}

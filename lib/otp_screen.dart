import 'package:flutter/material.dart';
import 'package:industry_app/constants.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:industry_app/dashboard_screen.dart';
import 'package:industry_app/device_data_provider.dart';
import 'package:industry_app/size_config.dart';
import 'package:intl/intl.dart';
import 'package:industry_app/user_provider.dart';
import 'package:provider/provider.dart';

import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:otp_text_field/otp_text_field.dart';

class OTPScreen extends StatefulWidget {
  static String routeName = "/otp";
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  Future<DeviceData> deviceData;

  @override
  void didChangeDependencies() {
    deviceData = _getDeviceData();
    super.didChangeDependencies();
  }

  Future<DeviceData> _getDeviceData() async {
    return await Provider.of<DeviceDataProvider>(context).getDeviceData();
  }

  String otpCode, email;

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserProvider>(context);
    return Scaffold(
      //backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ), //      Icons.arrow_back),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
          child: FutureBuilder(
            future: deviceData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                email = snapshot.data.email;
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Text(
                        'Verification',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kAppGreenColour,
                          height: 1.5,
                          fontSize: MediaQuery.of(context).size.width * 0.08,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Center(
                        child: Text('Enter A 6 Digit Number That Was Sent To'),
                      ),
                      Center(
                        child: Text(email),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06),
                      Container(
                        //color: kAppRedColour,
                        // padding: EdgeInsets.all(
                        //    MediaQuery.of(context).size.width * 0.012),
                        child: OtpTextField(
                          hasCustomInputDecoration: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            counterStyle: TextStyle(color: Colors.white),
                            focusColor: kAppGreenColour,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: kAppGreenColour,
                                ),
                                gapPadding: 10),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: kAppGreenColour),
                              gapPadding: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: kAppGreenColour),
                              gapPadding: 5,
                            ),
                          ),
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          keyboardType: TextInputType.number,
                          borderRadius: BorderRadius.all(Radius.circular(9.0)),
                          fieldWidth: MediaQuery.of(context).size.width * 0.121,
                          numberOfFields: 6,
                          borderWidth: 1.5,
                          filled: false,
                          margin: const EdgeInsets.all(8.0),
                          showFieldAsBox: true,
                          borderColor: kAppGreenColour,
                          cursorColor: kAppGreenColour,
                          enabledBorderColor: kAppGreenColour,
                          focusedBorderColor: kAppGreenColour,
                          autoFocus: true,
                          obscureText: false,
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          onCodeChanged: (String code) {
                            print(code);
                          },
                          onSubmit: (String code) async {
                            otpCode = code;
                            //Verify otp with one sent
                            var verified =
                                await userData.verifyOTP(email, otpCode);
                            if (verified == "verified") {
                              /*Fluttertoast.showToast(
                                  msg: "You have successfully registered!",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: kAppGreyColour,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              Navigator.pushReplacementNamed(
                                  context, DashboardScreen.routeName);*/
                            } else {
                              //var resend = await ;
                              /* Fluttertoast.showToast(
                                  msg: "WRONG, we have resent your otp",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 3,
                                  backgroundColor: kAppGreyColour,
                                  textColor: Colors.white,
                                  fontSize: 16.0);*/
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: kAppGreenColour,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

/*
OtpTextField(
crossAxisAlignment: CrossAxisAlignment.center,
mainAxisAlignment: MainAxisAlignment.center,
keyboardType: TextInputType.number,
*/
/*borderRadius:
                                BorderRadius.all(Radius.circular(9.0)),*/ /*

fieldWidth:
MediaQuery.of(context).size.width * 0.121,
numberOfFields: 6,
borderWidth: 1.5,
//filled: false,
margin: const EdgeInsets.all(8.0),
showFieldAsBox: true,
borderColor: kAppGreenColour,
cursorColor: kAppGreenColour,
disabledBorderColor: kAppGreyColour,
enabledBorderColor: kAppGreenColour,
focusedBorderColor: kAppGreenColour,
autoFocus: true,
obscureText: false,
textStyle: TextStyle(
color: Colors.black,
backgroundColor: Colors.black,
fontWeight: FontWeight.w500,
),
onCodeChanged: (String code) {
print(code);
},
onSubmit: (String code) async {
otpCode = code;
//Verify otp with one sent
var verified =
    await userData.verifyOTP(email, otpCode);
if (verified == "verified") {
print(otpCode);
Fluttertoast.showToast(
msg: "You have successfully registered!",
toastLength: Toast.LENGTH_LONG,
gravity: ToastGravity.BOTTOM,
timeInSecForIosWeb: 1,
backgroundColor: kAppGreyColour,
textColor: Colors.white,
fontSize: 16.0);
Navigator.pushReplacementNamed(
context, DashboardScreen.routeName);
} else {
Fluttertoast.showToast(
msg: "WRONG, we have resent your otp",
toastLength: Toast.LENGTH_LONG,
gravity: ToastGravity.BOTTOM,
timeInSecForIosWeb: 3,
backgroundColor: kAppGreyColour,
textColor: Colors.white,
fontSize: 16.0);
}
},
),*/

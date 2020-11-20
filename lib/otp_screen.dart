import 'package:flutter/material.dart';
import 'package:industry_app/constants.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:industry_app/dashboard_screen.dart';
import 'package:industry_app/device_data_provider.dart';
import 'package:industry_app/size_config.dart';
import 'package:intl/intl.dart';
import 'package:industry_app/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

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
                            height: MediaQuery.of(context).size.height * 0.05),
                        Text(
                          'OTP Verification',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kAppGreenColour,
                              height: 1.5,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.08),
                        ),
                        Text('We sent your code to ${email}'),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.08),
                        Container(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.012),
                          child: OtpTextField(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            keyboardType: TextInputType.number,
                            borderRadius:
                                BorderRadius.all(Radius.circular(9.0)),
                            fieldWidth:
                                MediaQuery.of(context).size.width * 0.121,
                            numberOfFields: 6,
                            borderWidth: 1.5,
                            filled: true,
                            // fillColor: Colors.greenAccent,
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
                            // textStyle: TextStyle( fontSize:14,color: Colors.black),
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
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  print(snapshot.data.name);
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: kAppGreenColour,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}

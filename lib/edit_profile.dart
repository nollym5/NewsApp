import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:industry_app/constants.dart';
import 'package:industry_app/main.dart';
import 'package:industry_app/otp_screen.dart';
import 'package:industry_app/size_config.dart';
import 'package:device_info/device_info.dart';
import 'package:intl/intl.dart';
import 'package:industry_app/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:industry_app/device_data_provider.dart';

class EditProfile extends StatefulWidget {
  static String routeName = "/edit";
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  DateTime dateOfBirth = DateTime.now();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //appBar: App(),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          decoration: BoxDecoration(
            color: Colors.green[600],
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(40.0),
              bottomLeft: Radius.circular(40.0),
            ),
          ),
          height: 150,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}

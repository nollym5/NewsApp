import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:industry_app/constants.dart';
import 'package:http/http.dart' as http;

class DeviceData {
  final int id;
  final String deviceNumber;
  String active;
  String email;
  String name;
  String role;
  String role_desc;

  DeviceData(
      {this.id,
      this.deviceNumber,
      this.name,
      this.email,
      this.active,
      this.role,
      this.role_desc});
}

class DeviceDataProvider with ChangeNotifier {
  String _deviceNumber;
  DeviceData deviceData;

  Future<DeviceData> getDeviceData() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      _deviceNumber = iosDeviceInfo.identifierForVendor;
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      _deviceNumber = androidDeviceInfo.androidId;
    }
    print(_deviceNumber);
    Map<String, String> body = {"device_imei": _deviceNumber};

    http.Response deviceDataResponse = await http.post(
        '${kApiUrl}register/get-device-imei',
        headers: kPostHeaders,
        body: body);

    var deviceDataJson = jsonDecode(deviceDataResponse.body)['device_data'];

    if (deviceDataJson == 'error') {
      deviceData = DeviceData(
          id: null, deviceNumber: null, active: null, name: null, email: null,role: null,role_desc: null);
    } else {
      deviceData = DeviceData(
        id: deviceDataJson['id'],
        deviceNumber: deviceDataJson['device_imei'],
        active: deviceDataJson['active'],
        name: deviceDataJson['user_description'],
        email: deviceDataJson['email'],
        role: deviceDataJson['role'],
        role_desc: deviceDataJson['role_description']
      );
    }
    return deviceData;
  }

  String get deviceNumber => _deviceNumber;

  DeviceData get device => deviceData;
}

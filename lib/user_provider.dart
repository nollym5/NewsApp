import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:industry_app/constants.dart';


class UserProvider with ChangeNotifier {



  Future<dynamic> registerUser(String email, String name, String dateOfBirth,
      String device_imei, String role) async {
    Map<String, String> body = {
      'email': email,
      'user_description': name,
      'role': role,
      'date_of_birth': dateOfBirth,
      'device_imei': device_imei
    };

    http.Response response = await http.post(
        '${kApiUrl}register/register-person',
        headers: kPostHeaders,
        body: body);

    var jsonData = jsonDecode(response.body);

    return jsonData;
  }

  Future<List<dynamic>> getUserRoles() async {
    http.Response response =
        await http.get('${kApiUrl}register/get-user-roles');

    List<dynamic> jsonData = jsonDecode(response.body);

    return jsonData;
  }

  Future<String> verifyOTP(String email, String otp) async {
    Map<String, String> body = {
      'email': email,
      'activation_code': otp,
    };
    http.Response response = await http.post('${kApiUrl}register/verify-otp',
        headers: kPostHeaders, body: body);
    var jsonData = jsonDecode(response.body);
    return jsonData;
  }

  Future<String> getRoleDesc(String id) async {
    Map<String, String> body = {'id': id};
    http.Response response = await http.post(
        '${kApiUrl}register/get-role-description',
        headers: kPostHeaders,
        body: body);
    var jsonData = jsonDecode(response.body);
    return jsonData;
  }

  Future<dynamic> fetchNews() async {
    http.Response newsResponse = await http.get(
        "http://newsapi.org/v2/top-headlines?country=za&apiKey=55c03c15c0e540e2955e417e8edf5e67");

    if (newsResponse.statusCode == 200) {
      var newsJson = jsonDecode(newsResponse.body)['articles'];

      return newsJson;

    } else {
      print('error');

    }
  }
  Future<dynamic> deactivateAccount(String imei) async {
    Map<String, String> body = {'device_imei': imei};

    http.Response newsResponse = await http.post(
        '${kApiUrl}register/deactivate-account',
        headers: kPostHeaders,
        body: body);

    var deactivateJson = jsonDecode(newsResponse.body);

    return deactivateJson;

  }

}

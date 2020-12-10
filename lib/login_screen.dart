import 'package:flutter/material.dart';
import 'package:industry_app/constants.dart';
import 'package:industry_app/dashboard_screen.dart';
import 'package:industry_app/device_data_provider.dart';
import 'package:industry_app/register.dart';
import 'package:industry_app/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  static String routeName = '/login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var login;
  bool _isChecked = false;
  var _prefs = SharedPreferences.getInstance();
  var sharedPreferences;
  bool rememberMe;
  bool obscure = true;

  void _getPref() async {
    final SharedPreferences prefs = await _prefs;
    rememberMe = (prefs.getBool("rememberMe"));
    print(rememberMe);
    if (rememberMe == true) {
      Navigator.pushReplacementNamed(context, DashboardScreen.routeName);
    }
  }

  @override
  void initState() {
    _getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userdata = Provider.of<UserProvider>(context, listen: false);
    final deviceData = Provider.of<DeviceDataProvider>(context, listen: false);
    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Image.asset(
              "images/logo.png",
              height: ((205 / 812.0) * MediaQuery.of(context).size.height),
              width: ((205 / 375.0) * MediaQuery.of(context).size.width),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Text("Login",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kAppGreenColour,
                    height: 1.5,
                    fontSize: MediaQuery.of(context).size.width * 0.08)),
            Text(
              "Welcome to our app. Let's sign you up!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.032,
                  color: Colors.black),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  buildEmailFormField(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  buildPasswordFormField(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Row(
                    children: [
                      GestureDetector(
                        child: Row(
                          children: [
                            Checkbox(
                              value: _isChecked,
                              activeColor: kAppGreenColour,
                              onChanged: (bool value) async {
                                return setState(() {
                                  _isChecked = !_isChecked;
                                  print(_isChecked);

                                  //sharedPreferences.setString("imei", _passwordController.text);
                                });
                              },
                            ),
                            Text("Remember Me"),
                          ],
                        ),
                        onTap: () => setState(() {
                          _isChecked = !_isChecked;
                        }),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.height * 0.4,
                    height: MediaQuery.of(context).size.width * 0.12,
                    child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: kAppGreenColour,
                        child: Center(
                          child: Text(
                            "Login",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.0552),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();

                            sharedPreferences =
                                await SharedPreferences.getInstance();

                            print('${_emailController.text} email');

                            print('${_passwordController.text} password');

                            login = await userdata.loginUser(
                                _emailController.text,
                                _passwordController.text,deviceData.deviceNumber);

                            print(login);

                            if (login == "NotExist") {
                              print("user does not exist");
                            } else if (login == "NotMatch") {
                              print("password does not match");
                            } else if (login == "true") {
                              Navigator.pushReplacementNamed(
                                  context, DashboardScreen.routeName);

                              sharedPreferences.setString(
                                  "username", _emailController.text);
                              sharedPreferences.setBool(
                                  "rememberMe", _isChecked);
                              sharedPreferences.setString(
                                  "password", _passwordController.text);
                            }
                          }
                        }),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      validator: validateEmail,
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Please enter your email",
        hintStyle: TextStyle(color: Colors.grey),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(Icons.alternate_email_rounded),
      ),
    );
  }

  TextFormField buildPasswordFormField() {

    return TextFormField(
      obscureText: obscure,
      controller: _passwordController,
      validator: validatePassword,
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Please enter your password",
        hintStyle: TextStyle(color: Colors.grey),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(Icons.shield),
        suffixIcon: IconButton(
          icon: Icon(Icons.remove_red_eye),
          onPressed: () {
            if (obscure) {
              setState(() {
                obscure = false;
              });
            } else {
              setState(() {
                obscure = true;
              });
            }
          },
        ),
      ),
    );
  }

  String validatePassword(String value) {
    if (value == '') {
      return 'Password cannot be empty';
    } else if (login == "NotMatch") {
      return ' Wrong Password';
    } else {
      return null;
    }
  }
}

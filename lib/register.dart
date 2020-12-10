import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:industry_app/constants.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:industry_app/otp_screen.dart';
import 'package:intl/intl.dart';
import 'package:industry_app/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:industry_app/device_data_provider.dart';

class Register extends StatefulWidget {
  static String routeName = '/register';
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmController = new TextEditingController();
  String date;
  String role;
  int _myActivity;
  final _formKey = GlobalKey<FormState>();
  DateTime dateOfBirth = DateTime.now();
  Future<List<dynamic>> userRoles;
  Future<dynamic> data;
  bool obscure = true;
  bool obscure1 = true;

  @override
  void initState() {
    _myActivity = 1;
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    userRoles = _getRole();
    data = _getDeviceData();
    super.didChangeDependencies();
  }

  Future<List<dynamic>> _getRole() async {
    return await Provider.of<UserProvider>(context).getUserRoles();
  }

  Future<DeviceData> _getDeviceData() async {
    return await Provider.of<DeviceDataProvider>(context).getDeviceData();
  }

  @override
  Widget build(BuildContext context) {

    final userdata = Provider.of<UserProvider>(context, listen: false);
    final deviceData = Provider.of<DeviceDataProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.height * 0.02),
            child: FutureBuilder(
              future: userRoles,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04),
                        Image.asset(
                          "images/logo.png",
                          height: ((205 / 812.0) *
                              MediaQuery.of(context).size.height),
                          width: ((205 / 375.0) *
                              MediaQuery.of(context).size.width),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04),
                        Text("Register Account",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kAppGreenColour,
                                height: 1.5,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.08)),
                        Text(
                          "Welcome to our app. Let's sign you up!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.032,
                              color: Colors.black),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              buildEmailFormField(),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              buildNameFormField(),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              DropDownFormField(
                                filled: false,
                                value: _myActivity,
                                titleText: 'Role',
                                dataSource: snapshot.data,
                                textField: 'role_description',
                                valueField: 'id',
                                hintText: 'Please choose your role',
                                onChanged: (value) {
                                  setState(() {
                                    _myActivity = value;
                                  });
                                },
                                validator: validateRole,
                                onSaved: (value) {
                                  setState(() {
                                    _myActivity = value;
                                  });
                                },
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              pickDate(context),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              buildPasswordFormField(),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              buildConfirmPasswordFormField(),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              SizedBox(
                                width: MediaQuery.of(context).size.height * 0.4,
                                height:
                                    MediaQuery.of(context).size.width * 0.12,
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  color: kAppGreenColour,
                                  child: Center(
                                    child: Text(
                                      "Register",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.0552),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();

                                      if (DateFormat.yMMMd()
                                              .format(dateOfBirth) ==
                                          DateFormat.yMMMd()
                                              .format(DateTime.now())) {
                                        dateOfBirth = DateTime(0000, 01, 01);
                                      }
                                      print('$_myActivity role was picked');
                                      print(
                                          '${dateOfBirth.toString()} dob was picked');
                                      print('${_emailController.text} email');
                                      print('${_nameController.text} name');
                                      print('${deviceData.deviceNumber} imei');
                                      print('${_passwordController.text} password');
                                      var register =
                                          await userdata.registerUser(
                                              _emailController.text,
                                              _nameController.text,
                                              dateOfBirth.toString(),
                                              deviceData.deviceNumber,
                                              _myActivity.toString(),
                                          _passwordController.text);

                                      Navigator.pushNamed(
                                          context, OTPScreen.routeName);
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                              Text(
                                'By registering you are agreeing to our terms and conditions',
                                style: Theme.of(context).textTheme.caption,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.04),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Container(
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

  TextFormField buildConfirmPasswordFormField() {
    return TextFormField(
      obscureText: obscure1,
      controller: _confirmController,
      validator: validateConfirmPassword ,
      decoration: InputDecoration(
        labelText: "Confirm password",
        hintText: "Please confirm password",
        hintStyle: TextStyle(color: Colors.grey),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(Icons.shield),
        suffixIcon: IconButton(
          icon: Icon(Icons.remove_red_eye),
          onPressed: () {
            setState(() {
              if (obscure1) {
                obscure1 = false;
                print(obscure1);
              } else if (obscure1 == false) {
                obscure1 = true;
                print(obscure1);
              }
            });
          },
        ),
      ),
    );
  }

  String validatePassword(String value) {
    if (value == '') {
      return 'Password cannot be empty';
    } else if (value != _confirmController.text) {
      return 'Passwords do not match';
    } else {
      return null;
    }
  }

  String validateConfirmPassword(String value) {
    if (value == '') {
      return 'Password cannot be empty';
    } else if (value != _passwordController.text) {
      return 'Passwords do not match';
    } else {
      return null;
    }
  }
  TextFormField buildNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: "Fullname",
        prefixIcon: Icon(Icons.person),
        hintText: "Please enter your name",
        hintStyle: TextStyle(color: Colors.grey),
      ),
      controller: _nameController,
      validator: validateName,
    );
  }
  Widget buildDropDown(AsyncSnapshot<dynamic> snapshot) {
    return DropDownFormField(
      filled: false,
      value: _myActivity,
      titleText: 'Role',
      dataSource: snapshot.data,
      textField: 'role_description',
      valueField: 'id',
      hintText: 'Please choose your role',
      onChanged: (value) {
        setState(() {
          _myActivity = value;
        });
      },
      validator: validateRole,
      onSaved: (value) {
        setState(() {
          _myActivity = value;
        });
      },
    );
  }
  GestureDetector pickDate(BuildContext context) {
    final TargetPlatform platform = getDevicePlatform(context);
    return GestureDetector(
      onTap: () {
        return platform == TargetPlatform.android
            ? _androidDatePicker(context)
            : _iosDatePicker(context);
      },
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: 'Date of Birth',
            prefixIcon: Icon(
              Icons.calendar_today_outlined,
            ),
            hintText: DateFormat.yMMMd().format(dateOfBirth) ==
                    DateFormat.yMMMd().format(DateTime.now())
                ? 'Date of birth (Optional)'
                : DateFormat.yMMMd().format(dateOfBirth),
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  void _androidDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: dateOfBirth,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      helpText: 'Date Of Birth',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: kAppGreenColour),
          ),
          child: child,
        );
      },
      fieldHintText: 'Date of Birth (Optional)',
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
    );
    if (picked != null && picked != dateOfBirth)
      setState(() {
        dateOfBirth = picked;
        if (dateOfBirth == picked) {
          return dateOfBirth;
        } else {
          // Remember your date format must always be YYYY-MM-DD
          return null;
        }
      });
  }

  _iosDatePicker(BuildContext context) async {
    print('Your date of birth is : $dateOfBirth');

    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (picked) {
                if (picked != null && picked != dateOfBirth) {
                  setState(() {
                    dateOfBirth = picked;
                    return dateOfBirth;
                  });
                }
              },
              initialDateTime: dateOfBirth,
              minimumYear: 1920,
              maximumYear: DateTime.now().year,
            ),
          );
        });
  }
}

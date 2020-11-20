import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:industry_app/constants.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:industry_app/otp_screen.dart';
import 'package:industry_app/size_config.dart';
import 'package:device_info/device_info.dart';
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
  String date;
  String role;
  int _myActivity;
  final _formKey = GlobalKey<FormState>();
  DateTime dateOfBirth = DateTime.now();
  Future<List<dynamic>> user_roles;
  Future<dynamic> data;

  @override
  void initState() {
    _myActivity = 1;
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    user_roles = _getRole();
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
    final TargetPlatform platform = getDevicePlatform(context);

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.height * 0.02),
            child: FutureBuilder(
              future: user_roles,
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

                                      var register =
                                          await userdata.registerUser(
                                              _emailController.text,
                                              _nameController.text,
                                              dateOfBirth.toString(),
                                              deviceData.deviceNumber,
                                              _myActivity.toString());

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
                                'By registering you are agreeining to our terms and conditions',
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

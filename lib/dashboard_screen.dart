import 'package:flutter/material.dart';
import 'package:industry_app/constants.dart';
import 'package:industry_app/device_data_provider.dart';
import 'package:industry_app/login_screen.dart';
import 'package:industry_app/news.dart';
import 'package:industry_app/splash_screen.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:industry_app/task_column.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:industry_app/otp_screen.dart';
import 'package:industry_app/size_config.dart';
import 'package:intl/intl.dart';
import 'package:industry_app/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  static String routeName = "/dashboard";

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Future<DeviceData> deviceData;

  final GlobalKey _globalKey = GlobalKey();

  var result;

  Future<dynamic> preferences;

  @override
  void didChangeDependencies() {
    deviceData = _getDeviceData();
    super.didChangeDependencies();
  }

  Future<DeviceData> _getDeviceData() async {
    return await Provider.of<DeviceDataProvider>(context).getDeviceData();
  }

  Text subheading(String title) {
    return Text(
      title,
      style: TextStyle(
          color: kAppDarkColour,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  Expanded activeProjectsCard(
      BuildContext context, Color cardColor, String title, String subtitle) {
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        padding: EdgeInsets.all(15.0),
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.pink,
              Colors.purple,
            ],
            //stops: [0.8, 0.96, 0.74, 0.22, 0.85],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image.network(
                        'https://image.shutterstock.com/image-photo/red-apple-isolate-on-white-600w-1714353358.jpg'),
                  ),
                  Container(
                    height: 40,
                    alignment: Alignment.bottomRight,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey),
                    child: Text(
                      'NM',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserProvider>(context);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _globalKey,
      drawer: Drawer(
        child: FutureBuilder(
            future: deviceData,
            builder: (context, snapshot) {
              // if (snapshot.hasData) {
              return ListView(
                children: [
                  UserAccountsDrawerHeader(
                    //accountName: Text(snapshot.data.name),
                    //accountEmail: Text(snapshot.data.email),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        'NM',
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.green[600],
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text("Statistics"),
                    leading: Icon(
                      Icons.stacked_bar_chart,
                      color: Colors.green[600],
                    ),
                  ),
                  ListTile(
                    title: Text("News"),
                    leading: Icon(
                      Icons.description,
                      color: Colors.green[600],
                    ),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, News.routeName);
                    },
                  ),
                  ListTile(
                    title: Text("Publish News"),
                    leading: Icon(
                      Icons.add,
                      color: Colors.green[600],
                    ),
                  ),
                  ListTile(
                    title: Text("Edit Profile"),
                    leading: Icon(
                      Icons.settings,
                      color: Colors.green[600],
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.clear();
                      Navigator.pushReplacementNamed(context, Login.routeName);
                    },
                    title: Text("LogOut"),
                    leading: Icon(
                      Icons.logout,
                      color: Colors.green[600],
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      androidAlertDialog(
                        context,
                        "Are you sure you want to deactivate?",
                        titleText: "Deactivate",
                        onYesPressed: () {
                          print(snapshot.data.deviceNumber);
                          result = userData
                              .deactivateAccount(snapshot.data.deviceNumber);
                          if (result != 'success') {
                            prefs.clear();
                            Navigator.pushReplacementNamed(
                                context, SplashScreen.routeName);
                          }
                        },
                        onNoPressed: () {
                          Navigator.pushReplacementNamed(
                              context, DashboardScreen.routeName);
                        },
                      );
                    },
                    title: Text(
                      "Deactivate Account",
                      style: TextStyle(
                        color: Colors.red[600],
                      ),
                    ),
                    leading: Icon(
                      Icons.power_settings_new,
                      color: Colors.red[600],
                    ),
                  ),
                ],
              );
              /*  } else {
                return progressIndicator();
              }*/
            }),
      ),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.green[600],
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
            ),
            onPressed: null,
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: deviceData,
          builder: (context, snapshot) {
            //if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.green[600],
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0),
                    ),
                  ),
                  height: 150,
                  width: width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Center(
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 40.0,
                                child: Center(
                                  child: Text(
                                    "NM",
                                    style: TextStyle(
                                      color: Colors.green[600],
                                      fontSize: 30.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    'snapshot.data.name',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    " snapshot.data.role_desc",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  subheading('HeadLines'),
                                ],
                              ),
                              SizedBox(height: 15.0),
                              TaskColumn(
                                icon: Icons.description,
                                iconBackground: Colors.green[300],
                                title: 'New Development at East London Market',
                                subtitle:
                                    'Construction under way in East London...',
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              TaskColumn(
                                icon: Icons.description,
                                iconBackground: Colors.green[300],
                                title:
                                    'Apples are the most sold at Pretoria Market',
                                subtitle:
                                    'Apples are ground  breaking in the farming...',
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              TaskColumn(
                                icon: Icons.description,
                                iconBackground: Colors.green[300],
                                title: 'Bloemfontein Market sales sky rocket',
                                subtitle: 'The best sales of this week go...',
                              ),
                              SizedBox(height: 15.0),
                              TaskColumn(
                                icon: Icons.description,
                                iconBackground: Colors.green[300],
                                title:
                                    'Drought has caused less crop production',
                                subtitle:
                                    'Drought has made it hard this year...',
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topLeft,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.network_cell),
                                        subheading('Statistics:')
                                      ]),
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0)),
                                    color: Colors.tealAccent),
                              ),
                              SizedBox(height: 5.0),
                              Row(
                                children: <Widget>[
                                  activeProjectsCard(
                                    context,
                                    Colors.green[300],
                                    'Statistics',
                                    'For Durban',
                                  ),
                                  SizedBox(width: 20.0),
                                  activeProjectsCard(
                                    context,
                                    Colors.green[300],
                                    'Statistics',
                                    'For East London',
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  activeProjectsCard(
                                    context,
                                    Colors.green[300],
                                    'Statistics',
                                    'For Pretoria',
                                  ),
                                  SizedBox(width: 20.0),
                                  activeProjectsCard(
                                    context,
                                    Colors.green[300],
                                    'Statistics',
                                    'For Bloemfontein',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
            /*} else {
              return progressIndicator();
            }*/
          },
        ),
      ),
    );
  }
}

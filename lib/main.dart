import 'package:flutter/material.dart';
import 'package:industry_app/agent_provider.dart';
import 'package:industry_app/buyers_provider.dart';
import 'package:industry_app/dashboard_screen.dart';
import 'package:industry_app/device_data_provider.dart';
import 'package:industry_app/market_provider.dart';
import 'package:industry_app/otp_screen.dart';
import 'package:industry_app/producers_provider.dart';
import 'package:industry_app/splash_screen.dart';
import 'package:industry_app/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:industry_app/routes.dart';
import 'package:industry_app/constants.dart';

void main() {
  runApp(IndustryApp());
}

class IndustryApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AgentProvider()),
        ChangeNotifierProvider(create: (_) => BuyerProvider()),
        ChangeNotifierProvider(create: (_) => MarketProvider()),
        ChangeNotifierProvider(create: (_) => ProducerProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DeviceDataProvider()),
      ],
      child: App(),
    );
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Future<DeviceData> deviceData;

  @override
  void didChangeDependencies() {
    deviceData = _getDeviceData();
    super.didChangeDependencies();
  }

  Future<DeviceData> _getDeviceData() async {
    return await Provider.of<DeviceDataProvider>(context).getDeviceData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: deviceData,
      builder: (context, snapshot) {
//print(snapshot.data);
        if (snapshot.hasData) {
          return MaterialApp(
            title: 'Industry App',
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              primaryColor: kAppGreenColour,
              fontFamily: "Muli",
              appBarTheme: appBarTheme(),
              textTheme: textTheme(),
              inputDecorationTheme: inputDecorationTheme(),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            debugShowCheckedModeBanner: false,
            initialRoute: snapshot.data.active == 1
                ? DashboardScreen.routeName
                : snapshot.data.active == 0
                    ? OTPScreen.routeName
                    : SplashScreen.routeName,
            routes: routes,
          );
        } else {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data == null) {

            return MaterialApp(
              title: 'Industry App',
              theme: ThemeData(
                scaffoldBackgroundColor: Colors.white,
                primaryColor: kAppGreenColour,
                fontFamily: "Muli",
                appBarTheme: appBarTheme(),
                textTheme: textTheme(),
                inputDecorationTheme: inputDecorationTheme(),
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              debugShowCheckedModeBanner: false,
              initialRoute: SplashScreen.routeName,
              routes: routes,
            );
          } else {
            return progressIndicator();
          }
        }
      },
    );
  }
}

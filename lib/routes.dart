import 'package:flutter/widgets.dart';
import 'package:industry_app/dashboard_screen.dart';
import 'package:industry_app/edit_profile.dart';
import 'package:industry_app/login_screen.dart';
import 'package:industry_app/news.dart';
import 'package:industry_app/otp_screen.dart';
import 'package:industry_app/register.dart';
import 'package:industry_app/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {

  SplashScreen.routeName: (context) => SplashScreen(),
  Register.routeName: (context) => Register(),
  Login.routeName: (context) => Login(),
  OTPScreen.routeName:(context)=> OTPScreen(),
  DashboardScreen.routeName:(context)=> DashboardScreen(),
  News.routeName:(context)=>News(),
  EditProfile.routeName:(context) => EditProfile(),

};

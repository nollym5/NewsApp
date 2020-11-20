import 'package:flutter/material.dart';
import 'package:industry_app/register.dart';
import 'package:industry_app/constants.dart';
import 'package:industry_app/size_config.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = '/splash';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {});
                },
                itemBuilder: (context, index) => Column(
                  children: [
                    Spacer(),
                    /*Text(
                      "Welcome",
                      style: TextStyle(
                        fontSize:
                            ((36 / 375.0) * MediaQuery.of(context).size.width),
                        color: kAppGreenColour,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),*/
                    Spacer(flex: 1),
                    Image.asset(
                      "images/logo.png",
                      height:
                          ((265 / 812.0) * MediaQuery.of(context).size.height),
                      width:
                          ((235 / 375.0) * MediaQuery.of(context).size.width),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(flex: 1),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      ((20 / 375.0) * MediaQuery.of(context).size.width),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height:
                          ((10 / 375.0) * MediaQuery.of(context).size.height),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: kAppGreenColour,
                        child: Center(
                          child: Text(
                            "Sign up",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.055,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            Register.routeName,
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Column(
                      children: [
                        Text("Powered by: "),
                        Image.asset(
                          "images/newlogo.png",
                          height: MediaQuery.of(context).size.height * 0.07,
                          width: MediaQuery.of(context).size.width * 0.5,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:industry_app/constants.dart';
import 'package:industry_app/device_data_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:industry_app/otp_screen.dart';
import 'package:industry_app/size_config.dart';
import 'package:intl/intl.dart';
import 'package:industry_app/user_provider.dart';
import 'package:provider/provider.dart';

class News extends StatefulWidget {
  static String routeName = "/news";
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  Future<List<dynamic>> news;

  @override
  void didChangeDependencies() {
    news = _fetchNews();
    super.didChangeDependencies();
  }

  Future<List> _fetchNews() async {
    return await Provider.of<UserProvider>(context).fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: news != null
          ? ListView.builder(itemBuilder: (BuildContext builder, int index) {
              return Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(padding: EdgeInsets.all(8.0),
                    child: news[index]['title'] != null?
                    Text(news[index]['title'],style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,):,
                    ):),
                  ],
                ),
              );
            })
          : progressIndicator(),
    );
  }
}

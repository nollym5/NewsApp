import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:industry_app/constants.dart';
import 'package:http/http.dart' as http;
import 'package:industry_app/dashboard_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class News extends StatefulWidget {
  static String routeName = "/news";
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  List<dynamic> news;
  //Nolly: 5a675d82080d40b789b4243a1f50bb48
  //Nolwazi: e7b29f072a6741c9b9e5791703d92628
  //Momz: 55c03c15c0e540e2955e417e8edf5e67
  //Miss M: d8c13053ed544109977306df13204455
  //Sbo: 5daf4a6b6edd480999f3cda555416d3a
  Future<dynamic> fetchNews() async {
    http.Response newsResponse = await http.get(
        "http://newsapi.org/v2/top-headlines?country=za&apiKey=5daf4a6b6edd480999f3cda555416d3a ");

    if (newsResponse.statusCode == 200) {
      setState(() {
        news = jsonDecode(newsResponse.body)['articles'];
      });

      return news;
    } else {
      print(news);
    }
  }

  @override
  void didChangeDependencies() {
    this.fetchNews();
    super.didChangeDependencies();
  }

  TextEditingController editingController = TextEditingController();
  List results = [];
  String query = '';
  void filterSearchResults(String query) {
    setState(
      () {
        results = news
            .where((elem) => elem['title']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    this.fetchNews();

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('News'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, DashboardScreen.routeName);
          },
        ),
      ),
      body: FutureBuilder(
        future: fetchNews(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return progressIndicator();
          } else {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        query = value;
                        filterSearchResults(query);
                      },
                      controller: editingController,
                      decoration: InputDecoration(
                          //labelText: "Search",
                          hintText: "Search",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)))),
                    ),
                  ),
                  Expanded(
                    child: query.isEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            // scrollDirection: Axis.horizontal,
                            itemCount: news == null ? 0 : news.length,
                            itemBuilder: (BuildContext builder, int index) {
                              return Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(0.0),
                                        child: news[index]['title'] != null
                                            ? Text(
                                                news[index]['title'],
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Text("No Data"),
                                      ),
                                      news[index]['urlToImage'] == null
                                          ? Center(
                                              child: Icon(Icons.error_outline))
                                          : Stack(children: [
                                              Image.network(
                                                  news[index]['urlToImage']),
                                              Text("NM")
                                            ]),
                                      SizedBox(
                                        height: 2.0,
                                      ),
                                      news[index]['description'] == null
                                          ? Text('No Data')
                                          : Text(
                                              news[index]['description'],
                                              style: TextStyle(
                                                fontSize: 13.0,
                                              ),
                                            ),
                                      FlatButton(
                                        onPressed: () async {
                                          var url = news[index]['url'];
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            print('Cannot launch url');
                                          }
                                        },
                                        child: Text(
                                          "See more...",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            color: kAppGreenColour,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            // scrollDirection: Axis.horizontal,
                            itemCount: results == null ? 0 : results.length,
                            itemBuilder: (BuildContext builder, int index) {
                              return Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(0.0),
                                        child: results[index]['title'] != null
                                            ? Text(
                                                results[index]['title'],
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Text("No Data"),
                                      ),
                                      results[index]['urlToImage'] == null
                                          ? Center(
                                              child: Icon(Icons.error_outline))
                                          : Image.network(
                                              results[index]['urlToImage']),
                                      SizedBox(
                                        height: 2.0,
                                      ),
                                      results[index]['description'] == null
                                          ? Text('No Data')
                                          : Text(
                                              results[index]['description'],
                                              style: TextStyle(
                                                fontSize: 13.0,
                                              ),
                                            ),
                                      FlatButton(
                                        onPressed: () async {
                                          var url = results[index]['url'];
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            print('Cannot launch url');
                                          }
                                        },
                                        child: Text(
                                          "See more...",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            color: kAppGreenColour,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

/*news != null
          ? ListView.builder(
              itemCount: news == null ? 0 : news.length,
              itemBuilder: (BuildContext builder, int index) {
                return Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: news[index]['title'] != null
                            ? Text(
                                news[index]['title'],
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              )
                            : Text("No Data"),
                      ),
                      news[index]['urlToImage'] == null
                          ? Center(child: Icon(Icons.error_outline))
                          : Image.network(news[index]['urlToImage']),
                      news[index]['description'] == null
                          ? Text(news[index]['description'])
                          : Text('No Data')
                    ],
                  ),
                );
              })
          : progressIndicator(),*/

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:comsci_news/Screens/app/news_view.dart';
import 'package:comsci_news/Screens/app/side_menu.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as Http;
import '../Login/components/background.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  var jsonData;
  List<ThailandNewsData> dataList = [];

  TextStyle titleStyle =
      GoogleFonts.kanit(fontSize: 18, fontWeight: FontWeight.bold);

  TextStyle contentStyle = GoogleFonts.kanit(
    fontSize: 18,
  );

  Future<Null> updateData(BuildContext context) async {
    setState(() {
      dataList = [];
    });
  }

  Future<String> _GetNewsAPI() async {
    var response = await Http.get(
        'http://newsapi.org/v2/top-headlines?country=th&apiKey=eb1a72ebd0874af8bb85b76fb4583161');

    jsonData = json.decode(utf8.decode(response.bodyBytes));

    for (var data in jsonData['articles']) {
      ThailandNewsData news = ThailandNewsData(
          data['title'], data['description'], data['urlToImage'], data['url']);
      dataList.add(news);
    }

    return 'successed';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thailand News',
          style: contentStyle,
        ),
      ),
      drawer: NavDrawer(),
      body: Background(
        child: new RefreshIndicator(
            child: FutureBuilder(
              future: _GetNewsAPI(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Column(
                          children: <Widget>[
                            Card(
                              child: Image.network(
                                  '${dataList[index].urlToImage}'),
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              margin: EdgeInsets.all(15),
                            ),
                            InkWell(
                              child: Container(
                                margin: EdgeInsets.all(15),
                                child: Align(
                                    child: Text(
                                  '${dataList[index].title}',
                                  style: titleStyle,
                                )),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewsViewPage(
                                              url: dataList[index].url,
                                            )));
                              },
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 0),
                              child: Align(
                                child: Text(
                                  '${dataList[index].description}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Container(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            onRefresh: () {
              return updateData(context);
            }),
      ),
    );
  }
}

class ThailandNewsData {
  String title;
  String description;
  String urlToImage;
  String url;
  ThailandNewsData(this.title, this.description, this.urlToImage, this.url);
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_scraper/web_scraper.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // 웹 사이트의 기본 URL을 전달하여 WebScraper 초기화
  WebScraper webScraper = WebScraper("https://webscraper.io");

  List<Map<String, dynamic>>? productNames;
  late List<Map<String, dynamic>> productDescriptions;

  Future<bool> getCrawling() async {
    try {
      // 웹 페이지를 응답 개체로 로드한 다음 문서 개체로 구문 분석.
      bool result = await webScraper
          .loadWebPage("/test-sites/e-commerce/allinone/computers/laptops");
      if (result) {
        // 지정한 주소에서 찾은 요소 목록을 반환, 전달된 동일한 순서로 속성을 반환
        productNames = webScraper.getElement(
          "div.thumbnail > div.caption > h4 > a.title",
          ["href", "title"],
        );
        productDescriptions = webScraper.getElement(
          "div.thumbnail > div.caption > p.description",
          ["class"],
        );
        return true;
      }
    } catch (error) {
      print(error);
      return false;
    }

    return false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "크롤링 예제",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("크롤링 예제"),
        ),
        body: SafeArea(
          child: FutureBuilder(
              future: getCrawling(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: productNames!.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, dynamic> attributes =
                          productNames![index]["attributes"];
                      return ExpansionTile(
                        title: Text(attributes["title"]),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child:
                                      Text(productDescriptions[index]["title"]),
                                  margin: const EdgeInsets.only(bottom: 10.0),
                                ),
                                InkWell(
                                  onTap: () {
                                    // UI Launcher를 사용하여 웹 브라우저에서 시작
                                    launch(webScraper.baseUrl! +
                                        attributes["href"]);
                                  },
                                  child: const Text(
                                    "뷰 포트",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }
}

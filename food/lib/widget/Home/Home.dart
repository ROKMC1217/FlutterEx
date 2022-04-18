import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food/widget/NaverMap/BaseMapPage.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  WebViewController? webViewcontroller;
  List<bool> isSelected = [true, false, false];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void changeCurrentIndex(int index) {
    setState(() {
      currentIndex = index;
      if (index == 0) {
        webViewcontroller!.loadUrl(
            "https://m.place.naver.com/restaurant/34319168/home?entry=plt");
      } else if (index == 1) {
        webViewcontroller!.loadUrl("https://place.map.kakao.com/23447064");
      }
      for (int i = 0; i < isSelected.length; i++) {
        if (i == index) {
          isSelected[i] = true;
        } else {
          isSelected[i] = false;
        }
      }
    });
  }

  Widget getBody() {
    return SizedBox(
      width: 100,
      height: MediaQuery.of(context).size.height,
      child: WebView(
        initialUrl:
            "https://m.place.naver.com/restaurant/34319168/home?entry=plt",
        javascriptMode: JavascriptMode.unrestricted,
        onPageStarted: (String url) {},
        onWebViewCreated: (WebViewController controller) {
          webViewcontroller = controller;
        },
        gestureNavigationEnabled: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MySearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 500,
            child: BaseMapPage(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ToggleButtons(
                color: Colors.black.withOpacity(0.60),
                selectedColor: const Color(0xFF6200EE),
                selectedBorderColor: const Color(0xFF6200EE),
                fillColor: const Color(0xFF6200EE).withOpacity(0.08),
                splashColor: const Color(0xFF6200EE).withOpacity(0.12),
                hoverColor: const Color(0xFF6200EE).withOpacity(0.04),
                borderRadius: BorderRadius.circular(4.0),
                constraints: BoxConstraints(
                  minWidth: (MediaQuery.of(context).size.width / 3) - 4,
                  minHeight: 36.0,
                ),
                isSelected: isSelected,
                onPressed: (index) {
                  changeCurrentIndex(index);
                },
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text("naver"),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text("kakao"),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text("google"),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: WebView(
              initialUrl:
                  "https://m.place.naver.com/restaurant/34319168/home?entry=plt",
              javascriptMode: JavascriptMode.unrestricted,
              onPageStarted: (String url) {},
              onWebViewCreated: (WebViewController controller) {
                webViewcontroller = controller;
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 검색 창
class MySearchDelegate extends SearchDelegate {
  List<String> searchResultsList = [
    '한국',
    '중국',
    '일국',
    '미국',
    '러시아',
    '우크라이나',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null); // 서치 바 닫음.
          } else {
            query = "";
          }
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null); // 서치 바 닫음.
      },
      icon: const Icon(
        Icons.arrow_back,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(
        query,
        style: const TextStyle(
          fontSize: 64,
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionsList = searchResultsList.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();
    return ListView.builder(
        itemCount: suggestionsList.length,
        itemBuilder: (context, index) {
          final suggestion = suggestionsList[index];

          return ListTile(
            title: Text(suggestion),
            onTap: () {
              query = suggestion;
              showResults(context);
            },
          );
        });
  }
}

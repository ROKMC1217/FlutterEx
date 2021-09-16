import 'package:carrot_sample/page/favorite/favorite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'home.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int? _currentPageIndex;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = 0;
  }

  // ***** body 위젯 *****
  Widget _bodyWidget() {
    switch (_currentPageIndex) {
      case 0:
        return Home();
      case 1:
        return Container();
      case 2:
        return Container();
      case 3:
        return Container();
      case 4:
        return MyFavoriteContents();
    }
    return Container();
  }

  BottomNavigationBarItem _bottomNavigationBarItem(
      String iconName, String label) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: SvgPicture.asset(
          "assets/svg/${iconName}_off.svg",
          width: 22,
        ),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: SvgPicture.asset(
          "assets/svg/${iconName}_on.svg",
          width: 22,
        ),
      ),
      label: label,
    );
  }

  // ***** BottomNavigationBar 위젯 *****
  Widget _bottomNavigationBarWidget() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        print(index);
        setState(() {
          _currentPageIndex = index;
        });
      },
      currentIndex: _currentPageIndex!,
      selectedFontSize: 12,
      selectedItemColor: Colors.black,
      selectedLabelStyle: TextStyle(color: Colors.black),
      items: [
        _bottomNavigationBarItem("home", "홈"),
        _bottomNavigationBarItem("notes", "동네 생활"),
        _bottomNavigationBarItem("location", "내 근처"),
        _bottomNavigationBarItem("chat", "채팅"),
        _bottomNavigationBarItem("user", "나의 당근"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _appbarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomNavigationBarWidget(),
    );
  }
}

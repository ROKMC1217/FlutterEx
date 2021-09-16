import 'package:carrot_sample/controller/ListController.dart';
import 'package:carrot_sample/page/detail/detail.dart';
import 'package:carrot_sample/utils/data_utils.dart';
import 'package:carrot_sample/vo/ListVO.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DatabaseReference reference = FirebaseDatabase(
          databaseURL: "https://carrot-sample-default-rtdb.firebaseio.com/")
      .reference();
  List<ListVO> datas = [];
  String? currentLocation;
  final Map<String, String> locationTypeToString = {
    "금암동": "금암동",
    "효자동": "효자동",
    "서신동": "서신동",
    "삼천동": "삼천동",
  };

  // ***** appbar 위젯 *****
  PreferredSizeWidget _appbarWidget() {
    print("this is appbar");
    return AppBar(
      // leading: ,    // 앞의 버튼 즉 햄버거 버튼 등이 온다.
      // 가운데 텍스트가 온다 제목 등이 온다.
      title: GestureDetector(
        onTap: () {
          print("onTap!");
        },
        child: PopupMenuButton<String>(
          offset: Offset(0, 30),
          shape: ShapeBorder.lerp(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              1),
          onSelected: (String where) {
            print(where);
            setState(() {
              currentLocation = where;
            });
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: "금암동",
                child: Text("금암동"),
              ),
              PopupMenuItem(
                value: "효자동",
                child: Text("효자동"),
              ),
              PopupMenuItem(
                value: "서신동",
                child: Text("서신동"),
              ),
              PopupMenuItem(
                value: "삼천동",
                child: Text("삼천동"),
              ),
            ];
          },
          child: Row(
            children: <Widget>[
              Text(
                "${locationTypeToString[currentLocation]}",
                style: TextStyle(color: Colors.black),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
      // 우측 끝에 버튼등이 온다. 리스트 형태로 위젯을 받게 되어있다.
      actions: [
        IconButton(
          onPressed: () {
            print("search");
          },
          icon: Icon(
            Icons.search,
            color: Colors.black,
          ),
        ),
        IconButton(
          onPressed: () {
            print("tune");
          },
          icon: Icon(
            Icons.tune,
            color: Colors.black,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            "assets/svg/bell.svg",
            width: 22.0,
          ),
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 1,
    );
  }

  Widget _bodyWidget() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) {
                print(datas[index]);
                return DetailContentView(
                  vo: datas[index],
                );
              }),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Hero(
                    tag: "${datas[index].no}",
                    child: Image.asset(
                      datas[index].image,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    height: 100,
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          datas[index].title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          datas[index].location,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          DataUtils.calcStringToWon("${datas[index].price}"),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SvgPicture.asset(
                                "assets/svg/heart_off.svg",
                                width: 13,
                                height: 13,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text("${datas[index].likes}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: datas.length,
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          height: 1,
          color: Colors.black.withOpacity(0.4),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    print("initState start...");
    ListController listController = new ListController();
    listController.readAll();
    currentLocation = "효자동";
    reference.child("list").onChildAdded.listen((event) {
      setState(() {
        datas.add(ListVO.fromSnapshot(event.snapshot));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),
    );
  }
}

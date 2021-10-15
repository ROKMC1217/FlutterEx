import 'package:flutter/material.dart';
import 'package:plant_app/constants.dart';
import 'package:plant_app/plant.dart';
import 'package:plant_app/screens/home/components/featured_plants.dart';
import 'package:plant_app/screens/home/components/header_with_searchbox.dart';
import 'package:plant_app/screens/home/components/recomend_plants.dart';
import 'package:plant_app/screens/home/components/title_with_more_btn.dart';

import 'package:firebase_database/firebase_database.dart';

// Firebase 데이터베이스에 액세스하기 위한 진입점.
// FirebaseDatabase를 호출하여 인스턴스를 가져올 수 있습니다.
// 예를 들어. 데이터베이스의 위치에 액세스하고 데이터를 읽거나 쓰려면 참조()를 사용하십시오.
FirebaseDatabase? _database;

// DatabaseReference는 Firebase 데이터베이스의 특정 위치를 나타내며 해당 위치에 데이터를 읽거나 쓰는 데 사용할 수 있습니다.
// 이 클래스는 모든 Firebase 데이터베이스 작업의 시작점입니다. FirebaseDatabase.reference()를 통해 첫 번째
// DatabaseReference를 얻은 후 이를 사용하여 데이터를 읽을 수 있습니다.
DatabaseReference? reference;

// Database URL
String _databaseURL = "https://rend4things-default-rtdb.firebaseio.com/";

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Plant> recomend_plant = new List.empty(growable: true);
  List<Plant> feature_plant = new List.empty(growable: true);

  @override
  void initState() {
    super.initState();

    // firebase 초기화
    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database!.reference();

    //plant("test2");
    // 처음 가져올 때는 다 가져오고 나중에 데이터가 추가 될때 이벤트 발생(추가된 데이터만 가져옴.)
    reference!.child('recomend').onChildAdded.listen((event) {
      //plant(event.snapshot.value.toString());
      setState(() {
        recomend_plant.add(Plant.fromSnapshot(event.snapshot));
        // recomend_plant.add(event.snapshot.value);
      });
    });
    reference!.child('feature').onChildAdded.listen((event) {
      //plant(event.snapshot.value.toString());
      setState(() {
        // feature_plant.add(Plant.fromSnapshot(event.snapshot));
        // feature_plant.add(event.snapshot.value);
        // print(feature_plant);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          HeaderWithSearchBox(size: size),
          TitleWithMoreBtn(title: "Recomended"),
          // RecomendsPlants(plants: recomend_plant),
          TitleWithMoreBtn(title: "Featured Plants"),
          // FeaturedPlants(plants: feature_plant),
          SizedBox(height: kDefaultPadding)
        ],
      ),
    );
  }
}

// class Body extends StatelessWidget {

// }

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:plant_app/constants.dart';
import 'package:plant_app/plant.dart';
import 'package:plant_app/storage_upload.dart';

// Firebase 데이터베이스에 액세스하기 위한 진입점.
// FirebaseDatabase를 호출하여 인스턴스를 가져올 수 있습니다.
// 예를 들어. 데이터베이스의 위치에 액세스하고 데이터를 읽거나 쓰려면 참조()를 사용하십시오.
// FirebaseDatabase? _database;

// // DatabaseReference는 Firebase 데이터베이스의 특정 위치를 나타내며 해당 위치에 데이터를 읽거나 쓰는 데 사용할 수 있습니다.
// // 이 클래스는 모든 Firebase 데이터베이스 작업의 시작점입니다. FirebaseDatabase.reference()를 통해 첫 번째
// // DatabaseReference를 얻은 후 이를 사용하여 데이터를 읽을 수 있습니다.
// DatabaseReference? reference;

// // Database URL
// String _databaseURL = "https://rend4things-default-rtdb.firebaseio.com/";

class TitleWithMoreBtn extends StatelessWidget {
  const TitleWithMoreBtn({
    Key? key,
    this.title,
  }) : super(key: key);

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        children: <Widget>[
          TitleWithCustomUnderline(text: title!),
          Spacer(),
          FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: kPrimaryColor,
            onPressed: () {
              StorageUpload storage = new StorageUpload();
              storage.selectFile(title);
              ////plant("select!!!!!!!!!");
              // storage.uploadFile();

              // Plant plant = Plant as Plant;
              // plant.key = reference!.child('recomend').push().key;
              // plant.title = "example_title";
              // plant.country = "example_country";
              // plant.price = 550;
              // plant.createTime = DateTime.now().toString();
              // plant.image = storage.downloadUrl;

              ////plant(plant);

              // String ch = title == "Recomended" ? "recomend" : "feature";

              ////plant(ch);

              // _database = FirebaseDatabase(databaseURL: _databaseURL);
              // reference = _database!.reference();
              // reference!
              //     .child(ch)
              //     .child(plant.key as String)
              //     .update(plant.toJson());
            },
            child: Text(
              "More",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class TitleWithCustomUnderline extends StatelessWidget {
  const TitleWithCustomUnderline({
    Key? key,
    this.text,
  }) : super(key: key);

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: kDefaultPadding / 4),
            child: Text(
              text!,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.only(right: kDefaultPadding / 4),
              height: 7,
              color: kPrimaryColor.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}

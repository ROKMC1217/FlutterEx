import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_app/api/firebase_api.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:plant_app/plant.dart';

// Firebase 데이터베이스에 액세스하기 위한 진입점.
// FirebaseDatabase를 호출하여 인스턴스를 가져올 수 있습니다.
// 예를 들어. 데이터베이스의 위치에 액세스하고 데이터를 읽거나 쓰려면 참조()를 사용하십시오.
FirebaseDatabase? _database;

// DatabaseReference는 Firebase 데이터베이스의 특정 위치를 나타내며 해당 위치에 데이터를 읽거나 쓰는 데 사용할 수 있습니다.
// 이 클래스는 모든 Firebase 데이터베이스 작업의 시작점입니다. FirebaseDatabase.reference()를 통해 첫 번째
// DatabaseReference를 얻은 후 이를 사용하여 데이터를 읽을 수 있습니다.
DatabaseReference? reference;

String _databaseURL = "https://rend4things-default-rtdb.firebaseio.com/";

class StorageUpload {
  UploadTask? task;
  File? file;
  String? downloadUrl;

  String title = '';

  void selectFile(title) async {
    this.title = title;
    print("title!!!!!!!!!!!");
    print(title);
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    // final result =
    //     await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    if (result == null) return;
    final path = result.files.single.path!;
    // final path = result.path;

    file = File(path);
    uploadFile();
  }

  void uploadFile() async {
    print("title!!!!!!!!!!!");
    print(title);
    print("file!!!!!!!!");
    print(file);
    if (file == null) return;
    print("file is not null!!!!");

    final fileName = basename(file!.path);
    print(fileName);
    final destination = 'files/$fileName';
    print(destination);

    task = FirebaseApi.uploadFile(destination, file!);
    print("task!!!!!");
    print(task);
    if (task == null) return;
    print("task is not null!!!!!");

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
    downloadUrl = urlDownload;
    firebase_update();
  }

  void firebase_update() {
    print("firebase_update!!!!!!!!!!!!!");

    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database!.reference();

    Plant plant = Plant(
      reference!.child('recomend').push().key,
      "example_title",
      "example_country",
      550,
      DateTime.now().toString(),
      downloadUrl,
    );
    // plant.db_key = reference!.child('recomend').push().key;
    // plant.title = "example_title";
    // plant.country = "example_country";
    // plant.price = 550;
    // plant.createTime = DateTime.now().toString();
    // plant.image = downloadUrl;

    print("plant!!!!!!!!!!!!");
    print(plant.toJson());
    print(plant.toString());

    String ch = title == "Recomended" ? "recomend" : "feature";

    print("ch!!!!!!!!!!!!");
    print(ch);

    reference!.child(ch).child(plant.key as String).update(plant.toJson());
  }
}

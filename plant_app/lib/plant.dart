import 'package:firebase_database/firebase_database.dart';

class Plant {
  String? key;
  String? title;
  String? country;
  int? price;
  String? createTime;
  String? image;

  Plant(
    this.key,
    this.title,
    this.country,
    this.price,
    this.createTime,
    this.image,
  );

  // 생성자
  Plant.fromSnapshot(DataSnapshot snapshot) {
    print(snapshot.value);
    key = snapshot.value["key"];
    title = snapshot.value["title"];
    country = snapshot.value["country"];
    price = snapshot.value["price"];
    createTime = snapshot.value["createTime"];
    image = snapshot.value["image"];
  }

  toJson() {
    return {
      "title": title,
      "country": country,
      "createTime": createTime,
      "price": price,
      "image": image,
      "key": key,
    };
  }
}

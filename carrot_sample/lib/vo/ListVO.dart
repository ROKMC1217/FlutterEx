import 'package:firebase_database/firebase_database.dart';

class ListVO {
  int no = 0;
  String image = "";
  String title = "";
  String location = "";
  int price = 0;
  int likes = 0;

  // ListVO(int no, String image, String title, String location, int price,
  //     int likes) {
  //   this.no = no;
  //   this.image = image;
  //   this.title = title;
  //   this.location = location;
  //   this.price = price;
  //   this.likes = likes;
  // }

  ListVO(
      this.no, this.image, this.title, this.location, this.price, this.likes);

  ListVO.fromSnapshot(DataSnapshot snapshot) {
    this.no = snapshot.value["no"];
    this.image = snapshot.value["image"];
    this.title = snapshot.value["title"];
    this.location = snapshot.value["location"];
    this.price = snapshot.value["price"];
    this.likes = snapshot.value["likes"];
  }

  getJson() {
    return {
      "no": this.no,
      "image": this.image,
      "title": this.title,
      "location": this.location,
      "price": this.price,
      "likes": this.likes,
    };
  }

  void setNo(int no) {
    this.no = no;
  }

  void setImage(String image) {
    this.image = image;
  }

  void setTitle(String title) {
    this.title = title;
  }

  void setLocation(String location) {
    this.location = location;
  }

  void setPrice(int price) {
    this.price = price;
  }

  void setLikes(int likes) {
    this.likes = likes;
  }

  int getNo() {
    return this.no;
  }

  String getImage() {
    return this.image;
  }

  String getTitle() {
    return this.title;
  }

  String getLocation() {
    return this.location;
  }

  int getPrice() {
    return this.price;
  }

  int getLikes() {
    return this.likes;
  }

  // @override
  // String toString() {
  //   return "${this.no} + ${this.image} + ${this.title} + ${this.location} + ${this.price} + ${this.likes}}";
  // }
}

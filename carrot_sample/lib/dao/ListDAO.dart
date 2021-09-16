import 'package:carrot_sample/vo/ListVO.dart';
import 'package:firebase_database/firebase_database.dart';

class ListDAO {
  final DatabaseReference _reference = FirebaseDatabase(
          databaseURL: "https://carrot-sample-default-rtdb.firebaseio.com/")
      .reference();
  List<ListVO> list = [];

  // 글 등록.
  int writeList(ListVO vo) {
    // vo.getJson();
    try {
      _reference.child("list").child("${vo.no}").update(vo.getJson());
      return 1;
    } catch (e) {
      print(e);
      return 0;
    }
  }
}

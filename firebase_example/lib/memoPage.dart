import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'memo.dart';
import 'memoAdd.dart';
import 'memoDetail.dart';

// Firebase 데이터베이스에 액세스하기 위한 진입점.
// FirebaseDatabase를 호출하여 인스턴스를 가져올 수 있습니다.
// 예를 들어. 데이터베이스의 위치에 액세스하고 데이터를 읽거나 쓰려면 참조()를 사용하십시오.
FirebaseDatabase? _database;

// DatabaseReference는 Firebase 데이터베이스의 특정 위치를 나타내며 해당 위치에 데이터를 읽거나 쓰는 데 사용할 수 있습니다.
// 이 클래스는 모든 Firebase 데이터베이스 작업의 시작점입니다. FirebaseDatabase.reference()를 통해 첫 번째
// DatabaseReference를 얻은 후 이를 사용하여 데이터를 읽을 수 있습니다.
DatabaseReference? reference;

// Database URL
String _databaseURL = "https://example-5764b-default-rtdb.firebaseio.com/";

class MemoPage extends StatefulWidget {
  @override
  _MemoPageState createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  // FirebaseDatabase? _database;
  // DatabaseReference? reference;
  List<Memo> memos = new List.empty(growable: true);

  @override
  void initState() {
    super.initState();

    // firebase 초기화
    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database!.reference().child("memo");

    // 처음 가져올 때는 다 가져오고 나중에 데이터가 추가 될때 이벤트 발생(추가된 데이터만 가져옴.)
    reference!.onChildAdded.listen((event) {
      print(event.snapshot.value.toString());
      setState(() {
        memos.add(new Memo.fromSnapshot(event.snapshot));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("메모 앱"),
      ),
      body: Container(
        child: Center(
            child: memos.length == 0
                ? CircularProgressIndicator()
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //  교차 축에 고정된 수의 타일이 있는 레이아웃을 만듬.
                        crossAxisCount: 4),
                    itemBuilder: (context, index) {
                      return Card(
                        child: GridTile(
                          child: Container(
                            padding: EdgeInsets.only(top: 20, bottom: 20),
                            child: SizedBox(
                              child: GestureDetector(
                                onTap: () async {
                                  // 여기에 메모 상세보기 화면으로 이동 추가 예정
                                  Memo? memo = await Navigator.of(context).push(
                                      MaterialPageRoute<Memo>(
                                          builder: (BuildContext context) =>
                                              MemoDetailPage(
                                                  reference!, memos[index])));
                                  print("memo start........");
                                  print(memo);
                                  if (memo != null) {
                                    setState(() {
                                      memos[index].title = memo.title;
                                      memos[index].content = memo.content;
                                    });
                                  }
                                },
                                onLongPress: () {
                                  // 여기에 길게 클릭 시 메모 삭제 기능 추가 예정
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("${memos[index].title}"),
                                          content: Text("삭제하시겠습니까?"),
                                          actions: <Widget>[
                                            FlatButton(
                                                onPressed: () {
                                                  reference!
                                                      .child(
                                                          "${memos[index].key}")
                                                      .remove()
                                                      .then((_) => {
                                                            setState(() {
                                                              memos.removeAt(
                                                                  index);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            })
                                                          });
                                                },
                                                child: Text("예")),
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("아니오")),
                                          ],
                                        );
                                      });
                                },
                                child: Text("${memos[index].content}"),
                              ),
                            ),
                          ),
                          header: Text("${memos[index].title}"),
                          footer: Text(
                              "${memos[index].createTime}".substring(0, 10)),
                        ),
                      );
                    },
                    itemCount: memos.length,
                  )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MemoAddPage(reference!)));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

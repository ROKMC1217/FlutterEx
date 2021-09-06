import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'memo.dart';
import 'memoPage.dart';

class MemoAddPage extends StatefulWidget {
  final DatabaseReference reference;

  MemoAddPage(this.reference);

  @override
  _MemoAddPageState createState() => _MemoAddPageState();
}

class _MemoAddPageState extends State<MemoAddPage> {
  TextEditingController? titleController;
  TextEditingController? contentController;
  DatabaseReference? referenceMemo = reference;

  @override
  void initState() {
    super.initState();
    titleController = new TextEditingController();
    contentController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("메모 추가"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "제목",
                fillColor: Colors.blueAccent,
              ),
            ),
            Expanded(
              child: TextField(
                controller: contentController,
                keyboardType: TextInputType.multiline,
                maxLines: 100,
                decoration: InputDecoration(labelText: "내용"),
              ),
            ),
            FlatButton(
              onPressed: () {
                // 더미 데이터
                // for (int i = 1; i <= 356; i++) {
                //   referenceMemo!.push().set(new Memo(
                //           titleController!.value.text + i.toString(),
                //           contentController!.value.text + i.toString(),
                //           DateTime.now().toIso8601String())
                //       .toJson());
                //   if (i == 356) {
                //     Navigator.of(context).pop();
                //   }
                // }
                referenceMemo!
                    .push()
                    .set(new Memo(
                            titleController!.value.text,
                            contentController!.value.text,
                            DateTime.now().toIso8601String())
                        .toJson())
                    .then((_) => {
                          Navigator.of(context).pop(),
                        });
              },
              child: Text("저장하기"),
              shape: OutlineInputBorder(borderRadius: BorderRadius.circular(1)),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login/home.dart';

class App extends StatelessWidget {
  // initializeApp가 안됐다면 무한 로딩이나 Firebase load fail.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Firebase load fail."),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Home();
        }
        return CircularProgressIndicator();
      },
    );
  }
}

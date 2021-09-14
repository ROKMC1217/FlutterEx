import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/login.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (!snapshot.hasData) {
            return LoginWidget();
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${snapshot.data}"),
                  Text("${snapshot.data.displayName}님 환영합니다."),
                  FlatButton(
                    color: Colors.grey.withOpacity(0.3),
                    child: Text("로그아웃"),
                    onPressed: FirebaseAuth.instance.signOut,
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

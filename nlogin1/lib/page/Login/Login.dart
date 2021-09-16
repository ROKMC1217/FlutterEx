import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'dart:async';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLogin = false;
  String? accesToken;
  String? expiresAt;
  String? tokenType;
  String? name;
  var user;
  String? refreshToken;

  Future<void> buttonLoginPressed() async {
    NaverLoginResult res = await FlutterNaverLogin.logIn();
    print("good!");
    setState(() {
      name = res.account.nickname;
      isLogin = true;
    });
  }

  Future<void> buttonTokenPressed() async {
    NaverAccessToken res = await FlutterNaverLogin.currentAccessToken;
    setState(() {
      accesToken = res.accessToken;
      tokenType = res.tokenType;
    });
  }

  Future<void> buttonLogoutPressed() async {
    FlutterNaverLogin.logOut();
    setState(() {
      isLogin = false;
      accesToken = null;
      tokenType = null;
      name = null;
    });
  }

  Future<void> buttonGetUserPressed() async {
    NaverAccountResult res = await FlutterNaverLogin.currentAccount();
    setState(() {
      name = res.name;
      user = res;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Naver Login Sample',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text('isLogin: $isLogin\n'),
                Text('accesToken: $accesToken\n'),
                Text('tokenType: $tokenType\n'),
                Text('user: $user\n'),
              ],
            ),
            FlatButton(
                key: null,
                onPressed: buttonLoginPressed,
                child: const Text(
                  "LogIn",
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontFamily: "Roboto"),
                )),
            FlatButton(
                key: null,
                onPressed: buttonLogoutPressed,
                child: const Text(
                  "LogOut",
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontFamily: "Roboto"),
                )),
            FlatButton(
                key: null,
                onPressed: buttonTokenPressed,
                child: const Text(
                  "GetToken",
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontFamily: "Roboto"),
                )),
            FlatButton(
                key: null,
                onPressed: buttonGetUserPressed,
                child: const Text(
                  "GetUser",
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontFamily: "Roboto"),
                ))
          ]),
    );
  }
}

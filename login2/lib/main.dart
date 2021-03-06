import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_kakao_login/flutter_kakao_login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final FlutterKakaoLogin kakaoSignIn = FlutterKakaoLogin();

  String _loginMessage = 'Current Not Logined :(';
  String _accessToken = '';
  String _refreshToken = '';
  String _accountInfo = '';
  bool _isLogined = false;

  final List<Map<String, String>> _listItems = [
    {'key': 'login', 'title': 'Login', 'subtitle': ''},
    {'key': 'logout', 'title': 'Logout', 'subtitle': ''},
    {'key': 'unlink', 'title': 'Unlink', 'subtitle': ''},
    {'key': 'account', 'title': 'Get AccountInfo', 'subtitle': ''},
    {'key': 'accessToken', 'title': 'Get AccessToken', 'subtitle': ''},
    {'key': 'refreshToken', 'title': 'Get RefreshToken', 'subtitle': ''}
  ];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    // Kakao SDK Init (Set NATIVE_APP_KEY)
    await kakaoSignIn.init('a56c53e046df08768a23ff80eed7d3db');

    // For Android
    final hashKey = await kakaoSignIn.hashKey;
    print('hashKey: $hashKey');
  }

  Future<Null> _login() async {
    try {
      final result = await kakaoSignIn.logIn();
      _processLoginResult(result);
    } on PlatformException catch (e) {
      _updateLoginMessage('${e.code} ${e.message}');
    }
  }

  Future<Null> _logOut() async {
    try {
      final result = await kakaoSignIn.logOut();
      _processLoginResult(result);
      _processAccountResult(null);
    } on PlatformException catch (e) {
      _updateLoginMessage('${e.code} ${e.message}');
    }
  }

  Future<Null> _unlink() async {
    try {
      final result = await kakaoSignIn.unlink();
      _processLoginResult(result);
    } on PlatformException catch (e) {
      _updateLoginMessage('${e.code} ${e.message}');
    }
  }

  Future<Null> _getAccountInfo() async {
    try {
      final result = await kakaoSignIn.getUserMe();
      final account = result.account;
      _processAccountResult(account);
    } on PlatformException catch (e) {
      _updateLoginMessage('${e.code} ${e.message}');
    }
  }

  Future<Null> _getAccessToken() async {
    final token = await kakaoSignIn.currentToken;
    final accessToken = token?.accessToken;
    if (accessToken != null) {
      _updateAccessToken('AccessToken\n' + accessToken);
    } else {
      _updateAccessToken('');
    }
  }

  Future<Null> _getRefreshToken() async {
    final token = await kakaoSignIn.currentToken;
    final refreshToken = token?.refreshToken;
    if (refreshToken != null) {
      _updateRefreshToken('RefreshToken\n' + refreshToken);
    } else {
      _updateRefreshToken('');
    }
  }

  void _updateLoginMessage(String message) {
    setState(() {
      _loginMessage = message;
    });
  }

  void _updateStateLogin(bool logined) {
    setState(() {
      _isLogined = logined;
    });
    if (!logined) {
      _updateAccessToken('');
      _updateRefreshToken('');
      _updateAccountMessage('');
    }
  }

  void _updateAccessToken(String accessToken) {
    setState(() {
      _accessToken = accessToken;
    });
  }

  void _updateRefreshToken(String refreshToken) {
    setState(() {
      _refreshToken = refreshToken;
    });
  }

  void _updateAccountMessage(String message) {
    setState(() {
      _accountInfo = message;
    });
  }

  void _processLoginResult(KakaoLoginResult result) {
    switch (result.status) {
      case KakaoLoginStatus.loggedIn:
        _updateLoginMessage('LoggedIn by the user.');
        _updateStateLogin(true);
        break;
      case KakaoLoginStatus.loggedOut:
        _updateLoginMessage('LoggedOut by the user.');
        _updateStateLogin(false);
        break;
      case KakaoLoginStatus.unlinked:
        _updateLoginMessage('Unlinked by the user.');
        _updateStateLogin(false);
        break;
    }
  }

  void _processAccountResult(KakaoAccountResult? account) {
    if (account == null) {
      _updateAccountMessage('');
    } else {
      final userID = (account.userID == null) ? 'None' : account.userID;
      final userEmail =
          (account.userEmail == null) ? 'None' : account.userEmail;
      final userPhoneNumber =
          (account.userPhoneNumber == null) ? 'None' : account.userPhoneNumber;
      final userDisplayID =
          (account.userDisplayID == null) ? 'None' : account.userDisplayID;
      final userNickname =
          (account.userNickname == null) ? 'None' : account.userNickname;
      final userGender =
          (account.userGender == null) ? 'None' : account.userGender;
      final userAgeRange =
          (account.userAgeRange == null) ? 'None' : account.userAgeRange;
      final userBirthyear =
          (account.userBirthyear == null) ? 'None' : account.userBirthyear;
      final userBirthday =
          (account.userBirthday == null) ? 'None' : account.userBirthday;
      final userProfileImagePath = (account.userProfileImagePath == null)
          ? 'None'
          : account.userProfileImagePath;
      final userThumbnailImagePath = (account.userThumbnailImagePath == null)
          ? 'None'
          : account.userThumbnailImagePath;

      _updateAccountMessage('- ID is $userID\n'
          '- Email is $userEmail\n'
          '- PhoneNumber is $userPhoneNumber\n'
          '- DisplayID is $userDisplayID\n'
          '- Nickname is $userNickname\n'
          '- Gender is $userGender\n'
          '- Age is $userAgeRange\n'
          '- Birthyear is $userBirthyear\n'
          '- Birthday is $userBirthday\n'
          '- ProfileImagePath is $userProfileImagePath\n'
          '- ThumbnailImagePath is $userThumbnailImagePath');
    }
  }

  void _showAlert(BuildContext context, String value) {
    if (value.isEmpty) return;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('OK'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Kakao Login Plugin app'),
        ),
        body: SafeArea(
          child: ListView.builder(
            itemCount: _listItems.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return KakaoInfo(
                  loginMessage: _loginMessage,
                  accessToken: _accessToken,
                  refreshToken: _refreshToken,
                  accountInfo: _accountInfo,
                );
              }

              final actionIndex = index - 1;
              final title = _listItems[actionIndex]['title'] ?? '';
              final subtitle = _listItems[actionIndex]['subtitle'] ?? '';
              final key = _listItems[actionIndex]['key'];

              return ListTile(
                title: Text(title),
                subtitle: Text(subtitle),
                onTap: () {
                  switch (key) {
                    case 'login':
                      if (!_isLogined) {
                        _login();
                      }
                      break;
                    case 'logout':
                      if (_isLogined) {
                        _logOut();
                      }
                      break;
                    case 'unlink':
                      if (_isLogined) {
                        _unlink();
                      }
                      break;
                    case 'account':
                      if (!_isLogined) {
                        _showAlert(context, 'Login is required.');
                      } else {
                        _getAccountInfo();
                      }
                      break;
                    case 'accessToken':
                      if (!_isLogined) {
                        _showAlert(context, 'Login is required.');
                      } else {
                        _getAccessToken();
                      }
                      break;
                    case 'refreshToken':
                      if (!_isLogined) {
                        _showAlert(context, 'Login is required.');
                      } else {
                        _getRefreshToken();
                      }
                      break;
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////

class KakaoInfo extends StatelessWidget {
  final String loginMessage;
  final String accessToken;
  final String refreshToken;
  final String accountInfo;

  KakaoInfo({
    this.loginMessage = '',
    this.accessToken = '',
    this.refreshToken = '',
    this.accountInfo = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 25, 18, 25),
      color: Colors.grey[300],
      child: Column(
        children: [
          Text(loginMessage),
          accountInfo != '' ? SizedBox(height: 25) : Container(),
          accountInfo != '' ? Text(accountInfo) : Container(),
          accessToken != '' ? SizedBox(height: 10) : Container(),
          accessToken != '' ? Text(accessToken) : Container(),
          refreshToken != '' ? SizedBox(height: 10) : Container(),
          refreshToken != '' ? Text(refreshToken) : Container(),
        ],
      ),
    );
  }
}

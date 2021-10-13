import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // 만약 당신이 백그라운드에서 파이어스토어와 같은 다른 파이어베이스 서비스를 이용한다면,
  // '초기화'를 호출했는지 확인하십시오.다른 Firebase 서비스를 사용하기 전에 앱을 사용합니다.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

// 헤드업 통지에 대한 [AndroidNotificationChannel] 생성
AndroidNotificationChannel? channel;

// [FlutterLocalNotificationsPlugin] 패키지를 초기화합니다.
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

DatabaseReference reference = FirebaseDatabase(
        databaseURL: "https://rend4things-default-rtdb.firebaseio.com/")
    .reference()
    .child("user");

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // 백그라운드 메시징 핸들러를 명명된 최상위 함수로 초기 설정
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      "high_importance_channel", // id
      // "High Importance Notifications", // title
      "This channel is used for important notifications.", // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // 안드로이드 알림 채널을 만듭니다.
    // 'AndroidManifest.xml' 파일에서 이 채널을 사용하여 다음을 재정의합니다.
    // 헤드업 알림을 활성화하는 기본 FCM 채널입니다.
    await flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel!);

    // iOS 포그라운드 알림 프레젠테이션 옵션 업데이트
    // 알림을 표시합니다.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: App(),
    );
  }
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin!.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel!.id,
                // channel!.name,
                "${channel!.description}",
                // 현재 사용 중인 적절한 그리기 가능한 리소스를 안드로이드에 추가하려면
                // 예제 앱에 이미 존재하는 것입니다.
                icon: 'launch_background',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("good !!!");
    });
    getRefreshToekn();
    super.initState();
  }

  // 토큰이 변경 될 가능성이 있다.
  void getRefreshToekn() {
    Stream<String> responseToken = FirebaseMessaging.instance.onTokenRefresh;
    responseToken.forEach((element) {
      // element 변경된 사용자의 토큰 값.
      // reference.child(로그인 한 유저의 아이디).update({"cloudMessageToken": token});
      reference.child("user2").update({"cloudMessageToken": element});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("firebase cloud message"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? token = await FirebaseMessaging.instance.getToken();
          print(
              "====================================== token ======================================");
          print(token);
          // CloudMessageToken
          // reference.child("user2").update({"cloudMessageToken": token});
          // reference.child(로그인 한 유저의 아이디).update({"cloudMessageToken": token});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

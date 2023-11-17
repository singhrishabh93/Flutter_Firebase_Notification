import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a Background Message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    getToken();
    initMessaging();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("data"),
        ),
        body: Center(
          child: Container(
            height: 100,
            width: 100,
            color: Colors.green,
          ),
        ));
  }

  void getToken() {
    _messaging.getToken().then((value) {
      String? token = value;
      print(token);
    });
  }

  void initMessaging() {
    var androiInit = AndroidInitializationSettings('@mimap/ic_launcher');
    // var iosInit = IOSInitializationSettings();
    var initSetting = InitializationSettings(android: androiInit);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initSetting);
    var androidDetails = AndroidNotificationDetails('1', 'Default',
        channelDescription: "Channel Description",
        importance: Importance.high,
        priority: Priority.high);
    // var iosDetails = IOSNotificationDetails();
    var generalNotificationDetails = NotificationDetails(
      android: androidDetails,
      // iOS: iosDetails,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message!.notification!;
      AndroidNotification android = message.notification!.android!;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(notification.hashCode,
            notification.title, notification.body, generalNotificationDetails);
      }
    });
  }
}

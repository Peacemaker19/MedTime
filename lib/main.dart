import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:medtime/screens/home.dart';
import 'package:medtime/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medtime/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medtime/screens/splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fcm = await FirebaseMessaging.instance.getToken();
  print('FirebaseToken: $fcm');

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true);
  print('User Granted Permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Message Data: ${message.data}');
    if (message.notification != null) {
      print('Message also contained a Notification: ${message.notification}');
    }
  });
  runApp(const ProviderScope(
    child: MaterialApp(
      home: MedTime(),
    ),
  ));
}

class MedTime extends StatelessWidget {
  const MedTime({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        if (snapshot.hasData) {
          return const HomeMedLife();
        }
        return const MedLogin();
      },
    );
    ;
  }
}


import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app_1/pages/splash.dart';
import 'package:my_app_1/services/chat.dart';
import 'package:my_app_1/services/notifications.dart';
import 'firebase_options.dart';

// Create an instance of the FlutterLocalNotificationsPlugin

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;
  // Get.put(MessageService());
  Get.lazyPut(() => MessageService());
  // Get.lazyPut(() => ChannelService());
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // String? token = await FirebaseMessaging.instance.getToken();

  // Initialize local notifications
  await initializeLocalNotifications();

  // Set up Firebase Messaging handlers
  FirebaseMessaging.onMessage.listen(foregroundNotificationHandler);
  FirebaseMessaging.onBackgroundMessage(backgroundNotificationHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Scaffold(
            body: Center(child: Text('Welcome to my home page'))));
  }
}

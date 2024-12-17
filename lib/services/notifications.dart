import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../firebase_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Initialize Local Notifications
Future<void> initializeLocalNotifications() async {
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
  );

  // Initialize the local notifications plugin
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Create notification channel for Android 8.0 and above
  createNotificationChannel();
}

// Create Notification Channel (Needed for Android 8.0 and above)
void createNotificationChannel() {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'default_channel_id', // Channel ID
    'Default Channel', // Channel Name
    description: 'This is the default notification channel',
    importance: Importance.high,
    playSound: true,
  );

  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

// Foreground notification handler
void foregroundNotificationHandler(RemoteMessage message) async {
  try {
    // Push notification to Firebase Realtime Database
    DatabaseReference messagesRef = FirebaseDatabase.instance.ref("messages");
    await messagesRef.push().set({
      'title': message.notification?.title ?? "No title",
      'body': message.notification?.body ?? "No body",
      'date': message.sentTime?.toString() ?? "No date",
    });

    // Show local notification
    if (message.notification != null) {
      await flutterLocalNotificationsPlugin.show(
        0, // Notification ID
        message.notification!.title, // Title
        message.notification!.body, // Body
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'default_channel_id', // Channel ID
            'Default Channel', // Channel Name
            channelDescription:
                'Your notification description', // Channel Description
            importance: Importance.high,
            priority: Priority.high,
            showWhen: false,
          ),
        ),
      );
    }
  // ignore: empty_catches
  } catch (e) {
  }
}

// Background notification handler
@pragma('vm:entry-point')
Future<void> backgroundNotificationHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    DatabaseReference notificationsRef =
        FirebaseDatabase.instance.ref("notifications");
    await notificationsRef.push().set({
      'title': message.notification?.title ?? "No title",
      'body': message.notification?.body ?? "No body",
      'date': message.sentTime?.toString() ?? "No date",
    });

    // ignore: empty_catches
  } catch (e) {}
}

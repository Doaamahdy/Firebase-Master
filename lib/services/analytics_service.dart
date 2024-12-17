import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Logs a custom event for when a user subscribes
  Future<void> logSubscribeEvent({required String userId, String? planType}) async {
    await _analytics.logEvent(
      name: 'subscribe',
      parameters: {
        'user_id': userId,
        'plan_type': planType ?? 'free', // Defaults to free if no plan type is specified
      },
    );
  }

  /// Logs a custom event for when a user unsubscribes
  Future<void> logUnsubscribeEvent({required String userId, String? reason}) async {
    await _analytics.logEvent(
      name: 'unsubscribe',
      parameters: {
        'user_id': userId,
        'reason': reason ?? 'none', // Defaults to 'none' if no reason is provided
      },
    );
  }


  /// Logs a custom event for adding a channel
  Future<void> logAddChannelEvent({required String userId, required String channelName}) async {
    await _analytics.logEvent(
      name: 'add_channel',
      parameters: {
        'user_id': userId,
        'channel_name': channelName,
      },
    );
  }

  /// Logs a custom event for pushing a message
  Future<void> logPushMessageEvent({required String userId, required String content }) async {
    await _analytics.logEvent(
      name: 'push_message',
      parameters: {
        'user_id': userId,
        'content': content ,
        'message_type': "Text" , // Defaults to 'general' if no type is specified
      },
    );
  }

  /// Sets the current user ID for analytics tracking
  Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
  }

  /// Sets custom user properties for analytics
  Future<void> setUserProperties({required String key, required String value}) async {
    await _analytics.setUserProperty(name: key, value: value);
  }
}

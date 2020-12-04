import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

class CloudMessaging {
  static final fbm = FirebaseMessaging();

  static Future<String> getToken() async {
    try {
      if (Platform.isIOS) await _checkforIosPermission();
      String token = await fbm.getToken();
      return token;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<void> _checkforIosPermission() async {
    await fbm.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    fbm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}

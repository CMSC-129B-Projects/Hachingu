import 'package:flutter/foundation.dart';
import 'package:hachingu/Utils/preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsProvider with ChangeNotifier {
  HachinguPreferences hachinguPreferences = HachinguPreferences();
  bool _notifications = false;

  bool get notifications => _notifications;

  set notifications(bool value) {
    _notifications = value;
    hachinguPreferences.setNotifications(value);
    notifyListeners();
  }

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future initialize() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('hachingu_logo');
    IOSInitializationSettings iosInitializationSettings =
    IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async{});
    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
          if (payload != null){
            debugPrint('notification payload: '+ payload);
          }
        });
  }

  //Instant Notifications
  Future instantNotification() async{
    var android = AndroidNotificationDetails("id", "channel", "description");
    var ios = IOSNotificationDetails();
    var platform = new NotificationDetails(
      android: android,
      iOS: ios
    );

    await _flutterLocalNotificationsPlugin.show(
      0, "You have lessons waiting for you", "Sharpen your Korean language skills now", platform,
      payload: "Welcome to Hachingu"
    );
  }

  //Scheduled Notifications
  Future scheduledNotification(Time scheduled) async{
    var scheduleNotificationDateTime =
    DateTime.now().add(Duration(seconds: 4));
    var bigPicture = BigPictureStyleInformation(
      DrawableResourceAndroidBitmap("hachingu_notif_icon"),
      largeIcon: DrawableResourceAndroidBitmap("hachingu_notif_big"),
      contentTitle: "Hachingu Daily Reminder",
      summaryText: "Practice makes perfect",
      htmlFormatContent: true,
      htmlFormatContentTitle: true);

    var android  = AndroidNotificationDetails("id", "channel", "description", styleInformation: bigPicture);
    var platform = new NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.showDailyAtTime(
      0, "This is your daily reminder", "Practice now!", scheduled, platform
    );

  }

  //Cancel notifications
  Future cancelNotification() async{
    await _flutterLocalNotificationsPlugin.cancel(0);
  }


}
import 'package:flutter/material.dart';
import 'package:hachingu/Notifiers/email_sender.dart';
import 'package:hachingu/Notifiers/notifications_provider.dart';
import 'package:hachingu/Screens/SettingsScreen.dart';
import 'Screens/HomeScreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hachingu/Notifiers/dark_theme_provider.dart';
import 'package:hachingu/Utils/styles.dart';
import 'package:hachingu/Utils/preferences.dart';
//import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:workmanager/workmanager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await HachinguPreferences.init();
  runApp(Hachingu());
}

class Hachingu extends StatefulWidget {
  @override
  _HachinguState createState() => _HachinguState();
}

class _HachinguState extends State<Hachingu> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  NotificationsProvider notificationsChangeProvider = new NotificationsProvider();
  EmailProvider emailChangeProvider = new EmailProvider();
  FlutterLocalNotificationsPlugin localNotification;

  @override
  void initState() {
    super.initState();

    getCurrentAppTheme();
    getEmailStatus();
    getNotificationStatus();
  }
  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme = await themeChangeProvider.hachinguPreferences.getTheme();
  }
  void getEmailStatus() async {
    emailChangeProvider.email = await emailChangeProvider.hachinguPreferences.getEmails();
  }
  void getNotificationStatus() async {
    notificationsChangeProvider.notifications = await notificationsChangeProvider.hachinguPreferences.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<DarkThemeProvider>(
            create: (_) => themeChangeProvider
          ),
          ChangeNotifierProvider<NotificationsProvider>(
              create: (_) => notificationsChangeProvider
          ),
          ChangeNotifierProvider<EmailProvider>(
            create: (_) => emailChangeProvider,
          ),
        ],
        child: Consumer<DarkThemeProvider>(
            builder: (BuildContext context, value, Widget child) {
              return MaterialApp(
                theme: Styles.themeData(themeChangeProvider.darkTheme, context),
                home: HomeScreen(),
              );
            }
        )
    );
  }
}

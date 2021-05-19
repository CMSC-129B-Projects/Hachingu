import 'package:flutter/material.dart';
import 'package:hachingu/Notifiers/email_sender.dart';
import 'package:hachingu/Notifiers/notifications_provider.dart';
import 'Screens/HomeScreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hachingu/Notifiers/dark_theme_provider.dart';
import 'package:hachingu/Utils/styles.dart';
import 'dart:math';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndroid =
    AndroidInitializationSettings('hachingu_logo');
  var initializationSettingsIOS = IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification:
    (int id, String title, String body, String payload) async{});
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
    onSelectNotification: (String payload) async {
      if (payload != null){
        debugPrint('notification payload: '+ payload);
      }
    });
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
  TimeOfDay time;
  TimeOfDay picked;

  @override
  void initState() {
    super.initState();
    time = TimeOfDay.now();
    var androidInitialize = new AndroidInitializationSettings('hachingu_logo');
    var iOSInitialize = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    localNotification = new FlutterLocalNotificationsPlugin();
    localNotification.initialize(initializationSettings);
    getCurrentAppTheme();
  }
  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.hachinguPreferences.getTheme();
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
          )
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

//class MaterialAppWithTheme extends StatelessWidget {
//
//}

/*    return ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(ThemeData.dark()),
      child: new MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Styles.themeData(themeChangeProvider.darkTheme, context),
      home: HomeScreen(),
    );
  }
}*/

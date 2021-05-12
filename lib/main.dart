import 'package:flutter/material.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/ThemeChanger.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hachingu/Notifiers/dark_theme_provider.dart';
import 'package:hachingu/Utils/styles.dart';

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
  //var initializationSettings = InitializationSettings(
  //    initializationSettingsAndroid, initializationSettingsIOS);
  /*await flutterLocalNotificationsPlugin.initialize(initializationSettings,
    onSelectNotification: (String payload) async {
      if (payload != null){
        debugPrint('notification payload: '+ payload);
      }
    });*/

  runApp(Hachingu());
}

class Hachingu extends StatefulWidget {
  @override
  _HachinguState createState() => _HachinguState();
}

class _HachinguState extends State<Hachingu> {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    super.initState();
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
          ChangeNotifierProvider(
            create: (_) {
              return themeChangeProvider;
            },
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

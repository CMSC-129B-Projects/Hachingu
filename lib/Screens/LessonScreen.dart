import 'package:flutter/material.dart';
import 'package:hachingu/Screens/QuizScreen.dart';
import 'package:hachingu/Notifiers/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:hachingu/Screens/QuizScreen.dart';

class LessonScreen extends StatefulWidget {
  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  var sWidth, sHeight;

  @override
  Widget build(BuildContext context) {
    sWidth = MediaQuery.of(context).size.width;
    sHeight = MediaQuery.of(context).size.height;

    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return LessonBody(themeProvider);
  }

  Widget LessonBody(DarkThemeProvider themeProvider) {

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Read & Write",
            style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 24,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xffF34F4E),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
      ),
      body: Center(
          child: ElevatedButton(
            child: Text("Show quiz"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizScreen()),
              );
            },
          )),
    );
  }
}

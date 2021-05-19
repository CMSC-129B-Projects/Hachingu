import 'package:flutter/material.dart';
import 'package:hachingu/Notifiers/dark_theme_provider.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  var sWidth, sHeight;

  @override
  Widget build(BuildContext context) {
    sWidth = MediaQuery.of(context).size.width;
    sHeight = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return QuizBody(themeProvider);
  }

  Widget QuizBody(DarkThemeProvider themeProvider) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz: Read & Write",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: 'OpenSans',
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xff47be02),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
      ),
      body: Text("Hello"),
    );
  }
  }

/*class QuizScreen extends StatelessWidget {
  var sWidth, sHeight;
  @override
  Widget build(BuildContext context) {
    sWidth = MediaQuery.of(context).size.width;
    sHeight = MediaQuery.of(context).size.height;

}*/

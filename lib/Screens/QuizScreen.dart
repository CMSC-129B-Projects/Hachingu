import 'package:flutter/material.dart';
import 'package:hachingu/Notifiers/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:hachingu/Screens/QuizResultsScreen.dart';

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
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text("Quiz: Read & Write",
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 24,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold)),
          backgroundColor: Color(0xff47be02),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
        ),
        body: Container(
            color: Theme.of(context).backgroundColor,
            child: Column(children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "What is the closest Hangul character for ka?",
                  style: TextStyle(
                      fontFamily: 'OpenSans',
                      color: Theme.of(context).primaryColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  height: sHeight * 0.60,
                  child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: <Widget>[
                      QuizCard("ᄇ"),
                      QuizCard("ᄀ"),
                      QuizCard("ᄂ"),
                      QuizCard("ᄃ"),
                      ElevatedButton(
                        child: Text("Results"),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuizResultsScreen()),
                              (route) => false);
                        },
                      )
                    ],
                  )),
            ])));
  }
}

class QuizCard extends StatelessWidget {
  final String description;

  const QuizCard(this.description);
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QuizScreen()),
          );
        },
        child: Container(
          height: 80,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.only(left: 10, right: 25),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                    Text(description,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            color: Color(0xFF424242),
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                  ])),
            ],
          ),
          decoration: BoxDecoration(
            color: Color(0xFFC5E1A5),
            boxShadow: [
              BoxShadow(
                  blurRadius: 8.0,
                  offset: Offset(-3.0, 3.0),
                  color: Colors.grey),
            ],
            borderRadius: BorderRadius.all(Radius.circular(26)),
          ),
        ));
  }
}

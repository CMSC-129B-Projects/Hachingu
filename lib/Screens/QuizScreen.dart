import 'package:flutter/material.dart';
import 'package:hachingu/Notifiers/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hachingu/Screens/QuizResultsScreen.dart';

class QuizScreen extends StatefulWidget {
  final String title;

  const QuizScreen(this.title);
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  var sWidth, sHeight;
  List _items = [
    {
      "question": "Loading...",
      "answer": "Loading...",
      "choices": ["Loading...", "Loading...", "Loading...", "Loading..."]
    }
  ];
  int indx = 0;

  @override
  void initState() {
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    sWidth = MediaQuery.of(context).size.width;
    sHeight = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return QuizBody(themeProvider);
  }

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/quizzes/' + widget.title + '.json');
    final data = await json.decode(response);
    setState(() {
      _items = data..shuffle();
      _items = _items.sublist(0, 11);
    });
  }

  void handleClick(description) {
    setState(() {
      _items[indx]["userAnswer"] = description;
      indx++;
    });
    if (indx == 10) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  QuizResultsScreen(widget.title, _items.sublist(0, 10))),
          (route) => false);
    }
  }

  Widget QuizBody(DarkThemeProvider themeProvider) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('Quiz: ${widget.title}',
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 24,
                  color: Theme.of(context).backgroundColor,
                  fontWeight: FontWeight.bold)),
          backgroundColor: Color(0xff47be02),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
        ),
        body: ListView(padding: EdgeInsets.all(20), children: <Widget>[
          Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(bottom: 20),
              child: Text(
                _items[indx]["question"].toString(),
                style: TextStyle(
                    fontFamily: 'OpenSans',
                    color: Theme.of(context).primaryColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              )),
          QuizCard(_items[indx]["choices"][0].toString(), handleClick),
          QuizCard(_items[indx]["choices"][1].toString(), handleClick),
          QuizCard(_items[indx]["choices"][2].toString(), handleClick),
          QuizCard(_items[indx]["choices"][3].toString(), handleClick)
        ]));
  }
}

class QuizCard extends StatelessWidget {
  final String description;
  final Function hClick;

  const QuizCard(this.description, this.hClick);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
          color: Colors.transparent,
          child: InkWell(
              onTap: () {
                hClick(description);
              },
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
              highlightColor: Color(0xff47be02).withOpacity(0.6),
              splashColor: Color(0xff47be02),
              child: Container(
                alignment: Alignment.center,
                child: Text(description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        color: Color(0xFF424242),
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
              ))),
      decoration: BoxDecoration(
        color: Color(0xFFC5E1A5),
        boxShadow: [
          BoxShadow(
              blurRadius: 8.0, offset: Offset(-3.0, 3.0), color: Colors.grey),
        ],
        borderRadius: BorderRadius.all(Radius.circular(26)),
      ),
    );
  }
}

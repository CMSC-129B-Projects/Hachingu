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
    bool shortText = _items[indx]["question"].toString().length < 70;
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('Quiz: ${widget.title}',
              style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 24,
                  color: Theme.of(context).backgroundColor,
                  fontWeight: FontWeight.bold)),
          backgroundColor: Color(0xff47be02),
          elevation: 3,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(16))),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                      alignment: Alignment.centerLeft,
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 4),
                      margin: EdgeInsets.only(bottom: 20),
                      child: Center(
                        child: Text(
                          _items[indx]["question"].toString(),
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              color: Theme.of(context).primaryColor,
                              fontSize: shortText ? 28 : 23,
                              fontWeight: shortText
                                  ? FontWeight.w600
                                  : FontWeight.w500),
                        ),
                      )),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      QuizCard(
                          _items[indx]["choices"][0].toString(), handleClick),
                      QuizCard(
                          _items[indx]["choices"][1].toString(), handleClick),
                      QuizCard(
                          _items[indx]["choices"][2].toString(), handleClick),
                      QuizCard(
                          _items[indx]["choices"][3].toString(), handleClick)
                    ],
                  ),
                )
              ]),
        ));
  }
}

class QuizCard extends StatelessWidget {
  final String description;
  final Function hClick;

  const QuizCard(this.description, this.hClick);
  @override
  Widget build(BuildContext context) {
    bool shortText = description.length < 16;
    return Container(
      height: 76,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
          color: Colors.transparent,
          elevation: 0,
          child: InkWell(
              onTap: () {
                hClick(description);
              },
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              highlightColor: Color(0xff47be02).withOpacity(0.6),
              splashColor: Color(0xff47be02),
              child: Container(
                alignment: Alignment.center,
                child: Text(description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                        fontFamily: 'Open Sans',
                        color: Color(0xFF424242),
                        fontSize: shortText ? 24 : 20,
                        fontWeight:
                            shortText ? FontWeight.bold : FontWeight.w500)),
              ))),
      decoration: BoxDecoration(
        color: Color(0xFFDBF0C8),
        // boxShadow: [
        //   BoxShadow(
        //       blurRadius: 8.0, offset: Offset(-3.0, 3.0), color: Colors.grey),
        // ],
        borderRadius: BorderRadius.all(Radius.circular(23)),
      ),
    );
  }
}

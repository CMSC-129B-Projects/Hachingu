import 'package:flutter/material.dart';
import 'package:hachingu/Notifiers/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:hachingu/Screens/HomeScreen.dart';
import 'package:hachingu/Screens/QuizScreen.dart';

class QuizResultsScreen extends StatefulWidget {
  final String title;
  final List items;

  const QuizResultsScreen(this.title, this.items);

  @override
  _QuizResultsScreenState createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends State<QuizResultsScreen> {
  var sWidth, sHeight;
  List _res;

  int getScore() {
    int count = 0;
    for (int i = 0; i < _res.length; i++) {
      if (_res[i]['evaluation']) {
        count++;
      }
    }
    return count * 10;
  }

  Color getColor() {
    int s = getScore();
    if (s >= 70) {
      return Color(0xff47be02);
    } else if (s >= 40) {
      return Color(0xfffab316);
    } else {
      return Color(0xffF34F4E);
    }
  }

  String getMessage() {
    int s = getScore();
    if (s >= 70) {
      return "GREAT WORK!";
    } else if (s >= 40) {
      return "ALMOST THERE!";
    } else {
      return "TRY AGAIN!";
    }
  }

  @override
  void initState() {
    super.initState();
    _res = widget.items;
    _res = _res
        .map((e) => {
              'question': e['question'],
              'answer': e['answer'],
              'userAnswer': e['userAnswer'],
              'evaluation': e['answer'] == e['userAnswer']
            })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    sWidth = MediaQuery.of(context).size.width;
    sHeight = MediaQuery.of(context).size.height;

    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return QuizResultsBody(themeProvider);
  }

  Widget QuizResultsBody(DarkThemeProvider themeProvider) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
          backgroundColor: getColor(),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              })),
      body: ListView(children: <Widget>[
        Container(
            alignment: Alignment.center,
            height: sHeight * 0.33,
            padding: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                color: getColor(),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(getMessage(),
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  Text("You got",
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                  Text(getScore().toString(),
                      style: TextStyle(
                          fontSize: 68,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  Text("percent",
                      style: TextStyle(fontSize: 20, color: Colors.white))
                ])),
        ReviewCard(_res),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkButton('RETRY', Colors.grey, QuizScreen(widget.title)),
              InkButton('PROCEED', Color(0xfffab316), HomeScreen()),
            ]),
        Container(height: 20)
      ]),
    );
  }
}

class ReviewCard extends StatefulWidget {
  final List results;

  const ReviewCard(this.results);

  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  int _markerPos = 0;
  List _res;

  @override
  void initState() {
    super.initState();
    _res = widget.results;
  }

  // const ReviewCard(this.mark);
  void _changePos(pos) {
    setState(() {
      _markerPos = pos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(children: <Widget>[
          ResultMark(_res.map((e) => e['evaluation']).toList(), _changePos),
          ShowTab(_markerPos),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_res[_markerPos]['question'],
                      style: TextStyle(fontSize: 20)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: <Widget>[
                      if (!_res[_markerPos]['evaluation'])
                        AnswerPill(_res[_markerPos]['userAnswer'], false),
                      AnswerPill(_res[_markerPos]['answer'], true)
                    ]),
                  )
                ]),
          )
        ]));
  }
}

class AnswerPill extends StatelessWidget {
  final String text;
  final bool correctAns;

  const AnswerPill(this.text, this.correctAns);
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white)),
              correctAns
                  ? Icon(Icons.check, color: Colors.white)
                  : Icon(Icons.close, color: Colors.white)
            ]),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: correctAns ? Color(0xff47be02) : Color(0xffF34F4E),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ));
  }
}

class ResultMark extends StatelessWidget {
  final List marks;
  final Function func;

  const ResultMark(this.marks, this.func);
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          for (var i = 0; i < marks.length; i++)
            Container(
              child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      onTap: () {
                        func(i);
                      },
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      highlightColor: marks[i]
                          ? Color(0xff47be02).withOpacity(0.6)
                          : Color(0xffF34F4E).withOpacity(0.6),
                      child: Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.width * 0.08,
                        width: MediaQuery.of(context).size.width * 0.08,
                        child: marks[i]
                            ? Icon(Icons.check, color: Colors.white)
                            : Icon(Icons.close, color: Colors.white),
                      ))),
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: marks[i] ? Color(0xff47be02) : Color(0xffF34F4E),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            )
        ]);
  }
}

class ShowTab extends StatelessWidget {
  final int pos;

  const ShowTab(this.pos);
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          for (var i = 0; i < 10; i++)
            Container(
                height: MediaQuery.of(context).size.width * 0.04,
                width: MediaQuery.of(context).size.width * 0.06,
                decoration: BoxDecoration(
                  color: i == pos ? Colors.black12 : Colors.transparent,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6)),
                ))
        ]);
  }
}

class InkButton extends StatelessWidget {
  final String text;
  final Color color;
  final screen;

  const InkButton(this.text, this.color, this.screen);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
          color: Colors.transparent,
          child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => screen),
                );
              },
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              highlightColor: color.withOpacity(0.6),
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.33,
                padding: EdgeInsets.all(20),
                child: Text(text,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ))),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
    );
  }
}

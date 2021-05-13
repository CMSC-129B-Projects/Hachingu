import 'package:flutter/material.dart';
import 'package:hachingu/Screens/LearnScreen.dart';

class QuizScreen extends StatelessWidget {
  var sWidth, sHeight;
  @override
  Widget build(BuildContext context) {
    sWidth = MediaQuery.of(context).size.width;
    sHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text("Quiz: Read & Write",
              style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          backgroundColor: Color(0xff47be02),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
        ),
        body: Container(
            // color: Color(0xffF34F4E),
            color: Colors.white,
            child: Column(children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "What is the closest Hangul character for ka?",
                  style: TextStyle(
                      fontFamily: 'OpenSans',
                      color: Colors.black,
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

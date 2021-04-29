import 'package:flutter/material.dart';
import 'package:hachingu/Screens/LessonScreen.dart';

class LearnScreen extends StatelessWidget {
  var sWidth, sHeight;
  @override
  Widget build(BuildContext context) {
    sWidth = MediaQuery.of(context).size.width;
    sHeight = MediaQuery.of(context).size.height;
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back, color: Colors.amber)),
        ),
        body: Container(
            // color: Color(0xffF34F4E),
            color: Colors.white,
            child: Column(children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Lessons",
                  style: TextStyle(
                      fontFamily: 'OpenSans',
                      color: Colors.black,
                      fontSize: 50,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  height: sHeight * 0.81,
                  child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: <Widget>[
                      LessonCard("assets/images/learn.PNG", "Reading",
                          "Learn to read hangul characters"),
                      LessonCard("assets/images/writing_hand.png", "Writing",
                          "Learn to write hangul characters"),
                      LessonCard(
                          "assets/images/teach.png",
                          "Sentence Structure",
                          "Learn about vocabulary, sentence word order, and more..."),
                      LessonCard("assets/images/discuss.png", "Conjugations",
                          "Learn about basic conjugations of verbs, adjectives, and more...")
                    ],
                  )),
            ])));
  }
}

class LessonCard extends StatelessWidget {
  final String imageName;
  final String title;
  final String description;

  const LessonCard(this.imageName, this.title, this.description);
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LessonScreen()),
          );
        },
        child: Container(
          height: 200,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.only(left: 10, right: 25),
          child: Row(
            children: <Widget>[
              Image.asset(
                imageName,
                width: 150,
                height: 150,
              ),
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                    Text(title,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                        )),
                    Text(description,
                        textAlign: TextAlign.right,
                        softWrap: true,
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Colors.white,
                          fontSize: 18,
                        )),
                  ])),
            ],
          ),
          decoration: BoxDecoration(
            color: Color(0xffF34F4E),
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

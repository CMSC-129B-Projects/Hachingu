import 'package:flutter/material.dart';
import 'package:hachingu/Notifiers/dark_theme_provider.dart';
import 'package:hachingu/Utils/styles.dart';
import 'package:provider/provider.dart';
import 'package:hachingu/Screens/LessonScreen.dart';


class LearnScreen extends StatefulWidget {
  @override
  _LearnScreenState createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen>{
  var sWidth, sHeight;

  @override
  Widget build(BuildContext context) {
    sWidth = MediaQuery.of(context).size.width;
    sHeight = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return LearnBody(themeProvider);
  }

  Widget LearnBody(DarkThemeProvider themeProvider){
    return new Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 1,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor, size: 30)),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        body: Container(
          // color: Color(0xffF34F4E),
            color: Theme.of(context).backgroundColor,
            child: Column(children: [
              Positioned(
                top: 0,
                child: Column(children: [
                  Container(
                    width: sWidth,
                    height: sHeight * 0.03,
                  ),
                  Text(
                    "Lessons",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'Open Sans',
                        color: Theme.of(context).primaryColor,
                        fontSize: 50,
                        fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
              Container(
                  height: sHeight * 0.73,
                  child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: <Widget>[
                      LessonCard("assets/images/learn.PNG", "Read & Write",
                          "Learn to read and write hangul characters"),
                      LessonCard("assets/images/teach.png", "Parts of Speech",
                          "Learn about nouns, verbs, adjectives, and adverbs"),
                      LessonCard("assets/images/learn.PNG", "Sentences",
                          "Learn to read and write hangul characters"),
                      LessonCard("assets/images/learn.PNG", "Read & Write",
                          "Learn to read and write hangul characters")
                    ],
                  )),
            ]
            )
        )
    );
  }
}

/*class LearnScreen extends StatelessWidget {
  var sWidth, sHeight;
  @override
  Widget build(BuildContext context) {
    sWidth = MediaQuery.of(context).size.width;
    sHeight = MediaQuery.of(context).size.height;

}*/

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
                blurRadius: 8.0, offset: Offset(-3.0, 3.0), color: Colors.grey),
          ],
          borderRadius: BorderRadius.all(Radius.circular(26)),
        ),
      )
    );
    }
}

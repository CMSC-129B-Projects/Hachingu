import 'package:flutter/material.dart';
import 'package:hachingu/Screens/TipsPopup.dart';
import 'package:hachingu/Screens/WritingScreen.dart';
import 'package:provider/provider.dart';
import 'package:hachingu/Notifiers/dark_theme_provider.dart';
import 'dart:math';

class TrainScreen extends StatefulWidget {
  @override
  _TrainScreenState createState() => _TrainScreenState();
}

class _TrainScreenState extends State<TrainScreen> {
  var sWidth, sHeight;

  List<String> tips = [
    "Creating a Korean Language Learning Schedule will greatly enhance your fluency of the language.",
    "Learn Hangul first which is the Korean alphabet.",
    "Master the most common words first.",
    "Having a study partner that is dedicated to speaking Korean will greatly enhance in reaching Korean Fluency as much as possible.",
    "Listen to Kpop songs. This enhances your vocabulary rapidly because you will learn the lyrics faster because of the melody.",
    "Write in Korean.",
    "Order and eat Korean food to practice your pronunciation.",
    "Watch Korean Dramas",
    "Hiring a private tutor greatly enhance your learning in the Korean language.",
    "Travel to South Korea. Practicing your skills with locals is the fastest way to learn.",
    "It will get easier. The hard part is you gotta do it everyday."
  ];

  @override
  Widget build(BuildContext context) {
    sWidth = MediaQuery.of(context).size.width;
    sHeight = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return TrainBody(themeProvider);
  }

  Widget TrainBody(DarkThemeProvider themeProvider) {
    return new Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Stack(
          children: [
            CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                elevation: 0,
                leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.amber)),
                backgroundColor: Theme.of(context).backgroundColor,
                pinned: true,
                expandedHeight: 200,
                flexibleSpace: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  return FlexibleSpaceBar(
                    title: Text("Challenges",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            height: 1,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.bold,
                            fontSize: constraints.maxHeight < 100
                                ? null
                                : constraints.maxHeight / 6)),
                    titlePadding: constraints.maxHeight < 100
                        ? null
                        : EdgeInsetsDirectional.only(
                            start: (200 / constraints.maxHeight) * 32,
                            bottom: constraints.maxHeight / 12),
                  );
                }),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  ChallengeCard("assets/images/neural_network.png", "Random",
                      "Answer characters, syllables, or words"),
                  ChallengeCard("assets/images/writing_hand.png", "Character",
                      "Test your character knowledge"),
                  ChallengeCard("assets/images/read_aloud_red.png", "Syllable",
                      "Test your syllable knowledge"),
                  // ChallengeCard("assets/images/discuss.png", "Word",
                  //     "Test your word knowledge"),
                  Container(height: 10)
                ]),
              )
            ]),
            Positioned(
              bottom: 0,
              right: 0,
              child: MaterialButton(
                  splashColor: Color(0xffFFEDBF),
                  focusColor: Colors.white.withAlpha(0),
                  highlightColor: Color(0xffFFEDBF),
                  height: 77,
                  minWidth: 77,
                  color: Color(0xfffAB316),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierColor: Colors.black.withAlpha(50),
                      builder: (BuildContext context) {
                        return TipsPopup(tips[Random().nextInt(tips.length)]);
                      },
                    );
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(38),
                          topRight: Radius.circular(38),
                          bottomRight: Radius.circular(42))),
                  child: Image.asset(
                    'assets/images/show-tips-icon.png',
                    width: 44,
                  )),
            ),
          ],
        ));
  }
}

class ChallengeCard extends StatelessWidget {
  final String imageName;
  final String title;
  final String description;

  const ChallengeCard(this.imageName, this.title, this.description);
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Color(0xff01AFE0),
          boxShadow: [
            BoxShadow(
                blurRadius: 8.0, offset: Offset(-3.0, 3.0), color: Colors.grey),
          ],
          borderRadius: BorderRadius.all(Radius.circular(26)),
        ),
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WritingScreen(title)),
                  );
                },
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                highlightColor: Color(0xff01AFE0).withOpacity(0.6),
                child: Container(
                    height: 200,
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
                                    fontWeight: FontWeight.bold,
                                  )),
                              Text(description,
                                  textAlign: TextAlign.right,
                                  softWrap: true,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  )),
                            ])),
                      ],
                    )))));
  }
}

import 'package:flutter/material.dart';
import 'package:hachingu/Notifiers/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:hachingu/Screens/LessonScreen.dart';

class LearnScreen extends StatefulWidget {
  @override
  _LearnScreenState createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  var sWidth, sHeight;

  @override
  Widget build(BuildContext context) {
    sWidth = MediaQuery.of(context).size.width;
    sHeight = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return HomeBody(themeProvider);
  }

  Widget HomeBody(DarkThemeProvider themeProvider) {
    return new Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: CustomScrollView(slivers: <Widget>[
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
            flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return FlexibleSpaceBar(
                title: Text("Lessons",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        height: 1,
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
              LessonCard("assets/images/read_aloud.png", "Reading",
                  "Learn to read hangul characters"),
              LessonCard("assets/images/writing_hand_blue.png", "Writing",
                  "Learn to write hangul characters"),
              LessonCard("assets/images/teach.png", "Sentence Structure",
                  "Learn about vocabulary, sentence word order, and more..."),
              LessonCard("assets/images/discuss.png", "Conjugations",
                  "Learn about basic conjugations of verbs, adjectives, and more..."),
              Container(height: 10)
            ]),
          )
        ]));
  }
}

class LessonCard extends StatelessWidget {
  final String imageName;
  final String title;
  final String description;

  const LessonCard(this.imageName, this.title, this.description);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
        decoration: BoxDecoration(
          color: Color(0xffF34F4E),
          boxShadow: [
            BoxShadow(
                blurRadius: 8.0, offset: Offset(-3.0, 3.0), color: Colors.grey),
          ],
          borderRadius: BorderRadius.all(Radius.circular(26)),
        ),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                highlightColor: Color(0xffF34F4E).withOpacity(0.6),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LessonScreen(title)),
                  );
                },
                child: Container(
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
                    )))));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hachingu/Notifiers/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:hachingu/Screens/QuizScreen.dart';

class LessonScreen extends StatefulWidget {
  final String title;

  const LessonScreen(this.title);

  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  var sWidth, sHeight;
  String _mdContent = '';

  @override
  void initState() {
    super.initState();
    _loadMdFile();
  }

  void _loadMdFile() async {
    String mdFromFile =
        await rootBundle.loadString('assets/lessons/' + widget.title + '.md');
    setState(() {
      _mdContent = mdFromFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    sWidth = MediaQuery.of(context).size.width;
    sHeight = MediaQuery.of(context).size.height;

    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return LessonBody(themeProvider);
  }

  Widget LessonBody(DarkThemeProvider themeProvider) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(widget.title,
            style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 24,
                color: Theme.of(context).backgroundColor,
                fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xffF34F4E),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
      ),
      body: ListView(padding: const EdgeInsets.all(24), children: <Widget>[
        MarkdownBody(data: _mdContent),
        Container(height: 50),
        Container(
            height: 180,
            padding: const EdgeInsets.only(right: 32),
            child: Row(children: <Widget>[
              Image.asset(
                "assets/images/neural_network.png",
                width: 128,
                height: 128,
              ),
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                    Text("Ready to test your mastery?",
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                    TextButton(
                      child: Text("Take Quiz!"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => QuizScreen()),
                        );
                      },
                    )
                  ]))
            ]),
            decoration: BoxDecoration(
              color: Color(0xff46be02),
              boxShadow: [
                BoxShadow(
                    blurRadius: 8.0,
                    offset: Offset(-3.0, 3.0),
                    color: Colors.grey),
              ],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(20)),
            )),
      ]),
    );
  }
}

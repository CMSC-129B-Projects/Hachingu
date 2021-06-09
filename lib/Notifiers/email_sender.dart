import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:hachingu/Utils/preferences.dart';

class EmailProvider with ChangeNotifier {
  HachinguPreferences hachinguPreferences = HachinguPreferences();
  bool _email = false;

  bool get email => _email;

  set email(bool value) {
    _email = value;
    hachinguPreferences.setEmails(value);
    notifyListeners();
  }

  EmailNotificationsEnabled(String user_email, TimeOfDay scheduled) async {
    //List<String> attachments = [];
    //bool isHTML = false;
    String username = 'hachinguemailtest@gmail.com';
    String password = 'hachingu123';
    //username = 'aabontilao@up.edu.ph';
    //password = 'Play_freak20137';

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username)
      ..recipients.add(user_email)
      ..subject = 'Hachingu Email Notifications Status'
      ..text = 'This is plain text'
      ..html = "<h1>Welcome to Hachingu!</h1><h2>You enabled email notifications!</h2><h2>From time to time, you'll get emails like this</h2>";

    double sched = toDouble(scheduled);
    print(sched);
    double now = toDouble(TimeOfDay.now());
    print(now);

    int hourDifference = scheduled.hour-TimeOfDay.now().hour;
    int minuteDifference = scheduled.minute-TimeOfDay.now().minute;

    if (minuteDifference<0){
      minuteDifference = minuteDifference+60;
      if (hourDifference == 0){
        hourDifference = 23;
      }
      else{
        hourDifference = hourDifference+24;
      }

    }
    print(hourDifference);
    print(minuteDifference);

    await Future.delayed(Duration(hours: hourDifference, minutes: minuteDifference));
    //if (sched >= now && sched <= (now+(1.0/60.0))) {
      try {
        print('Sending...');
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
      } on MailerException catch (e) {
        print('Message not sent.');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
    //}
    EmailNotificationsEnabled(user_email, scheduled);
  }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute/60.0;

  EmailNotificationsDisabled() async {
    String username = 'hachinguemailtest@gmail.com';
    String password = 'hachingu123';

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username)
      ..recipients.add('ardsbontilao2013@gmail.com')
      ..subject = 'Hachingu Email Notifications Status'
      ..text = 'This is plain text'
      ..html = "<h1>Hey there!</h1><h2>Looks like you disabled email notifications.</h2>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent ' + sendReport.toString());
      //Toast.show('You have turned on email notifications', context, duration: 3, gravity: Toast.CENTER);
    } on MailerException catch (e) {
      print('Message not sent');
    }
  }
}

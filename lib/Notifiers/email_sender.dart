import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:hachingu/Utils/preferences.dart';

class EmailProvider with ChangeNotifier {
  HachinguPreferences hachinguPreferences = HachinguPreferences();
  bool _email = false;
  int email_queue = 0;
  TimeOfDay saved;

  bool get email => _email;

  set email(bool value) {
    _email = value;
    hachinguPreferences.setEmails(value);
    notifyListeners();
  }

  EmailNotificationsEnabled(String user_email, TimeOfDay scheduled){

    if(scheduled != saved){
      saved = scheduled;
      email_queue = 0;
      print("Time change");
      EmailNotificationsEnabled1(user_email, scheduled);
    }
    else{
      email_queue++;
      print("Emails queued ${email_queue}");
      if (email_queue == 1) {
        EmailNotificationsEnabled1(user_email, scheduled);
      }
    }
  }

  EmailNotificationsEnabled1(String user_email, TimeOfDay scheduled) async {

    String username = 'hachinguemailtest@gmail.com';
    String password = 'hachingu123';

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username)
      ..recipients.add(user_email)
      ..subject = 'Hachingu Email Notifications Status'
      ..text = 'This is plain text'
      ..html = "<h1>Welcome to Hachingu!</h1><h2>You enabled email notifications!</h2><h2>This is your daily email reminder to practice!</h2>";

    int hourDifference = scheduled.hour-TimeOfDay.now().hour;
    int minuteDifference = scheduled.minute-TimeOfDay.now().minute;
    print(scheduled.minute);
    print(TimeOfDay.now().minute);

    if (minuteDifference<=0){
      minuteDifference = minuteDifference+60;
      if (hourDifference == 0){
        hourDifference = 23;
      }
    }
    if (hourDifference<0){
      hourDifference += 23;
    }
    print(hourDifference);
    print(minuteDifference);
    await Future.delayed(Duration(hours: hourDifference, minutes: minuteDifference));
    print("Email is ${_email}");
    print("${TimeOfDay.now().hour}, ${saved.hour}");
    print("${TimeOfDay.now().minute}, ${saved.minute}");
    if (email==true && saved.hour == TimeOfDay.now().hour && (saved.minute > TimeOfDay.now().minute - 2) && (saved.minute < TimeOfDay.now().minute + 2)) {
      try {
        print('Sending...');
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
        email_queue = 0;
      } on MailerException catch (e) {
        print('Message not sent.');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
    }
    EmailNotificationsEnabled(user_email, saved);
  }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  EmailNotificationsDisabled() async {
    String username = 'hachinguemailtest@gmail.com';
    String password = 'hachingu123';

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username)
      ..recipients.add('ardsbontilao2013@gmail.com')
      ..subject = 'Hachingu Email Notifications Status'
      ..text = 'This is plain text'
      ..html =
          "<h1>Hey there!</h1><h2>Looks like you disabled email notifications.</h2>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent ' + sendReport.toString());
      //Toast.show('You have turned on email notifications', context, duration: 3, gravity: Toast.CENTER);
    } on MailerException catch (e) {
      print('Message not sent');
    }
  }
}

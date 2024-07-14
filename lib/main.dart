import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reg Daily Reward Checker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness:Brightness.dark,
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF212121),
        canvasColor: const Color(0xFF303030),
        fontFamily: 'Merriweather',
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reg Daily Reward Checker'),
      ),
      body:
      Center(
        child:
        MaterialButton(onPressed: () => buttonPressed(context),
            color: Theme.of(context).primaryColor,
            child:
            const Text(
              "Check Daily Reward",
            )
        ),
      ),
    );
  }
  bool checking = false;
  void buttonPressed(BuildContext context) async {
    if (checking) return;
    checking = true;
    try {
      await check(context);
    } catch (i) {
      checking = false;
    }
    checking = false;
  }
  Future<void> check(BuildContext context) async {
    Uri url = Uri.parse("https://reg-daily-reward-api.vercel.app/api/checkPlayer");
    String res = (await http.get(url)).body;
    var parsed = jsonDecode(res);
    bool doneToday = parsed["result"] as bool;
    if (doneToday) {
      showAlertDialog() {
        Widget okButton = TextButton(
          child: const Text("Ok"),
          onPressed: () {
            Navigator.of(context).pop(context);
          },
        );
        AlertDialog alert = AlertDialog(
          title: const Text("Daily Reward"),
          content: Text("You claimed reward ${parsed["rewardStreak"]} today (${parsed["lastReward"]})"),
          actions: [
            okButton,
          ],
        );
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }
      showAlertDialog();
    } else {
      showAlertDialog() {
        Widget okButton = TextButton(
          child: const Text("Ok"),
          onPressed: () {
            Navigator.of(context).pop(context);
          },
        );
        AlertDialog alert = AlertDialog(
          title: const Text("!! Daily Reward !!"),
          content: Text("You did NOT do it today (${parsed["lastReward"]}).", style: const TextStyle(color: Colors.red)),
          actions: [
            okButton,
          ],
        );
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }
      showAlertDialog();
    }
  }
}

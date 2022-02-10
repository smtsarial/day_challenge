import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_challenge/db/firestore.dart';
import 'package:day_challenge/screens/challenge_lists.dart';
import 'package:day_challenge/screens/login/loginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future testData() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var data = await db.collection('event_details').get();
    var details = data.docs.toList();
    details.forEach((item) {
      print(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    testData();
    return MaterialApp(
        title: 'Events',
        theme: ThemeData(primarySwatch: Colors.green),
        home: LaunchScreen());
  }
}

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);
  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  late String userMail;
  Future<void> readySharedPreferences() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var _usermail = sharedPreferences.getString("userMail");
    print(_usermail.toString());
    setState(() {
      userMail = _usermail.toString();
    });
  }

  @override
  void initState() {
    readySharedPreferences().then((value) => print("--*" + userMail));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (userMail.length >= 5) {
      return Scaffold(
        body: Center(child: ChallengeList()),
      );
    } else {
      return Scaffold(
        body: Center(child: LoginPage()),
      );
    }
  }
}

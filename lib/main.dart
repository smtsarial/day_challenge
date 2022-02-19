import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_challenge/db/firestore.dart';
import 'package:day_challenge/screens/challenge_lists.dart';
import 'package:day_challenge/screens/login/loginScreen.dart';
import 'package:day_challenge/screens/login/profile.dart';
import 'package:day_challenge/screens/userSpecific/myChallenges.dart';
import 'package:day_challenge/screens/userSpecific/registeredChallenges.dart';
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
    //FirebaseFirestore db = FirebaseFirestore.instance;
    //var data = await db.collection('challenges').get();
    //var details = data.docs.toList();
    //details.forEach((item) {
    //  print(item);
    //});
  }

  @override
  Widget build(BuildContext context) {
    testData();
    return MaterialApp(
        title: 'Daily Challenges',
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
  late String userMail = "";
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
    super.initState();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  int _currentIndex = 0;
  final List _children = [
    ChallengeList(),
    RegisteredChallenges(),
    MyLists(),
    EditPage()
  ];
  @override
  Widget build(BuildContext context) {
    if (userMail.length >= 5) {
      return Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.white,
          backgroundColor: Colors.blueGrey,
          onTap: onTabTapped, // new
          currentIndex: _currentIndex, // new
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.app_registration),
              label: 'Joined',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'My Lists',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
          ],
        ),
      );
    } else {
      return Scaffold(
        body: Center(child: LoginPage()),
      );
    }
  }
}

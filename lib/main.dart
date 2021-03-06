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

  Future testData() async {}

  @override
  Widget build(BuildContext context) {
    testData();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Daily Challenges',
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        home: LaunchScreen(
          currentIndex: 0,
        ));
  }
}

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key, required this.currentIndex}) : super(key: key);
  final int currentIndex;
  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  late String userMail = "";
  Future<void> readySharedPreferences() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var _usermail = sharedPreferences.getString("userMail");
    setState(() {
      userMail = _usermail.toString();
    });
  }

  late int _currentIndex;

  @override
  void initState() {
    setState(() {
      _currentIndex = widget.currentIndex;
    });
    readySharedPreferences().then((value) => print("--*" + userMail));
    super.initState();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

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
              icon: Icon(Icons.favorite),
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

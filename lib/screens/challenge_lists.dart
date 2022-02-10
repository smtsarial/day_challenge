import 'package:day_challenge/db/firestore.dart';
import 'package:day_challenge/db/storage.dart';
import 'package:day_challenge/models/challenges.dart';

import 'package:day_challenge/screens/challenge_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChallengeList extends StatefulWidget {
  const ChallengeList({Key? key}) : super(key: key);

  @override
  _ChallengeListState createState() => _ChallengeListState();
}

class _ChallengeListState extends State<ChallengeList> {
  List<ChallengeDetail> challengeLists = [];
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
    readySharedPreferences().then((value) => print("asfasf: " + userMail));
    Storage.listFiles();
    if (mounted) {
      FirestoreHelper.getDetailsList().then((data) {
        setState(() {
          challengeLists = data;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Challenge List"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: challengeLists.length,
        itemBuilder: (context, position) {
          ChallengeDetail item = challengeLists[position];
          return Card(
            margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
            child: Column(
              children: [
                ListTile(
                    onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ChallengeDetailList(challenge_id: item.id)),
                          )
                        },
                    title: Text(
                      item.challenge_name,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    subtitle:
                        Text((item.author_fname + " " + item.author_lname)),
                    trailing: Wrap(
                      spacing: 12,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Text("Student"),
                              Text(item.registeredUserCount.toString())
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Text("Level"),
                              RatingBarIndicator(
                                rating: double.parse(item.star.toString()),
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 20.0,
                                direction: Axis.horizontal,
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:day_challenge/db/firestore.dart';
import 'package:day_challenge/main.dart';
import 'package:day_challenge/models/challenges.dart';
import 'package:day_challenge/models/dailyChallenges.dart';
import 'package:day_challenge/screens/userSpecific/editMyChallenges/editDay.dart';
import 'package:day_challenge/screens/userSpecific/editMyChallenges/editMainPage.dart';
import 'package:day_challenge/screens/userSpecific/myChallenges.dart';
import 'package:flutter/material.dart';

class EditDailyChallenge extends StatefulWidget {
  const EditDailyChallenge({Key? key, required this.challengeID})
      : super(key: key);
  final String challengeID;

  @override
  _EditDailyChallengeState createState() => _EditDailyChallengeState();
}

class _EditDailyChallengeState extends State<EditDailyChallenge> {
  ChallengeDetail myChallenge =
      new ChallengeDetail("", "", "", "", 0, "", "", "", 0);

  List<DailyChallenge> dailyChallenge = [];
  List<int> avaliableDays = [];
  List<int> avaliableDaysCompletedUserCount = [];
  List<String> avaliableDaysTopics = [];
  @override
  void initState() {
    FirestoreHelper.getSpecificChallenge(widget.challengeID).then((value) => {
          if (mounted)
            {
              setState(
                () => {
                  myChallenge = value,
                },
              )
            }
        });
    FirestoreHelper.getDailyTasks(widget.challengeID).then((value) => {
          for (int i = 0; i < value.length; i++)
            {
              avaliableDays.add(value[i].day_number),
              avaliableDaysCompletedUserCount
                  .add(value[i].completed_users.length),
              avaliableDaysTopics.add(value[i].day_topic),
            },
          if (mounted)
            {
              setState(
                () => {
                  dailyChallenge = value,
                },
              )
            }
        });
    super.initState();
  }

  void refreshData() {
    initState();
  }

  onGoBack(dynamic value) {
    refreshData();
    print("hello");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
            child: Text("Edit Your Challenge"),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => LaunchScreen(
                          currentIndex: 2,
                        )),
              );
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.details),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditChallengeMain(
                            challengeID: widget.challengeID,
                          )),
                ).then(onGoBack);
              },
            ),
          ]),
      body: ListView.builder(
        itemCount: myChallenge.day_count,
        itemBuilder: (context, position) {
          return Card(
            margin: EdgeInsets.fromLTRB(12, 5, 12, 5),
            child: Column(
              children: [
                ListTile(
                    onTap: () => {
                          if (avaliableDays.contains(position + 1))
                            {
                              dailyChallenge.forEach((element) {
                                if (element.day_number == (position + 1)) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditDay(
                                                dayObject: element,
                                                day: position + 1,
                                                challengeID: widget.challengeID,
                                              )));
                                }
                              }),
                            }
                          else
                            {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditDay(
                                            dayObject: new DailyChallenge(
                                                "", [], 0, [], ""),
                                            day: position + 1,
                                            challengeID: widget.challengeID,
                                          )))
                            }
                        },
                    title: Text(
                      (position + 1).toString() + ". Day",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    subtitle: avaliableDays.contains(position + 1)
                        ? Text(
                            "Topic: " +
                                avaliableDaysTopics[
                                        avaliableDays.indexOf(position + 1)]
                                    .toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        : Text(
                            "Empty",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                    trailing: Wrap(
                      spacing: 12,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              avaliableDays.contains(position + 1)
                                  ? Text(
                                      avaliableDaysCompletedUserCount[
                                                  avaliableDays
                                                      .indexOf(position + 1)]
                                              .toString() +
                                          " joined user",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(""),
                            ],
                          ),
                        ),
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

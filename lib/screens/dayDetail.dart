import 'package:day_challenge/db/firestore.dart';
import 'package:day_challenge/models/challenges.dart';
import 'package:day_challenge/models/dailyChallenges.dart';
import 'package:day_challenge/screens/challenge_detail.dart';
import 'package:day_challenge/screens/userSpecific/editMyChallenges/editDailyChallenge.dart';
import 'package:flutter/material.dart';

class DayDetail extends StatefulWidget {
  const DayDetail(
      {Key? key,
      required this.dayObject,
      required this.day,
      required this.challengeID,
      required this.challengeName,
      required this.challengeDesc})
      : super(key: key);
  final DailyChallenge dayObject;
  final int day;
  final String challengeID;
  final String challengeName;
  final String challengeDesc;
  @override
  _DayDetailState createState() => _DayDetailState();
}

class _DayDetailState extends State<DayDetail> {
  late String createdID = "";
  ChallengeDetail myChallenge =
      new ChallengeDetail("", "", "", "", 0, "", "", "", 0);
  TextEditingController dayTopic = TextEditingController();

  TextEditingController newTaskController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  bool dayStatus = false;
  List<dynamic> dayTasks = [];
  @override
  void initState() {
    if (mounted) {
      FirestoreHelper.checkDayStatus(widget.challengeID, widget.dayObject.id)
          .then((value) {
        setState(() {
          dayStatus = value;
        });
      });
    }
    setState(() {
      dayTasks = widget.dayObject.daily_tasks;
    });
    dayTopic =
        TextEditingController(text: widget.dayObject.day_topic.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.day.toString() + ". Day | " + widget.dayObject.day_topic,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            dayStatus == false
                ? (FlatButton(
                    onPressed: () {
                      FirestoreHelper.completeDayTasks(
                              widget.challengeID, widget.dayObject.id)
                          .then((value) {
                        if (value == true) {
                          setState(() {
                            dayStatus = true;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Task completed successfully"),
                          ));
                        } else {
                          setState(() {
                            dayStatus = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Error occured!"),
                          ));
                        }
                      });
                    },
                    child: Text(
                      'Complete',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )))
                : (FlatButton(
                    onPressed: () {
                      FirestoreHelper.removeDayTasks(
                              widget.challengeID, widget.dayObject.id)
                          .then((value) {
                        if (value == true) {
                          setState(() {
                            dayStatus = true;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Error Occured"),
                          ));
                        } else {
                          setState(() {
                            dayStatus = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Task removed successfully"),
                          ));
                        }
                      });
                    },
                    child: Text(
                      'Remove',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )))
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ChallengeDetailList(
                        challenge_id: widget.challengeID,
                        challenge_name: widget.challengeName,
                        challenge_description: widget.challengeDesc)),
              );
            },
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 14,
            ),
            Center(
              child: Text(
                "Daily Tasks",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ),
            Divider(),
            Flexible(
              child: Container(
                  child: dayTasks.length > 0
                      ? (ListView.builder(
                          itemCount: dayTasks.length,
                          itemBuilder: (context, position) {
                            return Card(
                              margin: EdgeInsets.fromLTRB(12, 5, 12, 5),
                              child: Column(
                                children: [
                                  ListTile(
                                    onTap: () => {},
                                    title: Text(
                                      dayTasks[position].toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ))
                      : Container(
                          child: Center(
                            child: Text(
                                "There is no task for this day. Please add new ones"),
                          ),
                        )),
            ),
          ],
        ));
  }
}

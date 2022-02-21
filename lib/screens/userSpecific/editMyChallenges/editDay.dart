import 'package:day_challenge/db/firestore.dart';
import 'package:day_challenge/models/challenges.dart';
import 'package:day_challenge/models/dailyChallenges.dart';
import 'package:day_challenge/screens/userSpecific/editMyChallenges/editDailyChallenge.dart';
import 'package:flutter/material.dart';

class EditDay extends StatefulWidget {
  const EditDay(
      {Key? key,
      required this.dayObject,
      required this.day,
      required this.challengeID})
      : super(key: key);
  final DailyChallenge dayObject;
  final int day;
  final String challengeID;
  @override
  _EditDayState createState() => _EditDayState();
}

class _EditDayState extends State<EditDay> {
  late String createdID = "";
  ChallengeDetail myChallenge =
      new ChallengeDetail("", "", "", "", 0, "", "", "", 0);
  TextEditingController dayTopic = TextEditingController();

  TextEditingController newTaskController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  List<dynamic> dayTasks = [];
  @override
  void initState() {
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
            "Edit " + widget.day.toString() + ". Day",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EditDailyChallenge(challengeID: widget.challengeID)),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _showMyDialog(context);
          },
          label: const Text('Add new task'),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
        body: Column(
          children: [
            Divider(),
            Center(
              child: Text(
                "Day Topic",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fill the area!';
                          }
                          return null;
                        },
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'Day topic',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                        ),
                        controller: dayTopic,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(150, 5, 150, 5),
                          primary: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32))),
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (_formKey.currentState!.validate()) {
                          if (widget.dayObject.id.length < 3) {
                            FirestoreHelper.addDailyChallenge(
                                    DailyChallenge("", [], widget.day, [],
                                            dayTopic.text)
                                        .toMap(),
                                    widget.challengeID,
                                    widget.day)
                                .then((value) => {
                                      if (value != null)
                                        {
                                          print(value.id),
                                          setState(() {
                                            createdID = value.id;
                                          }),
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "Day topic added successfully."),
                                          )),
                                        }
                                      else
                                        {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text("Error occured!"),
                                          )),
                                        }
                                    });
                          } else {
                            if (widget.dayObject.id != "") {
                              FirestoreHelper.updateDailyChallengeTopic(
                                      dayTopic.text,
                                      widget.challengeID,
                                      widget.dayObject.id)
                                  .then((value) {
                                if (value == true) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content:
                                        Text("Day topic updated successfully."),
                                  ));
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text("Error occured!"),
                                  ));
                                }
                              });
                            } else if (createdID != "") {
                              FirestoreHelper.updateDailyChallengeTopic(
                                      dayTopic.text,
                                      widget.challengeID,
                                      widget.dayObject.id)
                                  .then((value) {
                                if (value == true) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content:
                                        Text("Day topic updated successfully."),
                                  ));
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text("Error occured!"),
                                  ));
                                }
                              });
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Error occured!"),
                              ));
                            }
                          }
                        }
                      },
                      child: const Text('Save'),
                    ),
                    Divider(),
                    Center(
                      child: Text(
                        "Daily Tasks",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    )
                  ],
                )),
            Flexible(
              child: Container(
                  child: dayTasks.length > 0
                      ? (ListView.builder(
                          itemCount: dayTasks.length,
                          itemBuilder: (context, position) {
                            return Card(
                              margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
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
                                    trailing: IconButton(
                                        icon: Icon(Icons.cancel),
                                        onPressed: () {
                                          if (widget.dayObject.id != "") {
                                            FirestoreHelper.deleteDayTask(
                                                    widget.challengeID,
                                                    widget.dayObject.id,
                                                    dayTasks[position]
                                                        .toString())
                                                .then((value) {
                                              if (value != null) {
                                                setState(() {
                                                  dayTasks = value.daily_tasks;
                                                });
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(newTaskController
                                                          .text +
                                                      " Deleted succesfully"),
                                                ));
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content:
                                                      Text("Error occured!"),
                                                ));
                                              }
                                            });
                                          } else if (createdID != "") {
                                            FirestoreHelper.updateDayTask(
                                                    widget.challengeID,
                                                    createdID,
                                                    dayTasks[position]
                                                        .toString())
                                                .then((value) {
                                              if (value != null) {
                                                setState(() {
                                                  dayTasks = value.daily_tasks;
                                                });
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(newTaskController
                                                          .text +
                                                      " Deleted succesfully"),
                                                ));
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content:
                                                      Text("Error occured!"),
                                                ));
                                              }
                                            });
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Please first add a day topic."),
                                            ));
                                          }
                                        }),
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

  Future<void> _showMyDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a new task for day ' + widget.day.toString()),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Form(
                    key: _formKey1,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please fill the area!';
                              }
                              return null;
                            },
                            autofocus: false,
                            decoration: InputDecoration(
                              hintText: 'Add day task',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                            ),
                            controller: newTaskController,
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                if (_formKey1.currentState!.validate()) {
                  if (widget.dayObject.id != "") {
                    FirestoreHelper.updateDayTask(widget.challengeID,
                            widget.dayObject.id, newTaskController.text)
                        .then((value) {
                      if (value != null) {
                        setState(() {
                          dayTasks = value.daily_tasks;
                          newTaskController.text = "";
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              newTaskController.text + " added succesfully"),
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Error occured!"),
                        ));
                      }
                    });
                  } else if (createdID != "") {
                    FirestoreHelper.updateDayTask(widget.challengeID, createdID,
                            newTaskController.text)
                        .then((value) {
                      if (value != null) {
                        setState(() {
                          dayTasks = value.daily_tasks;
                          newTaskController.text = "";
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              newTaskController.text + " added succesfully"),
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Error occured!"),
                        ));
                      }
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Please first add a day topic."),
                    ));
                  }
                }
              },
              child: const Text('Save'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

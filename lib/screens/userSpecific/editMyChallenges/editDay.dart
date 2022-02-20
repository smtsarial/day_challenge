import 'package:day_challenge/db/firestore.dart';
import 'package:day_challenge/models/challenges.dart';
import 'package:day_challenge/models/dailyChallenges.dart';
import 'package:flutter/material.dart';

class EditDay extends StatefulWidget {
  const EditDay(
      {Key? key,
      required this.dayID,
      required this.day,
      required this.challengeID})
      : super(key: key);
  final DailyChallenge dayID;
  final int day;
  final String challengeID;
  @override
  _EditDayState createState() => _EditDayState();
}

class _EditDayState extends State<EditDay> {
  ChallengeDetail myChallenge =
      new ChallengeDetail("", "", "", "", 0, "", "", "", 0);
  @override
  void initState() {
    dayTopic = TextEditingController(text: widget.dayID.day_topic.toString());
    super.initState();
  }

  TextEditingController dayTopic = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Edit " + widget.day.toString() + ". Day",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _showMyDialog();
          },
          label: const Text('Add new task'),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
        body: Column(
          children: [
            Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                        flex: 7,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please fill the area!';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Day topic',
                            ),
                            controller: dayTopic,
                          ),
                        )),
                    Expanded(
                      flex: 3,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (_formKey.currentState!.validate()) {
                            if (widget.dayID.id.length < 3) {
                              FirestoreHelper.addDailyChallenge(
                                      DailyChallenge("", [], widget.day, [],
                                              dayTopic.text)
                                          .toMap(),
                                      widget.challengeID)
                                  .then((value) => {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  value.day_topic.toString())),
                                        ),
                                      });
                            }
                          }
                        },
                        child: const Text('Save'),
                      ),
                    )
                  ],
                )),
            Flexible(
              child: Container(
                child: ListView.builder(
                  itemCount: widget.dayID.daily_tasks.length,
                  itemBuilder: (context, position) {
                    return Card(
                      margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () => {},
                            title: Text(
                              widget.dayID.daily_tasks[position].toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: Icon(Icons.cancel),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please fill the area!';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Day topic',
                  ),
                  controller: dayTopic,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

import 'package:day_challenge/db/auth.dart';
import 'package:day_challenge/screens/userSpecific/editMyChallenges/createNewChallenge.dart';
import 'package:day_challenge/screens/userSpecific/editMyChallenges/editDailyChallenge.dart';
import 'package:day_challenge/screens/userSpecific/editMyChallenges/editMainPage.dart';
import 'package:flutter/material.dart';
import 'package:day_challenge/db/firestore.dart';
import 'package:day_challenge/models/challenges.dart';
import 'package:day_challenge/screens/challenge_detail.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLists extends StatefulWidget {
  const MyLists({Key? key}) : super(key: key);

  @override
  _MyListsState createState() => _MyListsState();
}

class _MyListsState extends State<MyLists> {
  List<ChallengeDetail> challengeLists = [];
  List<ChallengeDetail> challengeListsCopy = [];
  late String userMail;

  TextEditingController editingController = TextEditingController();

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
    Authentication().getUser().then(
        (value) => FirestoreHelper.getMyChallenges(value).then((value) => {
              if (mounted)
                {
                  setState(() {
                    challengeLists = value;
                    challengeListsCopy = value;
                  })
                }
            }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateNewChallenge()),
          );
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Container(
            child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        color: Colors.blueGrey,
                      ),
                      child: Column(
                        children: [
                          Container(
                              child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 2),
                            child: Text(
                              "My Challenges",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 21,
                                  color: Colors.white),
                            ),
                          )),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 2, 20, 15),
                            child: TextField(
                              onChanged: (value) {
                                filterSearchResults(value);
                              },
                              controller: editingController,
                              decoration: InputDecoration(
                                  iconColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(25.7),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: "Search Challenge",
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.0)))),
                            ),
                          ),
                        ],
                      )),
                )),
              ],
            ),
            Expanded(
                child: challengeLists.isNotEmpty
                    ? ListView.builder(
                        itemCount: challengeLists.length,
                        itemBuilder: (context, position) {
                          ChallengeDetail item = challengeLists[position];
                          return Card(
                            margin: EdgeInsets.fromLTRB(12, 5, 12, 5),
                            child: Column(
                              children: [
                                ListTile(
                                    onTap: () => {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditDailyChallenge(
                                                        challengeID: item.id)),
                                          )
                                        },
                                    title: Text(
                                      item.challenge_name,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text((item.author_fname +
                                        " " +
                                        item.author_lname)),
                                    trailing: Wrap(
                                      spacing: 12,
                                      children: [
                                        Container(
                                          child: Column(
                                            children: [
                                              Text(
                                                "Type",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(item.type.toString())
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Column(
                                            children: [
                                              Text("Level"),
                                              RatingBarIndicator(
                                                rating: double.parse(
                                                    item.star.toString()),
                                                itemBuilder: (context, index) =>
                                                    Icon(
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
                      )
                    : Center(
                        child: Text("Challenges not found!"),
                      ))
          ],
        )),
      ),
    );
  }

  String filterSearchResults(String query) {
    List<ChallengeDetail> dummySearchList = [];
    dummySearchList.addAll(challengeLists);

    List<ChallengeDetail> dummyListData = [];
    if (query.isNotEmpty) {
      dummySearchList.forEach((item) {
        if (item.challenge_name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        challengeLists = dummyListData;
      });
      return "dummyListData";
    } else if (query.isEmpty) {
      setState(() {
        challengeLists = challengeListsCopy;
      });
      return "";
    } else {
      setState(() {
        challengeLists = dummySearchList;
      });
      return "dummySearchList";
    }
  }
}

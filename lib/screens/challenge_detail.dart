import 'package:day_challenge/db/ad_helper.dart';
import 'package:day_challenge/db/auth.dart';
import 'package:day_challenge/db/firestore.dart';
import 'package:day_challenge/main.dart';
import 'package:day_challenge/models/dailyChallenges.dart';
import 'package:day_challenge/screens/dayDetail.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ChallengeDetailList extends StatefulWidget {
  const ChallengeDetailList(
      {Key? key,
      required this.challenge_id,
      required this.challenge_name,
      required this.challenge_description})
      : super(key: key);
  final String challenge_id;
  final String challenge_name;
  final String challenge_description;
  @override
  _ChallengeDetailListState createState() => _ChallengeDetailListState();
}

class _ChallengeDetailListState extends State<ChallengeDetailList> {
  List<DailyChallenge> dailyChallenges = [];

  late bool isUserRegisteredToChallenge = true;
  late String userMail;

  @override
  void initState() {
    if (mounted) {
      _createBottomBannerAd();
      Authentication()
          .getUser()
          .then((value) => setState(() => userMail = value!));
      Authentication().getUser().then((value) =>
          FirestoreHelper.checkUserSubscribeOrNot(widget.challenge_id, value)
              .then((value) {
            setState(() => {isUserRegisteredToChallenge = value});
            if (value == true) {}
          }));

      FirestoreHelper.getDailyTasks(widget.challenge_id).then((data) {
        setState(() {
          dailyChallenges = data;
        });
        print(
            "ANANNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN\n");
      });
    }
    super.initState();
  }

  bool? checkRegistered(data) {
    List registeredOrNot = [];
    data.completed_users.forEach((element) {
      registeredOrNot.add(element.keys.contains(userMail.toString()));
    });
    return registeredOrNot.contains(true);
  }

  Future<bool> registerChallenge() async {
    var data = await Authentication().getUser().then((value) =>
        FirestoreHelper.registerChallenge(widget.challenge_id, value));

    await FirestoreHelper.userRegistedChallenge(userMail, widget.challenge_id);
    return data;
  }

  Future<bool> unregisterChallenge() async {
    var data = await Authentication().getUser().then((value) =>
        FirestoreHelper.unregisterChallenge(widget.challenge_id, value));

    await FirestoreHelper.userUNRegistedChallenge(
        userMail, widget.challenge_id);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 218, 218, 218),
        appBar: AppBar(
          title: Text(widget.challenge_name),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => LaunchScreen(currentIndex: 0)),
              );
            },
          ),
          actions: [
            isUserRegisteredToChallenge
                ? FlatButton(
                    onPressed: () {
                      unregisterChallenge().then(
                        (value) => value
                            ? setState(
                                (() => isUserRegisteredToChallenge = false))
                            : setState(
                                (() => isUserRegisteredToChallenge = true)),
                      );
                    },
                    child: Text(
                      'Unregister',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))
                : FlatButton(
                    onPressed: () {
                      setState(() {
                        registerChallenge().then(
                          (value) => value
                              ? setState(
                                  (() => isUserRegisteredToChallenge = true))
                              : setState(
                                  (() => isUserRegisteredToChallenge = false)),
                        );
                      });
                    },
                    child: Text(
                      'Join',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))
          ],
        ),
        bottomNavigationBar: _isBottomBannerAdLoaded
            ? Container(
                height: _bottomBannerAd.size.height.toDouble(),
                width: _bottomBannerAd.size.width.toDouble(),
                child: AdWidget(ad: _bottomBannerAd),
              )
            : null,
        body: isUserRegisteredToChallenge
            ? (dailyChallenges.length > 0
                ? (ListView.builder(
                    itemCount: dailyChallenges.length,
                    itemBuilder: (context, position) {
                      return Card(
                        color: checkRegistered(dailyChallenges[position])!
                            ? Colors.blueGrey[700]
                            : Colors.white,
                        margin: EdgeInsets.fromLTRB(12, 5, 12, 5),
                        child: Column(
                          children: [
                            ListTile(
                                onTap: () => {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DayDetail(
                                                  dayObject:
                                                      dailyChallenges[position],
                                                  day: position + 1,
                                                  challengeID:
                                                      widget.challenge_id,
                                                  challengeName:
                                                      widget.challenge_name,
                                                  challengeDesc: widget
                                                      .challenge_description,
                                                )),
                                      )
                                    },
                                title: Text(
                                  "Day " + (position + 1).toString(),
                                  style: TextStyle(
                                      color: checkRegistered(
                                              dailyChallenges[position])!
                                          ? Colors.grey[400]
                                          : Colors.lightGreenAccent[900],
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle:
                                    Text(dailyChallenges[position].day_topic),
                                trailing: Wrap(
                                  spacing: 12,
                                  children: [
                                    Icon(
                                      checkRegistered(
                                              dailyChallenges[position])!
                                          ? Icons.done
                                          : Icons.arrow_right,
                                    )
                                  ],
                                )),
                          ],
                        ),
                      );
                    },
                  ))
                : (Container(
                    child: Center(
                      child: Text("There is no avaliable day!"),
                    ),
                  )))
            : (SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: Center(
                          child: Column(
                        children: [
                          Text(
                            widget.challenge_name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Center(
                            child: Text(
                              widget.challenge_id,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      )),
                      padding: EdgeInsets.all(50),
                      color: Colors.blueGrey,
                    ),
                    Container(
                      child: Center(
                        child: Text(
                          dailyChallenges.length.toString() + " Days",
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      color: Colors.grey,
                      padding: EdgeInsets.all(20),
                    ),
                    Container(
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              "Challenge Description",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text(
                              widget.challenge_description.toString(),
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            )
                          ],
                        ),
                      ),
                      color: Color.fromARGB(26, 105, 105, 105),
                      padding: EdgeInsets.all(40),
                    )
                  ],
                ),
              )));
  }

  // ADD SECTION
  @override
  void dispose() {
    super.dispose();
    _bottomBannerAd.dispose();
  }

  late BannerAd _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;
  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBottomBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bottomBannerAd.load();
  }
}

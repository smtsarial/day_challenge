import 'package:day_challenge/db/auth.dart';
import 'package:day_challenge/main.dart';
import 'package:day_challenge/screens/challenge_lists.dart';
import 'package:day_challenge/screens/login/registerScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool _warningMessage = false;
  TextEditingController newTaskController = TextEditingController();

  final _formKey1 = GlobalKey<FormState>();
  String _warningMessageContent = "";
  late Authentication auth;
  bool _visibleCircular = false;
  @override
  void initState() {
    auth = Authentication();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: Center(
        child: Text(
          "DAILY CHALLENGES",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
      ),
    );

    final email = TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextField(
      controller: passwordController,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.fromLTRB(16, 5, 16, 0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          setState(() {
            _visibleCircular = true;
          });

          loginCheck(context);
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: _visibleCircular
            ? Visibility(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey,
                  color: Colors.blueGrey,
                  strokeWidth: 2,
                ),
                visible: _visibleCircular,
              )
            : Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final registerButton = Padding(
      padding: EdgeInsets.fromLTRB(16, 2, 16, 16),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RegisterScreen()));
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Register', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        _showMyDialog(context);
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            Visibility(
              child: Center(
                  child: Text(
                _warningMessageContent,
                style: TextStyle(
                  color: Colors.red[800],
                  fontWeight: FontWeight.bold,
                ),
              )),
              visible: _warningMessage,
            ),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            registerButton,
            forgotLabel
          ],
        ),
      ),
    );
  }

  Future<void> saveData(data) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("userMail", data);

    setState(() {});
  }

  Future loginCheck(context) async {
    if (passwordController.text.isEmpty && emailController.text.isEmpty) {
      setState(() {
        _warningMessage = true;
        _warningMessageContent = "Please fill all fields!";
        _visibleCircular = false;
      });
    } else {
      late String _userEmail = "";
      try {
        _userEmail =
            await auth.login(emailController.text, passwordController.text);

        await saveData(_userEmail.toString());
        FocusManager.instance.primaryFocus!.unfocus();

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => LaunchScreen(
                      currentIndex: 0,
                    )));
      } catch (err) {
        setState(() {
          _warningMessage = true;
          _warningMessageContent = "Your information wrong";
        });
      }
      setState(() {
        _warningMessageContent = "Login for user $_userEmail";
      });
    }
  }

  Future<void> _showMyDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Password Reset'),
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
                              hintText: 'Email Address',
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
                  Authentication()
                      .resetPassword(newTaskController.text)
                      .then((value) {
                    if (value == true) {
                      print("oke");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Password reset mail sent to " +
                            newTaskController.text),
                      ));
                      Navigator.pop(context);
                    } else {
                      print("hahah");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Error occured while sending email!"),
                      ));
                      Navigator.pop(context);
                    }
                  });
                }
              },
              child: const Text('Send Reset Mail'),
            ),
          ],
        );
      },
    );
  }
}

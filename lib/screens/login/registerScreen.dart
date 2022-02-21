import 'dart:typed_data';

import 'package:day_challenge/db/auth.dart';
import 'package:day_challenge/db/firestore.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController passwordController2 = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController Surname = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
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

    final email = TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill the area!';
        }
        return null;
      },
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final name1 = TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill the area!';
        }
        return null;
      },
      controller: name,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    final Surname1 = TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill the area!';
        }
        return null;
      },
      controller: Surname,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Surname',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final phone1 = TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill the area!';
        }
        return null;
      },
      controller: phone,
      keyboardType: TextInputType.phone,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Phone Number',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill the area!';
        }
        return null;
      },
      controller: passwordController,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password2 = TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill the area!';
        }
        return null;
      },
      controller: passwordController2,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final registerButton = Padding(
      padding: EdgeInsets.fromLTRB(16, 2, 16, 16),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          signUpValidation();
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
      onPressed: () {},
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: [
            Form(
              key: _formKey,
              child: Column(children: <Widget>[
                logo,
                SizedBox(height: 48.0),
                name1,
                SizedBox(
                  height: 8.0,
                ),
                Surname1,
                SizedBox(
                  height: 8.0,
                ),
                phone1,
                SizedBox(
                  height: 8.0,
                ),
                email,
                SizedBox(height: 8.0),
                password,
                SizedBox(height: 8.0),
                password2,
                SizedBox(height: 24.0),
                registerButton,
              ]),
            )
          ],
        ),
      ),
    );
  }

  Future signUpValidation() async {
    if (_formKey.currentState!.validate()) {
      if (passwordController.text == passwordController2.text) {
        await Authentication()
            .signUp(emailController.text, passwordController.text)
            .then((value) => {
                  if (value == true)
                    {
                      FirestoreHelper.addNewUser(name.text, Surname.text,
                          emailController.text, phone.text)
                    }
                  else
                    {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Error occured please try again!')),
                      )
                    }
                });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter the same password!')),
        );
      }
    }
  }
}

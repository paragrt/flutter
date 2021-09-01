import 'dart:io';

import 'package:dicee/ChatScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  bool showSpinner = false;
  String email;
  String password;
  String selectedColor = 'blue';
  List<String> colorList = [];
  final _auth = FirebaseAuth.instance;
  AnimationController controller;
  @override
  void initState() {
    super.initState();
    colorMap.forEach((k, v) => colorList.add(k));
    controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Dicee'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Hero(
              tag: 'heart',
              child: Icon(
                Icons.favorite,
                color: Colors.red,
                size: (24 +
                    96.0 * controller.value), //animation..24 to 96 in 3 seconds
                semanticLabel:
                    'Page to enter email and password to register for chat',
              )),
          TextField(
            obscureText: false,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
            onChanged: (value) {
              email = value;
            },
          ),
          TextField(
            obscureText: true,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
            onChanged: (value) {
              password = value;
            },
          ),
          Container(
            height: 100.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
          RaisedButton(
            onPressed: () async {
              setState(() {
                showSpinner = true;
              });
              try {
                print(
                    'Starting registration: Calling createUserWithEmailPass $email $password');
                final newUser = await _auth.createUserWithEmailAndPassword(
                    email: email, password: password);
                if (newUser != null) {
                  print('Success:User $email registered');
                  await _showMyDialog('Success', 'User $email registered');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatScreen(selectedColor)),
                  );
                } else {
                  print('Failure:User $email NOT registered');
                  await _showMyDialog('FAILURE', 'User $email NOT registered');
                }
                setState(() {
                  showSpinner = false;
                });
              } catch (e) {
                print('Exceptional Failure: $e');
                await _showMyDialog('FAILURE', 'User $email NOT registered');
              }
            },
            child: Text('Go Register!'),
          ),
        ],
      ),
    );
  }

  Future<void> _showMyDialog(String title, String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text(msg)],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in colorList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedColor,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedColor = value;
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in colorList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedColor = colorList[selectedIndex];
        });
      },
      children: pickerItems,
    );
  }
}

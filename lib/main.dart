import 'dart:convert';
import 'dart:core';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:dicee/login_screen.dart';
import 'package:dicee/registration_screen.dart';
import 'package:dicee/rounded_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.green,
        appBar: AppBar(
          title: Text('Dicee'),
          backgroundColor: Colors.blue,
        ),
        body: DicePage(),
      ),
    ),
  );
}

class _DicePageState extends State<DicePage> {
  int leftDice = 1;
  int rightDice = 2;

  void updateDice() {
    setState(() {
      leftDice = Random().nextInt(6) + 1;
      rightDice = Random().nextInt(6) + 1;
    });
  }

  void updateNextPage() {
    setState(() {
      leftDice = Random().nextInt(6) + 1;
      rightDice = Random().nextInt(6) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Hero(
                tag: 'heart',
                child: Icon(
                  Icons.favorite,
                  color: Colors.pink,
                  size: 48.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                )),
            Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    onPressed: updateDice,
                    child: Image.asset('images/dice$leftDice.png'),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: updateDice,
                    child: Image.asset('images/dice$rightDice.png'),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    color: Colors.amber,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => XylophoneWidget()),
                      );
                    },
                    child: Text(
                      'Play Xylophone',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Courier'),
                    ),
                  ),
                ),
              ],
            ),
          ]),
    );
  }
}

class DicePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DicePageState();
}

class XylophoneWidget extends StatelessWidget {
  final AudioCache audioCache = AudioCache();
  void play(String note) {
    print("Starting playing note assets/$note.wav");
    audioCache.play("$note.wav");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Xylophone Player"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                  tag: 'heart',
                  child: Icon(
                    Icons.favorite,
                    color: Colors.redAccent,
                    size: 24.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  )),
            ],
          ),
          Row(children: <Widget>[
            Expanded(
                child: FlatButton(
                    child: Text('SAA'),
                    onPressed: () {
                      play('SAA');
                    },
                    color: Colors.red)),
            Expanded(
                child: FlatButton(
                    child: Text('C3vL'),
                    onPressed: () {
                      play('C3vL');
                    },
                    color: Colors.redAccent)),
          ]),
          Row(children: <Widget>[
            Expanded(
                child: FlatButton(
                    child: Text('RAE'),
                    onPressed: () {
                      play('RAE');
                    },
                    color: Colors.yellowAccent)),
            Expanded(
                child: FlatButton(
                    child: Text('C3vH'),
                    onPressed: () {
                      play('C3vH');
                    },
                    color: Colors.yellow)),
          ]),
          Row(children: <Widget>[
            Expanded(
                child: FlatButton(
                    child: Text('GAA'),
                    onPressed: () {
                      play('GAA');
                    },
                    color: Colors.blue)),
            Expanded(
                child: FlatButton(
                    child: Text('D#3vH'),
                    onPressed: () {
                      play('D#3vH');
                    },
                    color: Colors.blueAccent)),
          ]),
          Row(children: <Widget>[
            Expanded(
                child: FlatButton(
                    child: Text('MAA'),
                    onPressed: () {
                      play('MAA');
                    },
                    color: Colors.indigo)),
            Expanded(
                child: FlatButton(
                    child: Text('F#3vH'),
                    onPressed: () {
                      play('F#3vH');
                    },
                    color: Colors.indigoAccent)),
          ]),
          Row(children: <Widget>[
            Expanded(
                child: FlatButton(
                    child: Text('PAA'),
                    onPressed: () {
                      play('PAA');
                    },
                    color: Colors.orange)),
            Expanded(
                child: FlatButton(
                    child: Text('A3vH'),
                    onPressed: () {
                      play('A3vH');
                    },
                    color: Colors.orangeAccent)),
          ]),
          Row(children: <Widget>[
            Expanded(
                child: FlatButton(
                    child: Text('DHA'),
                    onPressed: () {
                      play('DHA');
                    },
                    color: Colors.green)),
            Expanded(
                child: FlatButton(
                    child: Text('B3vH'),
                    onPressed: () {
                      play('B3vH');
                    },
                    color: Colors.greenAccent)),
          ]),
          Row(children: <Widget>[
            Expanded(
                child: FlatButton(
                    child: Text('NEE'),
                    onPressed: () {
                      play('NEE');
                    },
                    color: Colors.purple)),
            Expanded(
                child: FlatButton(
                    child: Text('F#3vH'),
                    onPressed: () {
                      play('F#3vH');
                    },
                    color: Colors.purpleAccent)),
          ]),
          RaisedButton(
            onPressed: () {
              // Navigate back to first route when tapped.
              Navigator.pop(context);
            },
            child: Text('Go back!'),
          ),
          RaisedButton(
            onPressed: () async {
              var myWeather = await getLocation();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LocationScreen(myWeather)),
              );
            },
            child: Text('Go Location Wdgt!'),
          ),
        ],
      ),
    );
  }

  dynamic getLocation() async {
    Position pos =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    var lat = pos.latitude;
    var lon = pos.longitude;
    var apiKey = '020c73e945f47d6618e4c7dc92efa10b';
    var url = 'https://api.openweathermap.org/data/2.5/weather';
    print('Calling openweathermap using $pos');
    try {
      http.Response resp =
          await http.get('$url?units=imperial&lat=$lat&lon=$lon&appid=$apiKey');
      if (resp.statusCode == 200) {
        var data = jsonDecode(resp.body);
        //make it human readable
        var timezone = data['timezone'] / 3600;
        print('tz = $timezone');
        data['timezone'] = timezone;
        data['dt'] = DateTime.fromMillisecondsSinceEpoch(data['dt'] * 1000);
        data['sys']['sunrise'] =
            DateTime.fromMillisecondsSinceEpoch(data['sys']['sunrise'] * 1000);
        data['sys']['sunset'] =
            DateTime.fromMillisecondsSinceEpoch(data['sys']['sunset'] * 1000);
        return data;
        //var wDesc = data['weather'][0]['description'];
        //var temperature = data['main']['temp'];
        //var city = data['name'];
        //print(
        //    'City= $city is at $temperature Fahrenheit and weather is $wDesc');
      } else {
        print('Error:${resp.statusCode} ${resp.headers}');
        throw Exception('Error:${resp.statusCode} ${resp.headers}');
      }
    } catch (e) {
      print(e);
      throw (e);
    }
  }
}

class LocationScreen extends StatefulWidget {
  LocationScreen(this.locationWeather);
  final locationWeather;
  @override
  State<StatefulWidget> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen>
    with SingleTickerProviderStateMixin {
  var _wthr;
  AnimationController controller;
  @override
  void initState() {
    super.initState();
    this._wthr = widget.locationWeather.toString();
    print(this._wthr);
    controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    controller.forward();
    controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.withOpacity(controller.value),
      appBar: AppBar(
        title: Text("Location"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Hero(
              tag: 'heart',
              child: Icon(
                Icons.favorite,
                color: Colors.red,
                size: (24 +
                    96.0 * controller.value), //animation..24 to 96 in 3 seconds
                semanticLabel: 'Text to announce in accessibility modes',
              )),
          TypewriterAnimatedTextKit(
            speed: Duration(milliseconds: 100),
            totalRepeatCount: 4,
            text: [this._wthr],
            textStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            pause: Duration(milliseconds: 100),
            displayFullTextOnTap: true,
            stopPauseOnTap: true,
          ),
          RoundedButton(
            title: 'Login',
            colour: Colors.lightBlueAccent,
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
          RoundedButton(
            title: 'Register',
            colour: Colors.lightBlueAccent,
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistrationScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  void prettyPrintJson(String input) {
    const JsonDecoder decoder = JsonDecoder();
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    final dynamic object = decoder.convert(input);
    final dynamic prettyString = encoder.convert(object);
    prettyString.split('\n').forEach((dynamic element) => print(element));
  }

  void prettyPrintJsonObj(dynamic object) {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    final dynamic prettyString = encoder.convert(object);
    prettyString.split('\n').forEach((dynamic element) => print(element));
  }
}

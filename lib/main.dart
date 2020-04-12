import 'package:abbygames/PlusGame.dart';
import 'package:abbygames/SpellingGame.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

SharedPreferences globalSharedPrefs;
int mystars = 0;

String formrequired(_) {
  if (_ == null || _ == '') {
    return 'Please fill in';
  }
  return null;
}

updateStars(bool correct) {
  chime(correct);

  if (correct)
    mystars++;
  else
    mystars--;
  if (mystars < 0) mystars = 0;
  globalSharedPrefs.setInt('mystars', mystars);
}

Future<AudioPlayer> chime(bool chime) async {
  AudioCache cache = new AudioCache();
  return await cache.play('${chime ? 'chime' : 'buzz'}.mp3');
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Games for Abby',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.pink,
          colorScheme: ColorScheme.dark(),
          height: 60,
        ),
        textTheme: TextTheme(
          headline: TextStyle(fontFamily: 'Avenir', fontSize: 50),
          title: TextStyle(fontFamily: 'Avenir', fontSize: 40),
          subtitle: TextStyle(fontFamily: 'Avenir', fontSize: 30),
          subhead: TextStyle(fontFamily: 'Avenir', fontSize: 30),
          display1: TextStyle(fontFamily: 'Avenir', fontSize: 60),
          display2: TextStyle(fontFamily: 'Avenir', fontSize: 70),
          display3: TextStyle(fontFamily: 'Avenir', fontSize: 80),
          display4: TextStyle(fontFamily: 'Avenir', fontSize: 90),
          caption: TextStyle(
              fontFamily: 'Avenir', color: Colors.black38, fontSize: 20),
          body1: TextStyle(fontFamily: 'Avenir', fontSize: 30),
          body2: TextStyle(fontFamily: 'Avenir', fontSize: 30),
          button: TextStyle(fontFamily: 'Avenir', fontSize: 20),
        ),
      ),
      home: Menu(),
    );
  }
}

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String name;
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    SharedPreferences.getInstance().then((_) {
      globalSharedPrefs = _;
      mystars = globalSharedPrefs.getInt('mystars') ?? 0;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(20),
        child: name == null ? askname() : menu(),
      ),
    );
  }

  Widget askname() {
    return Center(
      child: Form(
        key: _formkey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Hello! What is your name?'),
            TextFormField(
              autocorrect: false,
              // autofocus: true,
              onSaved: (_) => name = _,
              validator: formrequired,
              decoration: InputDecoration(
                prefixText: 'My name is ',
              ),
            ),
            SizedBox(height: 20),
            RaisedButton(
              onPressed: () {
                if (!_formkey.currentState.validate()) return;
                _formkey.currentState.save();

                chime(true);
                setState(() {});
              },
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  Widget menu() {
    return Column(
      children: <Widget>[
        Text(
          'Hi $name!',
          style: Theme.of(context).textTheme.title,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Text(
          'Pick an activity',
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 40),
        Card(
          child: ListTile(
            contentPadding: EdgeInsets.all(30),
            leading: Image.asset('assets/spelling.png'),
            title: Text('Spelling'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => SpellingGame(), fullscreenDialog: true));
            },
          ),
        ),
        Card(
          child: ListTile(
            contentPadding: EdgeInsets.all(30),
            leading: Image.asset('assets/math.png'),
            title: Text('Math'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => MathGame(), fullscreenDialog: true));
            },
          ),
        ),
        // Card(
        //   child: ListTile(
        //     title: Text('Math (-)'),
        //     onTap: () {
        //       Navigator.of(context)
        //           .push(MaterialPageRoute(builder: (_) => MinusGame()));
        //     },
        //   ),
        // ),
        Spacer(),
        Text('Collect Your Stars!'),
        MyStars(),
      ],
    );
  }
}

class MyStars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var list = <Widget>[];
    var s100 = (mystars / 100).floor();
    var s10 = ((mystars % 100) / 10).floor();
    var s1 = (mystars % 10).floor();
    list.addAll(List.generate(
        s100, (_) => Image.asset('assets/star100.png', height: 30)));
    list.addAll(List.generate(
        s10, (_) => Image.asset('assets/star10.png', height: 30)));
    list.addAll(
        List.generate(s1, (_) => Image.asset('assets/star1.png', height: 30)));

    return Wrap(
      children: list,
      alignment: WrapAlignment.center,
    );
  }
}

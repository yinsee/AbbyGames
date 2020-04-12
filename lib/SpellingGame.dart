import 'dart:io';
import 'dart:math';

import 'package:abbygames/main.dart';
import 'package:flutter/material.dart';

class SpellingGame extends StatefulWidget {
  @override
  _SpellingGameState createState() => _SpellingGameState();
}

class _SpellingGameState extends State<SpellingGame> {
  List<String> words;
  final _formkey = GlobalKey<FormState>();
  String word;
  String answer;
  int position;
  bool _iscorrect;
  final _editkey = GlobalKey();
  final _textcontroller = TextEditingController();

  @override
  void initState() {
    loadwords();
    super.initState();
  }

  loadwords() async {
    var result =
        await DefaultAssetBundle.of(context).loadString('assets/words.txt');
    words = result.split('\n').toList();
    generate();
    setState(() {});
  }

  generate() {
    _textcontroller.text = '';
    word = words[Random().nextInt(words.length)].toUpperCase();
    do {
      position = Random().nextInt(word.length);
    } while (!RegExp(r'[A-Z]').hasMatch(word[position]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Spelling!')),
      body: q(),
    );
  }

  q() {
    if (words == null)
      return Center(
        child: CircularProgressIndicator(),
      );

    List<Widget> front = List.generate(position, (_) => Text(word[_]));
    List<Widget> back = List.generate(
        word.length - position - 1, (_) => Text(word[position + _ + 1]));

    return Form(
      key: _formkey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
                  Spacer(),
                ] +
                front +
                [
                  Container(
                    width: 80,
                    margin: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _textcontroller,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), counter: Container()),
                      autocorrect: false,
                      autofocus: true,
                      enableSuggestions: false,
                      key: _editkey,
                      maxLength: 1,
                      onChanged: (_) {
                        _textcontroller.text =
                            _textcontroller.text.toUpperCase();
                      },
                      // readOnly: _iscorrect != null,
                      onSaved: (_) => answer = _,
                      validator: formrequired,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ] +
                back +
                [
                  Spacer(),
                ],
          ),
          SizedBox(height: 20),
          _iscorrect == null
              ? RaisedButton(
                  onPressed: () {
                    if (!_formkey.currentState.validate()) return;
                    _formkey.currentState.save();
                    _evaluate();
                  },
                  child: Text('Continue'),
                )
              : showresult(),
          Spacer(),
          Text('Collect Your Stars!'),
          MyStars(),
          Spacer(),
        ],
      ),
    );
  }

  _evaluate() {
    String ans = word[position];

    _iscorrect = (answer == ans);
    _textcontroller.text = ans;
    updateStars(_iscorrect);

    setState(() {});

    Future.delayed(Duration(seconds: 2), () {
      _iscorrect = null;
      generate();
      setState(() {});
    });
  }

  showresult() {
    if (_iscorrect) {
      return Icon(
        Icons.check,
        color: Colors.green,
        size: 40,
      );
    } else {
      return Icon(
        Icons.close,
        color: Colors.red,
        size: 40,
      );
    }
  }
}

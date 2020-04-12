import 'dart:math';

import 'package:abbygames/main.dart';
import 'package:flutter/material.dart';

class MathGame extends StatefulWidget {
  @override
  _MathGameState createState() => _MathGameState();
}

class _MathGameState extends State<MathGame> {
  final _formkey = GlobalKey<FormState>();
  final _editkey = GlobalKey();
  String answer;
  int v1, v2;
  bool sign;
  bool _iscorrect;

  final _textcontroller = TextEditingController();

  @override
  void initState() {
    generate();
    super.initState();
  }

  generate() {
    _textcontroller.text = '';
    v2 = Random().nextInt(5);
    sign = Random().nextBool();
    if (sign)
      v1 = Random().nextInt(100);
    else {
      v1 = Random().nextInt(100 - v2) + v2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Maths!')),
      body: q(),
    );
  }

  q() {
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
              Text('$v1 ${sign ? '+' : '-'} $v2 = '),
              Expanded(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: _textcontroller,
                  key: _editkey,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  autocorrect: false,
                  autofocus: true,
                  enableSuggestions: false,
                  // readOnly: _iscorrect != null,
                  onSaved: (_) => answer = _,
                  validator: formrequired,
                  keyboardType: TextInputType.number,
                ),
              ),
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
    int ans;
    if (sign) {
      ans = v1 + v2;
    } else {
      ans = v1 - v2;
    }

    _iscorrect = (int.parse(answer) == ans);
    _textcontroller.text = ans.toString();
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

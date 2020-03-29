import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(RandomAgent());

Text _text(String text, {
  Color color = Colors.green,
  bool isBold = false,
  double fontSize = 26 }) {
  return Text(
    text,
    style: TextStyle(
      color: color,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontSize: fontSize
    )
  );
}

Padding _pad(Widget widget, [EdgeInsets inset]) {
  return Padding(
      child: widget,
      padding: inset != null ? inset : EdgeInsets.all(10),
  );
}

class RandomAgent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aleatoriedade',
      home: AgentService(),
    );
  }
}

class AgentService extends StatefulWidget {
  @override
  _ServiceState createState() => _ServiceState();
}

class _ServiceState extends State<AgentService> {
  final String _imagePath = 'assets/images/background.jpg';
  final Random _rng = Random();
  final List<Widget> _messages = <Widget>[
      _text(
          'Uauuu...essa foi demais!',
            fontSize: 30, isBold: true
      ),
      _text(
          'Na próxima será mais difícil, essa foi muito fácil...',
            fontSize: 30,
            isBold: true
      ),
    _text(
        'Você é bom mesmo hein!?',
        fontSize: 30,
        isBold: true
    )
  ];

  int _hits = 0;
  int _level = 1;
  int _position = 0;
  int _attempts = 1;
  int _maxAttempts = 2;
  int _secret;
  Text _currentMsg;

  int _getTopValue() {
    return _level * 2;
  }

  int _getBottomValue() {
    return _getTopValue() * -1;
  }

  void _setSecret() {
    int _nextSecret = _rng.nextInt(_getTopValue());
    if (_rng.nextBool()) {
        _nextSecret *= -1;
    }
    _secret = _nextSecret;
  }

  void _incrementPosition({int amount = 1}) {
    if (_position < _getTopValue()) {
      setState(() {
        _currentMsg = null;
        _position += amount;
        _attempts++;
      });
    }
  }

  void _decrementPosition({int amount = 1}) {
    if (_position > _getBottomValue()) {
      setState(() {
        _currentMsg = null;
        _position -= amount;
        _attempts++;
      });
    }
  }

  void _handleAttempt({bool increment = true, bool longPress = false}) {
    if (_attempts >= _maxAttempts) {
      setState(() {
        _currentMsg = _text('Ooops...acabaram suas changes. Tente mais uma vez!');
        _maxAttempts = 2;
        _level = 1;
        _reset();
      });
    } else if (_position == _secret) {
      setState(() {
        _hits++;
        _level++;
        _maxAttempts = _getTopValue();
        _currentMsg = _getRandomMessage();
        _reset();
      });
    } else {
      int amount = 1;

      if (longPress) {
        amount = _level;
      }

      if (increment) {
        _incrementPosition(amount: amount);
      } else {
        _decrementPosition(amount: amount);
      }
    }
  }

  void _reset() {
    _position = 0;
    _attempts = 1;
    _setSecret();
  }
  
  Text _getRandomMessage() {
    int _index = _rng.nextInt(_messages.length);
    return _messages[_index];
  }

  @override
  Widget build(BuildContext context) {
    _setSecret();
    return Scaffold(
      body: _body()
    );
  }

  Widget _body() {
    return Stack(
      children: <Widget>[
        _image(),
        _pad(
            Stack(children: _centeredContent()),
            EdgeInsets.all(30)
        ),
      ],
    );
  }

  List<Widget> _centeredContent() {
    return <Widget>[
      Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _text(
                  'Mostre toda a sua inteligência(persistência)!',
                    fontSize: 30,
                    isBold: true
              )
            ],
          )
      ),
      Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _content(),
          )
      ),
      Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _text(
                  'Dica: pressione o botão por mais tempo e você dára um salto!',
                    isBold: true
              )
            ],
          )
      )
    ];
  }

  Widget _image() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(_imagePath),
            fit: BoxFit.cover,
        )
      ),
    );
  }

  List<Widget> _content() {
    int _bottomValue = _getBottomValue();
    int _topValue = _getTopValue();
    int _remainingAttempts = (_maxAttempts - _attempts) + 1;

    List<Widget> _mainContent = <Widget>[
      _text(
          'Existe um número secreto entre $_bottomValue e $_topValue.',
            fontSize: 30
      ),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buttons()
      ),
      _text('Posição atual: $_position', color: Colors.white),
      _text('Tentativas restantes: $_remainingAttempts', color: Colors.white),
      _text('Nível: $_level', color: Colors.white),
      _text('Conquistas: $_hits', color: Colors.white),
    ];

    if (_currentMsg != null) {
      _mainContent.insert(0, _currentMsg);
    }

    return _mainContent.map(_pad).toList();
  }

  List<Widget> _buttons() {
    return <Widget>[
      _pad(
        RaisedButton(
          onPressed: () => _handleAttempt(),
          onLongPress: () => _handleAttempt(longPress: true),
          child: _text('+ 1'),
        ),
        EdgeInsets.only(right: 50)
      ),
      RaisedButton(
        onPressed: () => _handleAttempt(increment: false),
        onLongPress: () => _handleAttempt(increment: false, longPress: true),
        child: _text('- 1'),
      )
    ];
  }
}


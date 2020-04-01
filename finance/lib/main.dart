import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart';

const Color primary = Colors.black;
const Color background = Colors.amber;

void main() async {
  runApp(FinanceApp());
}

Future<String> loadString(String path) {
  return rootBundle.loadString(path, cache: false);
}

class FinanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FinanceHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FinanceHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FinanceState();
}

class _FinanceState extends State<FinanceHome> {
  HgClient _hgClient = HgClient();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double _eurCurrency;
  double _usdCurrency;
  double _btcCurrency;

  TextEditingController _realController = TextEditingController();
  TextEditingController _usdController = TextEditingController();
  TextEditingController _eurController = TextEditingController();
  TextEditingController _btcController = TextEditingController();

  Widget _buildFinanceData(context, response) {
    if (response.hasError) {
      return _onInitError(response.error);
    }

    switch (response.connectionState) {
      case ConnectionState.none: // no-break
        return _buildWith(errorMsg: 'API retornou nenhum dado.');
      case ConnectionState.waiting: // no-break
        return _getLoader();
      case ConnectionState.done: // no-break
        return _buildWith(data: response.data);
      default: // no-break
        return _buildWith(errorMsg: 'Algo inesperado aconteceu!!!');
    }
  }

  Widget _buildWith({String errorMsg, Map data}) {
    if (errorMsg != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _openDialog(errorMsg),
        ),
      );
    }

    if (data != null) {
      _registerData(data);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _content()
        ),
      ),
    );
  }

  void _registerData(Map data) {
    _usdCurrency = data['results']['currencies']['USD']['buy'];
    _eurCurrency = data['results']['currencies']['EUR']['buy'];
    _btcCurrency = data['results']['currencies']['BTC']['buy'];
  }

  void _resetControllers() {
    _usdController.text = '';
    _eurController.text = '';
    _btcController.text = '';
  }

  void _onRealChanged(String value) {
    if (! _formKey.currentState.validate()) {
      return;
    }

    _resetControllers();

    if (value.isEmpty) {
      return;
    }

    double currentValue = double.parse(value);

    double usd = currentValue / _usdCurrency;
    double eur = currentValue / _eurCurrency;
    double btc = currentValue / _btcCurrency;

    _usdController.text = '${usd.toStringAsFixed(2)}';
    _eurController.text = '${eur.toStringAsFixed(2)}';
    _btcController.text = '${btc.toStringAsFixed(10)}';
  }

  List<Widget> _content() {
    return <Widget>[
      Icon(Icons.monetization_on, size: 50),
      _textField('Real', _realController, onChanged: _onRealChanged),
      _textField('Bitcoin', _btcController),
      _textField('Dólar', _usdController),
      _textField('Euro', _eurController),
    ];
  }

  List<Widget> _openDialog(String message) {
    return <Widget>[
      Text(message, style: TextStyle(color: primary, fontSize: 25)),
      FlatButton(
        child: Icon(Icons.refresh, size: 30),
        onPressed: () {
          setState(() {
            // force reset state
          });
        },
      )
    ];
  }

  Widget _onInitError(Object error) {
    String msg;
    
    if (error.toString().contains('Unable to load asset')) {
      msg = 'Chave da API não encontrada.';
    } else {
      msg = error.toString();
    }

    return _buildWith(errorMsg: 'Erro ao iniciar serviços. $msg');
  }

  Widget _getLoader() {
    return _buildWith(errorMsg: 'Carregando...');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _hgClient.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: background,
      body: _hgClient.asyncBuilder(_buildFinanceData, _onInitError, _getLoader()),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text('\$ Conversor \$', style: TextStyle(color: Colors.white)),
      centerTitle: true,
      backgroundColor: primary
    );
  }

  Padding _textField(String label, TextEditingController controller,
    {Function(String) onChanged}) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: TextFormField(
          onChanged: onChanged,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: primary, fontSize: 25)
          ),
          style: TextStyle(color: primary),
          controller: controller
      ),
    );
  }
}

class HgClient {
  String _keyPath;
  String _keyString;
  Client _httpSession = Client();
  String _currentUrl = 'https://api.hgbrasil.com/finance';

  HgClient([String key = 'assets/hgkey']) {
    _keyPath = key;
  }

  Future<Map> fetch() async {
    String url = _currentUrl;
    if (_keyString != null) {
      url += '?key=$_keyString';
    }
    Response httpResponse = await _httpSession.get(url);
    return json.decode(httpResponse.body);
  }

  FutureBuilder asyncBuilder(
      Function(BuildContext, AsyncSnapshot<Map<dynamic, dynamic>>) homeBuilder,
      Function(Object) onError,
      Widget loading) {

    if (_keyString == null) {
      return FutureBuilder(
          future: loadString(_keyPath).then((String key) {
            _keyString = key;

            return FutureBuilder(
              future: fetch(),
              builder: homeBuilder,
            );
          }),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              return snapshot.data;
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return loading;
            }

            return onError(snapshot.error);
          }
      );
    }

    return FutureBuilder(
      future: fetch(),
      builder: homeBuilder,
    );
  }

  void close() {
    _httpSession.close();
  }
}
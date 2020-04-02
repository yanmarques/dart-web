import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() async {
  runApp(CepApp());
}

class CepApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.greenAccent
      ),
      home: CepHome()
    );
  }
}

class CepHome extends StatefulWidget {
  final String title = 'CEP Mágico';

  @override
  State<StatefulWidget> createState() => _CepState();
}

class InvalidCep implements Exception {
  String cause;
  InvalidCep([this.cause = 'Invalid cep found.']);
}

class _CepState extends State<CepHome> {
  final String apiUrl = 'https://viacep.com.br/ws';
  
  TextEditingController _cepController = TextEditingController();
  Client _httpSession = Client();

  bool _hasResult = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _handleSubmit([String field]) {
    if (_formKey.currentState.validate()) {
      setState(() {
        _hasResult = true;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _httpSession.close();
  }

  Future<Map> _fetchCep() async {
    String cep = _cepController.text;
    Response httpResponse = await _httpSession.get('$apiUrl/$cep/json');

    if (httpResponse.statusCode == 400) {
      throw InvalidCep();
    }

    return json.decode(httpResponse.body);
  }

  Widget _buildCepResult(context, response) {
    if (response.hasError) {
      if (response.error is InvalidCep) {
        return _onError('Cep informado é invalido');
      }

      return _onError('Algo deu errado. Debug: ${response.error}');
    }

    switch (response.connectionState) {
      case ConnectionState.waiting:
        return _onWaiting();
      case ConnectionState.none:
        return _onError('Não foi possível obter nenhuma informação');
      case ConnectionState.done:
        return _buildResults(response.data);
      default:
        return _onError('Algo inesperado ocorreu');
    }
  }

  Widget _onError(String message) {
    return _content(
        Padding(
            padding: EdgeInsets.all(10),
            child: Text(message, style: TextStyle(color: Colors.redAccent))
        )
    );
  }

  Widget _buildResults(Map result) {
    // when an invalid-looking-good cep is sent
    // ex: 88780202
    if (result.containsKey('erro')) {
      return _onError('Cep informado é invalido');
    }

    _hasResult = false;
    List<TableRow> rows = List<TableRow>();

    result.forEach((key, value) {
      if (value.toString().isNotEmpty) {
        rows.add(
            TableRow(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Text(
                      key.toString().toUpperCase(),
                      style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Text(value)
                )
              ]
            )
        );
      }
    });

    return _content(
      Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: Table(children: rows),
      )
    );
  }

  Widget _onWaiting() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Carregando...')
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true
        ),
        body: _decideContent()
    );
  }

  Widget _decideContent() {
    if (_hasResult) {
      return FutureBuilder(
        future: _fetchCep(),
        builder: _buildCepResult,
      );
    }

    return _content();
  }

  SingleChildScrollView _content([Widget result]) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: _getFields(result),
            ),
          )
      ),
    );
  }

  List<Widget> _getFields([Widget result]) {
    List<Widget> fields = <Widget>[
      TextFormField(
        autofocus: true,
        keyboardType: TextInputType.text,
        controller: _cepController,
        onFieldSubmitted: _handleSubmit,
        decoration: InputDecoration(
          labelText: 'Cep',
          labelStyle: TextStyle(fontSize: 25)
        ),
        style: TextStyle(fontSize: 18),
      )
    ];

    if (result != null) {
      fields.add(result);
    }

    fields.add(Padding(
        padding: EdgeInsets.all(10),
        child: RaisedButton(
          child: Icon(Icons.forward),
          onPressed: _handleSubmit,
          color: Theme.of(context).primaryColor,
        )
      )
    );

    return fields;
  }
}


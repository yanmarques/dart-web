import 'package:flutter/material.dart';

void main() {
  runApp(IMCApp());
}

const primaryColor = Colors.green;

class IMCApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IMCHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class IMCHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IMCState();
  }
}

class _IMCState extends State<IMCHome> {
  _IMCState() {
    _init();
  }

  TextEditingController _weightController = TextEditingController();
  TextEditingController _heightController = TextEditingController();

  GlobalKey<FormState> _formKey;
  String _infoMsg;

  void _calculateAndShow() {
    double imc = _calculateIMC();

    setState(() {
      _infoMsg = 'IMC: ${imc.toStringAsPrecision(4)}';
    });
  }

  double _calculateIMC() {
    double weight = double.parse(_weightController.text) / 100;
    double height = double.parse(_heightController.text);

    return weight / (height * height);
  }

  void _resetFields() {
    _weightController.text = "";
    _heightController.text = "";

    setState(_init);
  }

  void _init() {
    _infoMsg = 'Informe seus dados!';
    _formKey = GlobalKey<FormState>();
  }

  void _handleSubmit([String field]) {
    if (field != null) {
      print('submitted from FormField');
    }

    if (_formKey.currentState.validate()) {
      _calculateAndShow();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _content(),
          )
        ),
      ),
    );
  }

  List<Widget> _content() {
    return <Widget>[
      Icon(Icons.people, size: 100, color: primaryColor),
      _textField(
        'Peso (kg)',
        _weightController,
        autoFocus: true,
      ),
      _textField(
        'Altura (m)',
        _heightController,
        onFieldSubmitted: _handleSubmit,
      ),
      _submitButton(),
      Text(
          _infoMsg,
          textAlign: TextAlign.center,
          style: TextStyle(color: primaryColor, fontSize: 20)
      )
    ];
  }

  TextFormField _textField(String title, TextEditingController controller,
        {Function(String) onFieldSubmitted, bool autoFocus = false}) {
    return TextFormField(
      onFieldSubmitted: onFieldSubmitted,
      autofocus: autoFocus,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: title,
        labelStyle: TextStyle(color: primaryColor, fontSize: 25)
      ),
      textAlign: TextAlign.center,
      style: TextStyle(color: primaryColor),
      controller: controller,
      validator: (value) {
        if (value.isEmpty) {
          return 'Valor não pode ficar vazio';
        }

        return null;
      }
    );
  }

  Padding _submitButton() {
    return Padding(
      padding: EdgeInsets.only(top: 30, bottom: 10),
      child: Container(
        height: 50,
        child: RaisedButton(
          color: primaryColor,
          child: Text('Calcular', style: TextStyle(color: Colors.white, fontSize: 25)),
          onPressed: _handleSubmit,
        )
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: primaryColor,
      centerTitle: true,
      title: Text('Calculador de IMC'),
      actions: <Widget>[
        IconButton(
          tooltip: 'Limpar campos',
          icon: Icon(Icons.refresh, color: Colors.white),
           onPressed: _resetFields,
        )
      ],
    );
  }
}
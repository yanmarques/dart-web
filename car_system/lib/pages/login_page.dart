import 'package:car_system/app_model.dart';
import 'package:car_system/utils/alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _loginCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  String _validateLogin(String text) {
    if (text.isEmpty) {
      return 'Preencha o campo de login';
    }

    return null;
  }

  String _validatePassword(String text) {
    if (text.isEmpty) {
      return 'Preencha o campo de senha';
    }

    if (text.length < 3) {
      return 'A senha deve conter 3 numeros';
    }

    return null;
  }

  void _handleLogin({bool force = false}) async {
    if (force || _formKey.currentState.validate()) {
      LoginModel model = Provider.of<LoginModel>(context);
      model.attemptLogin(_loginCtrl.text, _passwordCtrl.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    LoginModel model = Provider.of<LoginModel>(context);

    if (model.lastErrors != null) {
      alert(context, 'Usuario ou senha invalidos', 'Login incorreto');
      model.resetErrors();
    }

    _loginCtrl.text = 'admin';
    _passwordCtrl.text = '123';
    _handleLogin(force: true);
    return Text('Fazendo login...');
  }
}

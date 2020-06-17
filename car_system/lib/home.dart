import 'package:car_system/app_model.dart';
import 'package:car_system/constantes.dart';
import 'package:car_system/pages/login_page.dart';
import 'package:car_system/web/body.dart';
import 'package:car_system/web/header.dart';
import 'package:car_system/web/menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Size get size => MediaQuery.of(context).size;
  bool get exibeMenu => size.width > 500;

  @override
  Widget build(BuildContext context) {
    LoginModel model = Provider.of<LoginModel>(context);

    if (!model.isLoggedIn()) {
      return Center(
        child: LoginPage(),
      );
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          _header(),
          _body(),
        ],
      ),
    );
  }

  _header() {
    return Container(
      padding: EdgeInsets.all(16),
      width: size.width,
      height: alturaCabecalho,
      color: Colors.blue,
      child: Header(),
    );

  }

  _body() {
    return Container(
      width: size.width,
      height: size.height - alturaCabecalho,
      child: exibeMenu
          ? Row(
        children: <Widget>[
          _menu(),
          _direita(),
        ],
      )
          : _direita(),
    );

  }

  _menu() {
    return Container(
      width: larguraMenu,
      color: Colors.grey[100],
      child: Menu(),
    );
  }

  _direita() {
    return Container(
      //color: Colors.yellow,
      padding: EdgeInsets.all(16),
      width: exibeMenu ? size.width - larguraMenu : size.width,
      child: Body(),
    );

  }
}

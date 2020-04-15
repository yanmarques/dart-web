import 'package:car_system/pages/cars/main.dart';
import 'package:car_system/pages/default_page.dart';
import 'package:car_system/pages/usuarios_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ItemMenu {
  String titulo;
  IconData icone;
  Widget pagina;
  bool selecionado = false;
  ItemMenu(this.titulo, this.icone, this.pagina);
}

final List<ItemMenu> menus = [
  ItemMenu("Home", FontAwesomeIcons.home, PaginaDefault()),
  ItemMenu("Carros", FontAwesomeIcons.car, CarrosPage()),
  ItemMenu("Usuários", FontAwesomeIcons.user, UsuariosPage()),
];

class AppModel with ChangeNotifier {
  ItemMenu _item;

  Widget get page => _item.pagina;

  AppModel() {
   this._item = menus[0];
  }

  setPage(int index) {
    ItemMenu item = menus[index];
    this._item.selecionado = false;
    this._item = item;
    this._item.selecionado = true;
    notifyListeners();
  }
}
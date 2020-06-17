import 'dart:js';

import 'package:car_system/domain/usuario.dart';
import 'package:car_system/pages/cars/api.dart';
import 'package:car_system/pages/cars/main.dart';
import 'package:car_system/pages/default_page.dart';
import 'package:car_system/pages/upload_page.dart';
import 'package:car_system/pages/usuarios_page.dart';
import 'package:car_system/utils/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  ItemMenu("Upload", FontAwesomeIcons.upload, UploadPage()),
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

class UploadModel with ChangeNotifier {
  bool _displayProgress = false;
  String _url;

  String get url => _url;
  set url (String newUrl) {
    _displayProgress = false;
    _url = newUrl;
    notifyListeners();
  }

  Widget get widget {
    if (_displayProgress) {
      return CircularProgressIndicator();
    }

    if (_url == null) {
      return FlutterLogo(size: 50);
    }

    return Column(
      children: <Widget>[
        Image.network(_url),
        SelectableText(_url,
          onTap: () {
            Clipboard.setData(ClipboardData(text: _url));
          },
        ),
      ],
    );
  }

  showProgress() {
    _displayProgress = true;
    notifyListeners();
  }
}

class LoginModel with ChangeNotifier {
  Usuario _user;
  ErrorBag _errorBag;

  bool isLoggedIn () => currentUser != null;

  Usuario get currentUser => _user;
  ErrorBag get lastErrors => _errorBag;

  resetErrors() {
    _errorBag = null;
  }

  attemptLogin(String username, String password) async {
    try {
      Usuario newUser = await login(username, password);
      _user = newUser;
    } catch(error, stackTrace) {
      print('error: $error');
      _errorBag = ErrorBag(error, stackTrace);
    }
    notifyListeners();
  }
}
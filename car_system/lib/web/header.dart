import 'package:car_system/app_model.dart';
import 'package:flutter/material.dart';
import 'package:car_system/utils/alert.dart';
import 'package:provider/provider.dart';

class Header extends StatefulWidget {
  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  GlobalKey _estadoMenu = GlobalKey();
  Size get size => MediaQuery.of(context).size;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FlutterLogo(
        size: 50,
      ),
      title: Text(
        "Carros ${size.width.toInt()}/${size.height.toInt()}",
        style: TextStyle(fontSize: 20,color: Colors.white),
      ),
      trailing: _direita(),
    );
  }

  _direita() {
    LoginModel model = Provider.of<LoginModel>(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          model.currentUser.login,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        SizedBox(
          width: 20,
        ),
        InkWell(
          child: CircleAvatar(
            backgroundImage: NetworkImage(model.currentUser.profileImage),
          ),
          onTap: () {
            // abre o popup menu
            dynamic state = _estadoMenu.currentState;
            state.showButtonMenu();
          },
        ),
        PopupMenuButton<String>(
          key: _estadoMenu,
          padding: EdgeInsets.zero,
          onSelected: (value) {
            _onClickOptionMenu(context, value);
          },
          child: Icon(
            Icons.arrow_drop_down,
            size: 28,
            color: Colors.white,
          ),
          itemBuilder: (BuildContext context) => _getActions(),
        ),
      ],
    );
  }

  void _onClickOptionMenu(BuildContext context, String value) {
    //print("_onClickOptionMenu $value");
    if ("logout" == value) {

    } else if ("meus_dados" == value) {

    } else if ("alterar_senha" == value) {

    } else {

    }
    alert(context, value, "Usuario");
  }



  _getActions() {
    return <PopupMenuItem<String>>[
      PopupMenuItem<String>(
        value: "meus_dados",
        child: Text("Meus dados"),
      ),
      PopupMenuItem<String>(
        value: "alterar_senha",
        child: Text("Alterar senha"),
      ),
      PopupMenuItem<String>(
        value: "logout",
        child: Text("Logout"),
      ),
    ];
  }
}

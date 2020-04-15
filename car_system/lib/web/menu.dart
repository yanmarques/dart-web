import 'package:car_system/app_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: menus.length,
        itemBuilder: _itemMenu
    );
  }

  Widget _itemMenu(BuildContext context, int index) {
    ItemMenu item = menus[index];
    return Material(
      color: item.selecionado ? Theme.of(context).hoverColor : Colors.transparent,
      child: InkWell(
        onTap: (){
          Provider.of<AppModel>(context).setPage(index);
        },
        child: ListTile(
          leading: Icon(item.icone),
          title: Text(item.titulo, style: TextStyle(fontWeight: item.selecionado ? FontWeight.bold : FontWeight.normal)),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:car_system/app_model.dart';
import 'package:car_system/pages/cars/api.dart';
import 'package:car_system/pages/cars/car.dart';
import 'package:car_system/utils/alert.dart';
import 'package:car_system/utils/image.dart';
import 'package:car_system/web/web_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:link/link.dart';
import 'package:provider/provider.dart';

class RadioItem extends StatelessWidget {
  final RadioModel model;
  
  RadioItem(this.model);
  
  @override
  Widget build(BuildContext context) {
    return Text(
      model.name,
      style: TextStyle(color: model._selected ? Colors.black : Colors.black12),
    );
  }
}

class RadioModel {
  final String name;

  bool _selected = false;

  RadioModel(this.name);

  void unSelect() {
    _selected = false;
  }

  void select() {
    _selected = true;
  }
}

class StorePage extends StatefulWidget {
  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<StorePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final List<RadioModel> radioButtons = List<RadioModel>();

  StreamedFileChooser _chooser;

  // used when uploading an image, which is not synchronous
  String name;
  String description;
  String type;

  _StoreState() {
    List<String> names = [
      'Luxo',
      'Esportivo',
      'Clássicos',
    ];

    names.forEach((element) {
      radioButtons.add(RadioModel(element));
    });

    radioButtons.first.select();
  }

  @override
  void initState() {
    super.initState();
    _chooser = StreamedFileChooser(_onChooseChange);
  }

  void _onChooseChange(FileState state) async {
    if (state.file != null) {
      try {
        String url = await upload(
            context,
            state.file,
            Duration(
                seconds: 120
            )
        );

        await _handleStore(this.name, this.description, this.type, url);
      } catch (error, exception) {
        print('error: $error');
        print('error: $exception');
      }
    }
  }
  
  Widget _buildRadionButtons() {
    List<Widget> children = List<Widget>();

    radioButtons.forEach((e) {
      children.add(Padding(
          padding: EdgeInsets.all(15),
          child: InkWell(
            onTap: () {
              setState(() {
                radioButtons.forEach((element) => element.unSelect());
                e.select();
              });
            },
            child: RadioItem(e),
          )
      ));
    });

    return Row(children: children);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text('Cadastre um carro'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text('Name'),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextFormField(
                      controller: _nameCtrl,
                      autofocus: true,
                      validator: _validateNotEmpty,
                      keyboardType: TextInputType.text,
                    )
                  ),
                  Text('Descrição'),
                  Divider(),
                  Padding(
                      padding: EdgeInsets.all(15),
                      child: TextFormField(
                        controller: _descCtrl,
                        validator: _validateNotEmpty,
                        keyboardType: TextInputType.text,
                      )
                  ),
                  Text('Tipo'),
                  Divider(),
                  _buildRadionButtons(),
                  Center(
                    child: Row(
                      children: <Widget>[
                        RaisedButton(
                          child: Text('Cadastrar sem imagem'),
                          onPressed: _handleMultiStore(),
                        ),
                        SizedBox(width: 100),
                        RaisedButton(
                          child: Text('Cadastrar com imagem'),
                          onPressed: _handleMultiStore(withImage: true),
                        ),
                        SizedBox(width: 100),
                        RaisedButton(
                          child: Text('Cancelar'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    )
                  )
                ],
              ),
            )
        ),
      )
  );

  String _validateNotEmpty(String text) {
    if (text.isEmpty) {
      return 'Campo está vazio';
    }

    return null;
  }

  Function() _handleMultiStore({bool withImage = false}) {
    return () {
      if (_formKey.currentState.validate()) {
        RadioModel item = radioButtons.where((element) => element._selected).first;
        Function(String, String, String) handler;

        if (withImage) {
          handler = _handleStoreWithImage;
        } else {
          handler = _handleStore;
        }

        handler.call(_nameCtrl.text, _descCtrl.text, item.name);
      }
    };
  }

  void _handleStoreWithImage(String name, String description, String type) {
    this.name = name;
    this.description = description;
    this.type = type;
    _chooser.choose();
  }

  void _handleStore(String name, String description, String type, [String url]) async {
    try {
      await storeCar(context, name, description, type, url);
      Navigator.pop(context);
      alert(context, 'Carro cadastrado com sucesso', 'Cadastro');
    } catch(error, stackTrace) {
      print('error: $error');
    }
  }
}
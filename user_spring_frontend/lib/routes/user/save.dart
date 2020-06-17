import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:user_spring_frontend/entities/City.dart';
import 'package:user_spring_frontend/entities/User.dart';
import 'package:user_spring_frontend/providers/city.dart';
import 'package:user_spring_frontend/providers/main.dart';
import 'package:user_spring_frontend/providers/user.dart';

class Save extends StatefulWidget {
  @override
  _SaveState createState() => _SaveState();
}

class _SaveState extends State<StatefulWidget> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _cityNameController = TextEditingController();
  TextEditingController _cityCodeController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isInitialized = false;

  User user;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: _appBar(),
    body: Center(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _mainContent(context),
          ),
        )
      ),
    ),
  );

  _initWhenNeed(BuildContext context) {
    if (! _isInitialized) {
      _registerUserProvider();
      _registerCityProvider();
      _isInitialized = true;
    }
  }

  _registerUserProvider() {
    Provider.of<SavingUserFutureProvider>(context).on(
      target: (user) {
        print('user stream called');
        print(user);
        Navigator.of(context).pop();
        Provider.of<RefreshProvider>(context).refresh();
      }, 
      exception: (exception) {
        print('this is bad news');
        print(exception);
      });
  }

  _registerCityProvider() {
    Provider.of<SavingCityFutureProvider>(context).on(
      target: (city) {
        print('city stream called');
        print(city);

        // user must already be set
        user.city = city; 
        _saveUser();
      },
      exception: (exception) {
        print('city has bad newsss');
        print(exception);
      }
    );
  }

  _mainContent(BuildContext context) {
    print('bulding main content');
    _initWhenNeed(context);

    if (Provider.of<SavingCityFutureProvider>(context).isFetching) {
        return Provider.of<SavingCityFutureProvider>(context).listener.onFetching();
    }

    if (Provider.of<SavingUserFutureProvider>(context).isFetching) {
      return Provider.of<SavingUserFutureProvider>(context).listener.onFetching(); 
    }

    return <Widget>[
      _textField(
        'Nome', 
        _nameController, 
          validator: (value) => value.isEmpty ? 'Preencha o nome do usuário' : null
      ),
      _textField(
        'Cidade', 
        _cityNameController,
          validator: (value) => value.isEmpty && _cityCodeController.text.isNotEmpty 
            ? 'Preencha o nome da cidade' : null
      ),
      _textField('CEP', _cityCodeController),
      RaisedButton(
        child: Text('Salvar'),
        onPressed: _handleSubmit
      )
    ];
  }

  Widget _appBar() => AppBar(
    title: Text("Salvar usuário"),
    centerTitle: true,
  );

  void _handleSubmit([String field]) {
    if (_formKey.currentState.validate()) {
      user = User(name: _nameController.text);

      if (_cityNameController.text.isNotEmpty) {
        print('creating user');
        Provider.of<SavingCityFutureProvider>(context).start(
          City(
            code: _cityCodeController.text,
            name: _cityNameController.text
          )
        );
        print('started creation of user');
      } else {
        print('creating user without city');
        _saveUser();
        print('started creation of user without city');
      }

      // user = await Provider.of<SavingUserProvider>(context).withit(
      //   User(name: _nameController.text, city: city),
      //     justFetch: true 
      // );
    }
  }

  _saveUser() {
    Provider.of<SavingUserFutureProvider>(context).start(user);
  }

  _textField(String label, TextEditingController controller, 
    {bool autofocus = false, String Function(String) validator}) => 
    Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        autofocus: autofocus,
        keyboardType: TextInputType.text,
        controller: controller,
        decoration: InputDecoration(
          labelText: label
        ),
        style: TextStyle(
          color: Theme.of(context).primaryColor
        ),
        validator: validator,
        // validator: (value) => value.isEmpty ? 'Preencha este campo' : null
      )
    );
}

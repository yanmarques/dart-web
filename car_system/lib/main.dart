import 'package:car_system/app_model.dart';
import 'package:car_system/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppModel>(create: (_) => AppModel()),
        ChangeNotifierProvider<UploadModel>(create: (_) => UploadModel()),
        ChangeNotifierProvider<LoginModel>(create: (_) => LoginModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _theme(),
        home: HomePage(),
      ),
    );
  }

  _theme() {
    return ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        splashColor: Colors.blue,
        hoverColor: Colors.blue[100],
        textTheme: TextTheme(
          body1: TextStyle(
          fontSize: 22,
        ),
    ),
    );
  }
}

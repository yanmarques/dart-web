import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_spring_frontend/providers/city.dart';
import 'package:user_spring_frontend/providers/main.dart';
import 'package:user_spring_frontend/providers/user.dart';
import 'package:user_spring_frontend/routes/home.dart';

const primaryColor = Colors.green;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RefreshProvider()
        ),
        ChangeNotifierProvider(
          create: (_) => SavingUserFutureProvider()
        ),
        ChangeNotifierProvider(
          create: (_) => SavingCityFutureProvider()
        ),
        ChangeNotifierProvider(
          create: (_) => RemovingUserFutureProvider()
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _theme(),
        // home: Text('Hey')
        home: Home()
      ),
    );
  }

  _theme() => ThemeData(
    primaryColor: primaryColor,
    primarySwatch: primaryColor,
    scaffoldBackgroundColor: Colors.black,
    hoverColor: primaryColor,
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(
        color: primaryColor,
      ),
      fillColor: primaryColor,
    ),
    textTheme: TextTheme(
      bodyText2: TextStyle(
        fontSize: 22,
        color: primaryColor,
      ),
    ),
  );
}

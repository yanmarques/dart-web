import 'package:car_system/app_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Body extends StatelessWidget {
  AppModel app;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
        builder: (context, app, child) {
          return app.page;
        }
    );
  }
}

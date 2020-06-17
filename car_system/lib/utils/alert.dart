import 'package:flutter/material.dart';

class ErrorBag {
  final Error error;
  final StackTrace traceBack;

  ErrorBag(this.error, this.traceBack);
}

alert(BuildContext context, String msg, String titulo, {Function callback}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text(titulo),
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
                if(callback != null) {
                  callback();
                }
              },
            )
          ],
        ),
      );
    },
  );
}


alertConfirm(BuildContext context, String msg,String titulo, {Function confirmCallback}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text(titulo),
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Confirmar"),
              onPressed: () {
                Navigator.pop(context);
                if(confirmCallback != null) {
                  confirmCallback();
                }
              },
            )
          ],
        ),
      );
    },
  );
}
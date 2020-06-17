import 'dart:async';

import 'package:flutter/material.dart';

class FutureProviderListener<T> {
  // called when fetch has finished
  onFinished(T element) => element;

  // called when an exception was detected
  onException(Exception exception) => exception;

  // called when fetch started and app is waiting for it
  onFetching() => CircularProgressIndicator();
}

class StreamProviderListener<T> extends FutureProviderListener<T> {
  final StreamController<T> _targetController = StreamController();
  final StreamController<T> _exceptionController = StreamController();

  Stream get targetStream => _targetController.stream;
  Stream get exceptionStream => _exceptionController.stream;

  onFinished(T element) {
    print('adding element into stream');
    _targetController.add(element);
  }

  onException(Exception exception) {
    _exceptionController.addError(exception);
  }
}

class DefaultExceptionWidgetListener<T> extends FutureProviderListener<T> {
  onException(Exception exception) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Ooops...algo muito importante deu errado!'),
        Text(
          exception.toString(), 
            style: TextStyle(color: Colors.red),
        )
      ],
    ),
  );
}
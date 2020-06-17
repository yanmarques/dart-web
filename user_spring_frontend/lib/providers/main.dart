import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:user_spring_frontend/listeners/main.dart';

abstract class FutureFunctionProvider<T> with ChangeNotifier {
  bool _isFetching = false;
  bool _hasError = false;

  StreamProviderListener<T> listener = StreamProviderListener<T>();

  bool get isFetching => _isFetching;
  bool get hasError => _hasError;

  // main abstract function to actually start fetching
  Future<T> fetch(T param);

  start(T param) {
    _resetControls();

    // when everything is fine we are done
    // we got something bad, remember it
    // always call notifyListeners after all
    fetch(param)
      .then(listener.onFinished)
      .catchError(listener.onException)
      .whenComplete(_fetchCompleted);

    notifyListeners();
  }

  on({Function(dynamic) target, Function(dynamic) exception}) {
    if (target != null) {
      listener.targetStream.listen(target);
    }

    if (exception != null) {
      listener.exceptionStream.listen(exception);
    }
  }

  void _fetchCompleted() {
    // generally happens when testing and CORS are not allowed from browser,
    // so to avoid a loop where an error happened but was not detected we ensure
    // it is detected
    bool _failedSomehow = ! hasError && isFetching;
    
    // do we detect an error here? we need an exception
    if (_failedSomehow) {
        _hasError = true;
        listener.onException(
          Exception('Received empty data from fetch. Maybe CORS are not allowed.')
        );
    }

    _resetControls();
    notifyListeners();
  }

  _resetControls() {
    _isFetching = false;
    _hasError = false;
  }
}

class RefreshProvider with ChangeNotifier {
  get refresh => notifyListeners;
}
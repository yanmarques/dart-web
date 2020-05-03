import 'dart:async';

import 'package:flutter/material.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {

  final StreamController _controller = StreamController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  _body() {
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Center(
          child: RaisedButton(
            onPressed: _upload,
            child: Text('Upload'),
          ),
        ),
        SizedBox(height: 20),
        Center(
          child: _choosePage()
        )
      ],
    );
  }

  Widget _choosePage() {
    return null;
  }

  void _upload() async {

  }
}

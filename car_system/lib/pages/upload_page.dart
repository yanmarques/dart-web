
import 'package:car_system/app_model.dart';
import 'package:car_system/pages/cars/api.dart';
import 'package:car_system/web/web_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  StreamedFileChooser _chooser;

  @override
  void initState() {
    super.initState();
    _chooser = StreamedFileChooser(_onChooseChange);
  }

  void _onChooseChange(FileState state) async {
    UploadModel model = Provider.of<UploadModel>(context);

    if (state.file == null) {
      model.showProgress();
    } else {
      try {
        String url = await upload(
            state.file,
            Duration(
                seconds: 120
            )
        );

        model.url = url;
      } catch (error, exception) {
        print('error: $error');
        print('error: $exception');
      }
    }
  }

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
            onPressed: _chooser.choose,
            child: Text('Upload'),
          ),
        ),
        SizedBox(height: 20),
        Consumer<UploadModel>(
          builder: (context, uploadModel, child) {
            return Center(
                child: uploadModel.widget
            );
          },
        )
      ],
    );
  }
}

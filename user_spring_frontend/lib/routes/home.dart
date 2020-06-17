import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:user_spring_frontend/entities/User.dart';
import 'package:user_spring_frontend/http/user.dart';
import 'package:user_spring_frontend/listeners/user.dart';
import 'package:user_spring_frontend/providers/main.dart';
import 'package:user_spring_frontend/providers/user.dart';
import 'package:user_spring_frontend/routes/user/save.dart';

class Home extends StatelessWidget {
  final UserListingListener listener = UserListingListener();
  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text("Frontend de usuários consumidora da API em Spring"),
      centerTitle: true,
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: InkWell(
            child: Icon(Icons.refresh),
            onTap: Provider.of<RefreshProvider>(context).refresh
          )
        )
      ],
    ),
    body: Center(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: _buildContent(context)
      )
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () => _addUser(context),
      child: Icon(Icons.add),
    ),
  );

  _addUser(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => Save()));
  }

  Widget _buildContent(context) {
    print('building');
    _initWhenNeeded(context);
    print('initialed');
    if (Provider.of<RemovingUserFutureProvider>(context).isFetching) {
      return Provider.of<RemovingUserFutureProvider>(context).listener.onFetching();
    }
    print('will fetch list');
    return FutureBuilder(
      future: fetchList(),
      builder: _buildUserList
    );
  }

  void _registerRemoveListener(BuildContext context) {
    Provider.of<RemovingUserFutureProvider>(context).on(
      target: (value) {
        Provider.of<RefreshProvider>(context).refresh(); 
      },
      exception: (exception) {
        print('Exception on removing user: $exception');
      }
    );
  }

  _initWhenNeeded(BuildContext context) {
    if (! _isInitialized) {
      _registerRemoveListener(context);
      _isInitialized = true;
    }
  }

  Widget _buildUserList(context, result) {
    if (result.connectionState == ConnectionState.done) {
      if (! result.hasError && result.hasData) {
        return listener.onFinished(result.data);
      }

      return listener.onException(result.error);
    }

    return listener.onFetching();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:user_spring_frontend/entities/User.dart';
import 'package:user_spring_frontend/listeners/main.dart';
import 'package:user_spring_frontend/providers/user.dart';

class UserListingListener extends DefaultExceptionWidgetListener<List<User>> {  
  Widget onFinished(List<User> users) {
    if (users.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Nenhum usuário ainda cadastrado.'),
          Text('Clique no botão lá em baixo para adicionar um novinho...'),
        ],
      );
    }
    
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: SizedBox(
          width: 50,
          child: Container(
            color: Colors.white54,
            padding: EdgeInsets.all(25),
            child: Center(
              child: Row(
                children: [
                  Text(
                    users[index].toString(),
                      style: TextStyle(color: Colors.black)
                  ),
                  // Spacer(flex: 100,),
                  RaisedButton(
                    onPressed: () {
                      _deleteUser(context, users[index]);
                    },
                    child: Icon(Icons.delete)
                  )
                ],
              )
            )
          ),
        )
      )
    );
  }

  _deleteUser(BuildContext context, User user) {
    Provider.of<RemovingUserFutureProvider>(context).start(user);
  }
}
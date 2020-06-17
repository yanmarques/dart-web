import 'package:user_spring_frontend/entities/User.dart';
import 'package:user_spring_frontend/http/user.dart' as http;
import 'package:user_spring_frontend/providers/main.dart';

class SavingUserFutureProvider extends FutureFunctionProvider<User> {
  @override
  Future<User> fetch(User param) async {
    return http.save(param);
  }
}

class RemovingUserFutureProvider extends FutureFunctionProvider<User> {
  @override
  Future<User> fetch(User param) async {
    http.delete(param);
    
    // just return something here.
    return param;
  }
}
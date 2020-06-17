import 'package:user_spring_frontend/entities/City.dart';
import 'package:user_spring_frontend/http/city.dart' as http;
import 'package:user_spring_frontend/providers/main.dart';

class SavingCityFutureProvider extends FutureFunctionProvider<City> {
  @override
  Future<City> fetch(City param) async {
    return http.save(param);
  }
}

import 'package:car_system/pages/cars/car.dart';
import 'package:car_system/pages/cars/api.dart' as api;
import 'package:car_system/pages/cars/detail.dart';
import 'package:car_system/utils/image.dart';
import 'package:flutter/material.dart';

class CarrosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      body: _body(),
    );

  _body() => FutureBuilder(
      future: api.fetchCars(),
      builder: (context, result) {
        if (result.connectionState == ConnectionState.done) {
          if (result.hasError) {
            return _handleApiError(result.error);
          }

          if (result.hasData) {
            return _gridList(result.data);
          }

          return _handleApiError(null);
        }

        return Center(child: CircularProgressIndicator());
      }
    );

  Widget _handleApiError(Exception error) {
    if (error is api.InvalidResponseException) {
      print('ERROR: response status ${error.response.statusCode}');
    }

    return Center(child: Text('Algo deu errado'));
  }

  GridView _gridList(List<Car> cars) => GridView.builder(
        itemCount: cars.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 1.5
        ),
        itemBuilder: (context, index) => _buildCard(cars[index])
    );

  LayoutBuilder _buildCard(Car car) =>  LayoutBuilder(
    builder: (context, constraints) => InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Detail(car))
        );
      },
      child: Card(
          child: Tooltip(
            message: car.name,
            child: ProgressiveImage(car.imageUrl),
          )
      ),
    )
  );
}

import 'dart:io';

import 'package:car_system/pages/cars/car.dart';
import 'package:car_system/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:link/link.dart';

class Detail extends StatelessWidget {
  final Car car;

  Detail(this.car);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(car.name),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          ProgressiveImage(car.imageUrl),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(car.description),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Link(
                      url: car.videoUrl,
                      child: Tooltip(
                        message: 'Baixar Vídeo',
                        child: Icon(Icons.file_download),
                      )
                  ),
                )
              ],
            ),
          )
        ]
      )
  );
}
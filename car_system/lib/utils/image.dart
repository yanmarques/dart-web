import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ProgressiveImage extends StatelessWidget {
  final String url;

  ProgressiveImage(this.url);

  @override
  Widget build(BuildContext context) => Stack(
    children: <Widget>[
      Center(child: CircularProgressIndicator()),
      Center(
        child: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: url
        )
      )
    ],
  );
}
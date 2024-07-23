import 'package:flutter/cupertino.dart';

double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double screenAspectRatio(BuildContext context) {
  return MediaQuery.of(context).size.aspectRatio;
}
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:utl_foot/application/use_cases/foot_map_use_case.dart';
import 'package:utl_foot/resources/app_images.dart';
import 'package:utl_mobile/presentation/bloc/update/update_bloc.dart';
import 'package:utl_mobile/utils/special_canvas.dart';

class FootMapView extends StatefulWidget {
  FootMapView({
    super.key,
    required this.updateBloc,
    required this.mapData,
  });

  UpdateBloc updateBloc;
  List<FootMapSensorUnitDto> mapData;

  @override
  FootMapViewState createState() => FootMapViewState();
}

class FootMapViewState extends State<FootMapView> {
  List<FootMapSensorUnitDto> get mapData => widget.mapData;

  late double width;
  late double height;
  late double aspectRatio;
  late double scaleFootLeft;
  late double scaleFootRight;

  double get footLeftWidth {
    if((AppImage.pngFootLeftAspectRatio + AppImage.pngFootRightAspectRatio) > aspectRatio) {
      return width / 2;
    } else {
      return height * AppImage.pngFootLeftAspectRatio;
    }
  }
  double get footRightWidth {
    if((AppImage.pngFootLeftAspectRatio + AppImage.pngFootRightAspectRatio) > aspectRatio) {
      return width / 2;
    } else {
      return height * AppImage.pngFootRightAspectRatio;
    }
  }
  double get footLeftHeight {
    if((AppImage.pngFootLeftAspectRatio + AppImage.pngFootRightAspectRatio) > aspectRatio) {
      return (width / 2) / AppImage.pngFootLeftAspectRatio;
    } else {
      return height;
    }
  }
  double get footRightHeight {
    if((AppImage.pngFootLeftAspectRatio + AppImage.pngFootRightAspectRatio) > aspectRatio) {
      return (width / 2) / AppImage.pngFootLeftAspectRatio;
    } else {
      return height;
    }
  }

  Image get footLeft {
    return Image.asset(
      AppImage.pngFootLeft,
      width: footLeftWidth,
      height: footLeftHeight,
      fit: BoxFit.cover,
    );
  }
  Image get footRight {
    return Image.asset(
      AppImage.pngFootRight,
      width: footRightWidth,
      height: footRightHeight,
      fit: BoxFit.cover,
    );
  }

  Point<double> calibratePoint(Point<double> point) {
    Point<double> calibratedPoint = Point(point.x * scaleFootLeft, point.y * scaleFootLeft);
    return calibratedPoint;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        width = constraints.minWidth;
        height = constraints.maxHeight;
        aspectRatio = width / height;
        scaleFootLeft = footLeftHeight / AppImage.pngFootLeftHeight;
        scaleFootRight = footRightHeight / AppImage.pngFootRightHeight;
        // debugPrint("AppImage: AspectRatio: ${(AppImage.pngFootLeftAspectRatio + AppImage.pngFootRightAspectRatio)}");
        // debugPrint("FootMapView: LayoutBuilder: $width, $height, $aspectRatio, $scaleFootLeft, $scaleFootRight");
        return Stack(
          children: [
            Row(
              children: [
                footLeft,
                footRight,
              ],
            ),
            CustomPaint(
              size: const Size(300, 400), // Adjust the size as needed
              painter: SensorsPainter(
                state: this,
                mapData: mapData,
              ),
            ),
          ],
        );
      },
    );
  }
}

class SensorsPainter extends CustomPainter {
  List<FootMapSensorUnitDto> mapData;
  FootMapViewState state;
  double get scale => state.scaleFootLeft;

  static const double _TEMPERATURE_CIRCLE_DIAMETER = 20;
  static const double _PRESSURE_CIRCLE_DIAMETER = 10;
  static const double _SHEAR_FORCE_ARROW_MAX_LENGTH = 25;
  static const double _SHEAR_FORCE_ARROW_MIN_LENGTH = 10;
  static const double _SHEAR_FORCE_ARROW_WIDTH = 10;

  static const Color _EDGE_COLOR = Colors.white;

  SensorsPainter({
    required this.state,
    required this.mapData,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (FootMapSensorUnitDto dto in mapData) {
      drawTemperature(canvas, size, dto);
    }
    for (FootMapSensorUnitDto dto in mapData) {
      drawPressure(canvas, size, dto);
    }
    for (FootMapSensorUnitDto dto in mapData) {
      drawShearForce(canvas, size, dto);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  drawTemperature(Canvas canvas, Size size, FootMapSensorUnitDto dto) {
    Paint paint = Paint()
      ..color = dto.temperatureColor
      ..strokeWidth = 2.0;
    Point<double> point = state.calibratePoint(dto.position);
    canvas.drawCircle(
        Offset(point.x, point.y),
        _TEMPERATURE_CIRCLE_DIAMETER * scale,
        paint,
    );
    paint
        ..color = _EDGE_COLOR
        ..style = PaintingStyle.stroke;
    canvas.drawCircle(
      Offset(point.x, point.y),
      _TEMPERATURE_CIRCLE_DIAMETER * scale,
      paint,
    );
  }
  drawPressure(Canvas canvas, Size size, FootMapSensorUnitDto dto) {
    Paint paint = Paint()
      ..color = dto.pressureColor
      ..strokeWidth = 2.0;
    Point<double> point = state.calibratePoint(dto.position);
    canvas.drawCircle(
      Offset(point.x, point.y),
      _PRESSURE_CIRCLE_DIAMETER * scale,
      paint,
    );
    paint
      ..color = _EDGE_COLOR
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(
      Offset(point.x, point.y),
      _PRESSURE_CIRCLE_DIAMETER * scale,
      paint,
    );
  }
  drawShearForce(Canvas canvas, Size size, FootMapSensorUnitDto dto) {
    if(dto.shearForceLength == 0.0) {
      return;
    }
    Paint paint = Paint()
      ..color = dto.shearForceColor
      ..strokeWidth = 2.0;
      // ..style = PaintingStyle.stroke;
    Point<double> point = state.calibratePoint(dto.position);
    SpecialCanvas.drawArrow(
        canvas,
        paint,
        point,
        (_SHEAR_FORCE_ARROW_MAX_LENGTH - _SHEAR_FORCE_ARROW_MIN_LENGTH) * dto.shearForceLength * scale + _SHEAR_FORCE_ARROW_MIN_LENGTH,
        dto.shearForceDirectionRadians,
        width: _SHEAR_FORCE_ARROW_WIDTH,
    );
    paint
      ..color = _EDGE_COLOR
      ..style = PaintingStyle.stroke;
    SpecialCanvas.drawArrow(
      canvas,
      paint,
      point,
      (_SHEAR_FORCE_ARROW_MAX_LENGTH - _SHEAR_FORCE_ARROW_MIN_LENGTH) * dto.shearForceLength * scale + _SHEAR_FORCE_ARROW_MIN_LENGTH,
      dto.shearForceDirectionRadians,
      width: _SHEAR_FORCE_ARROW_WIDTH,
    );
  }
}
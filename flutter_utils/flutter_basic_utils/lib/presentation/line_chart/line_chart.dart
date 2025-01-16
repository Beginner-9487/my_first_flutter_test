import 'dart:math';

import 'package:flutter/material.dart';

class LineChartDatasetController<Dataset> extends ValueNotifier<Dataset> {
  LineChartDatasetController({
    required Dataset dataset,
  }) : super(dataset);
  set dataset(Dataset dataset) => super.value = dataset;
  Dataset get dataset => super.value;
  /// Finds the maximum X value across multiple collections of points.
  ///
  /// - [pointCollections]: A collection of point sets to search.
  /// - Returns: The maximum X value, or null if no points exist.
  static T? findMaxX<T extends num>({
    required Iterable<Iterable<Point<T>>> pointCollections,
  }) {
    final allXCoordinates = pointCollections.expand((points) => points.map((point) => point.x));
    return allXCoordinates.isEmpty ? null : allXCoordinates.reduce((a, b) => a > b ? a : b);
  }
  /// Finds the minimum X value across multiple collections of points.
  ///
  /// - [pointCollections]: A collection of point sets to search.
  /// - Returns: The minimum X value, or null if no points exist.
  static T? findMinX<T extends num>({
    required Iterable<Iterable<Point<T>>> pointCollections,
  }) {
    final allXCoordinates = pointCollections.expand((points) => points.map((point) => point.x));
    return allXCoordinates.isEmpty ? null : allXCoordinates.reduce((a, b) => a < b ? a : b);
  }
  /// Adjusts the X-axis range of each set of points to ensure consistent minimum and maximum X values.
  ///
  /// - [pointCollections]: A collection of point sets to adjust.
  /// - Returns: Adjusted point sets with uniform X-axis ranges.
  static Iterable<Iterable<Point<T>>> alignXRange<T extends num>({
    required Iterable<Iterable<Point<T>>> pointCollections,
  }) {
    final globalMinX = findMinX(pointCollections: pointCollections);
    final globalMaxX = findMaxX(pointCollections: pointCollections);

    if (globalMinX == null || globalMaxX == null) return pointCollections;

    return pointCollections.map((points) => points.isEmpty ? points : [
      if (points.first.x != globalMinX) Point(globalMinX, points.first.y),
      ...points,
      if (points.last.x != globalMaxX) Point(globalMaxX, points.last.y),
    ]);
  }
}

class LineChartTouchState {
  final double? x;
  final LineChartTouchStateType type;
  bool get isTouched => type == LineChartTouchStateType.down || type == LineChartTouchStateType.move;
  LineChartTouchState({
    this.x,
    required this.type,
  });
}

enum LineChartTouchStateType {
  down,
  up,
  move,
}

class LineChart<Dataset> extends StatefulWidget {
  const LineChart({
    super.key,
    required this.builder,
    this.lineChartDatasetController,
    this.onTouchStateChanged,
  });
  final Widget Function(
    BuildContext context,
    void Function(double? x) touchDown,
    void Function(double? x) touchMove,
    void Function(double? x) touchUp,
  ) builder;
  final LineChartDatasetController<Dataset>? lineChartDatasetController;
  final void Function(LineChartTouchState touchState)? onTouchStateChanged;
  @override
  State createState() => LineChartState<Dataset, LineChart<Dataset>>();
}

class LineChartState<Dataset, T extends LineChart<Dataset>> extends State<T> {
  void _setState() {
    setState(() {});
  }
  void Function(double? x) get _touchDown => (x) => widget.onTouchStateChanged?.call(
    LineChartTouchState(
      x: x,
      type: LineChartTouchStateType.down,
    ),
  );
  void Function(double? x) get _touchMove => (x) => widget.onTouchStateChanged?.call(
    LineChartTouchState(
      x: x,
      type: LineChartTouchStateType.move,
    ),
  );
  void Function(double? x) get _touchUp => (x) => widget.onTouchStateChanged?.call(
    LineChartTouchState(
      x: x,
      type: LineChartTouchStateType.up,
    ),
  );
  @mustCallSuper
  @override
  void initState() {
    super.initState();
    widget.lineChartDatasetController?.addListener(_setState);
  }
  @mustCallSuper
  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lineChartDatasetController != widget.lineChartDatasetController) {
      oldWidget.lineChartDatasetController?.removeListener(_setState);
      widget.lineChartDatasetController?.addListener(_setState);
    }
  }
  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      _touchDown,
      _touchMove,
      _touchUp,
    );
  }
  @mustCallSuper
  @override
  void dispose() {
    widget.lineChartDatasetController?.removeListener(_setState);
    super.dispose();
  }
}

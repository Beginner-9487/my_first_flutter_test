import 'package:flutter/material.dart';

class LineChartDashboardListTile<XType, YType> extends StatefulWidget {
  LineChartDashboardListTile(
      {
        super.key,
        this.onTap,
        this.backgroundColor,
        this.labelName,
        this.xLabelName,
        this.yLabelName,
        this.xUnitName,
        this.yUnitName,
        this.x,
        this.yList
      });

  GestureTapCallback? onTap;

  final Color? backgroundColor;
  final String? labelName;

  final String? xLabelName;
  final String? yLabelName;
  final String? xUnitName;
  final String? yUnitName;

  final XType? x;
  final Iterable<YType>? yList;

  @override
  _LineChartDashboardListTileState createState() => _LineChartDashboardListTileState();
}

class _LineChartDashboardListTileState<Tile extends LineChartDashboardListTile<XType, YType>, XType, YType> extends State<Tile> {
  GestureTapCallback? get onTap => widget.onTap;

  Color? get backgroundColor => widget.backgroundColor;
  String get labelName => (widget.labelName == null) ? "" : widget.labelName!;

  String? get xLabelName => widget.xLabelName;
  String? get yLabelName => widget.yLabelName;
  String? get xUnitName => widget.xUnitName;
  String? get yUnitName => widget.yUnitName;

  XType? get x => widget.x;
  Iterable<YType> get yList => (widget.yList == null) ? const Iterable.empty() : widget.yList!;

  Widget? get xLabel {
    if(x == null || xLabelName == null) {
      return null;
    }
    String label = (xLabelName == null) ? "" : "$xLabelName: ";
    String unitName = (xUnitName == null) ? "" : "($xUnitName)";
    return Text("$label$x$unitName");
  }

  List<Widget> get yLabelList {
    if(yList.isEmpty) {
      return [const Text("")];
    }
    String label = (yLabelName == null) ? "" : "$yLabelName: ";
    String unitName = (yUnitName == null) ? "" : "($yUnitName)";
    return yList
        .map((e) => Text("$label$e$unitName"))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: backgroundColor,
      title: Text(labelName),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ...yLabelList,
        ],
      ),
      subtitle: xLabel,
      // contentPadding: const EdgeInsets.all(0.0),
      onTap: onTap,
    );
  }
}

class LineChartDashboardTextTile<XType, YType> extends StatefulWidget {
  LineChartDashboardTextTile(
      {
        super.key,
        this.onTap,
        this.color,
        this.labelName,
        this.xLabelName,
        this.yLabelName,
        this.xUnitName,
        this.yUnitName,
        this.x,
        this.yList
      });

  GestureTapCallback? onTap;

  final Color? color;
  final String? labelName;

  final String? xLabelName;
  final String? yLabelName;
  final String? xUnitName;
  final String? yUnitName;

  final XType? x;
  final Iterable<YType>? yList;

  @override
  _LineChartDashboardTextTileState createState() => _LineChartDashboardTextTileState();
}

class _LineChartDashboardTextTileState<Tile extends LineChartDashboardTextTile<XType, YType>, XType, YType> extends State<Tile> {
  GestureTapCallback? get onTap => widget.onTap;

  Color? get color => widget.color;
  String get labelName => (widget.labelName == null) ? "" : widget.labelName!;

  String? get xLabelName => widget.xLabelName;
  String? get yLabelName => widget.yLabelName;
  String? get xUnitName => widget.xUnitName;
  String? get yUnitName => widget.yUnitName;

  XType? get x => widget.x;
  Iterable<YType> get yList => (widget.yList == null) ? const Iterable.empty() : widget.yList!;

  String get xText {
    String label = (xLabelName == null) ? "" : "$xLabelName: ";
    String value = (x == null) ? "" : "$x";
    String unitName = (xUnitName == null) ? "" : "($xUnitName)";
    return "$label$value$unitName";
  }

  String get yText {
    String label = (yLabelName == null) ? "" : "$yLabelName: ";
    String value = "";
    if(yList.length == 1) {
      value = "${yList.first}";
    } else if(yList.isNotEmpty) {
      value = yList
          .map((e) => "$e")
          .reduce((value, element) => "$value/$element");
    }
      String unitName = (yUnitName == null) ? "" : "($yUnitName)";
    return "$label$value$unitName";
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.rectangle_rounded,
                color: color,
              ),
              Expanded(
                child: Text(labelName),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(xText),
              ),
              Expanded(
                child: Text(yText),
              ),
            ],
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

class LineChartDashboardListTile2<XType, YType> extends LineChartDashboardListTile<XType, YType> {
  LineChartDashboardListTile2(
      {
        super.key,
        super.onTap,
        this.color,
        super.labelName,
        super.xLabelName,
        super.yLabelName,
        super.xUnitName,
        super.yUnitName,
        super.x,
        super.yList
      });

  final Color? color;

  @override
  _LineChartDashboardListTile2State createState() => _LineChartDashboardListTile2State();
}

class _LineChartDashboardListTile2State<Tile extends LineChartDashboardListTile2<XType, YType>, XType, YType> extends _LineChartDashboardListTileState<Tile, XType, YType> {
  Color? get color => widget.color;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.rectangle_rounded,
                color: color,
              ),
              Expanded(
                child: Text(labelName),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: (xLabel == null) ? const Text("") : xLabel!,
              ),
              Expanded(
                child: Column(
                  children: [
                    ...yLabelList,
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
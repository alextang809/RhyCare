/// Package import
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartScreen extends StatefulWidget {
  // const ChartScreen({Key? key}) : super(key: key);

  final Query<Object?> query;
  final String item;

  ChartScreen({required this.query, required this.item});

  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  late TrackballBehavior _trackballBehavior;
  late TooltipBehavior _tooltipBehavior;
  final ZoomMode _zoomModeType = ZoomMode.x;
  final bool _enableAnchor = false;
  List<_ChartData>? chartData;
  bool loading = true;
  bool noData = false;
  double min = 999.0;
  double max = -1.0;

  @override
  void initState() {
    super.initState();
    _trackballBehavior = TrackballBehavior(
        enable: true,
        lineColor: Color.fromRGBO(0, 0, 0, 0.03),
        lineWidth: 8,
        activationMode: ActivationMode.longPress,
        markerSettings: const TrackballMarkerSettings(
            borderWidth: 2,
            height: 6,
            width: 6,
            borderColor: Colors.white,
            color: Colors.purple,
            markerVisibility: TrackballVisibilityMode.visible));
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      format: 'point.x: point.y${getTooltipFormat()}',
      decimalPlaces: 2,
    );

    initial();
  }

  void initial() async {
    chartData = await parse(widget.query);
    setState(() {
      loading = false;
    });
  }

  String getAxisTitle() {
    switch (widget.item) {
      case 'height':
        return 'Height/cm';
      case 'weight':
        return 'Weight/kg';
      case 'bmi':
        return 'BMI';
    }
    return '';
  }

  String getTooltipFormat() {
    switch (widget.item) {
      case 'height':
        return ' cm';
      case 'weight':
        return ' kg';
      case 'bmi':
        return '';
    }
    return '';
  }

  String getTooltipTitle() {
    switch (widget.item) {
      case 'height':
        return 'Height';
      case 'weight':
        return ' Weight';
      case 'bmi':
        return 'BMI';
    }
    return '';
  }

  double getInterval() {
    switch (widget.item) {
      case 'height':
        return 3.0;
      case 'weight':
        return 3.0;
      case 'bmi':
        return 1.0;
    }
    return 1.0;
  }

  /// Get the cartesian chart with default line series
  SfCartesianChart _buildDefaultLineChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      tooltipBehavior: _tooltipBehavior,
      primaryXAxis: DateTimeAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          intervalType: DateTimeIntervalType.days,
          dateFormat: DateFormat.yMd(),
          rangePadding: ChartRangePadding.normal,
          enableAutoIntervalOnZooming: true,
          majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: getAxisTitle()),
        interval: getInterval(),
        minimum: widget.item == 'bmi' ? (max + 3).floor().toDouble() : (max + 5).floor().toDouble(),
        maximum: widget.item == 'bmi' ? (min - 3).ceil().toDouble() : (min - 5).ceil().toDouble(),
        axisLine: const AxisLine(width: 0),
        anchorRangeToVisiblePoints: _enableAnchor,
      ),
      series: _getDefaultLineSeries(widget.query),
      trackballBehavior: _trackballBehavior,
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
        zoomMode: _zoomModeType,
        enablePanning: true,
      ),
    );
  }

  Future<List<_ChartData>> parse(Query<Object?> query) async {
    QuerySnapshot<Object?> querySnapshot =
        await widget.query.get();
    List<QueryDocumentSnapshot<Object?>> list = querySnapshot.docs;
    List<QueryDocumentSnapshot<Object?>> newList = [];

    DateTime dateTime = DateTime.now().add(Duration(days: 100));
    for (QueryDocumentSnapshot<Object?> record in list) {
      if (record[widget.item] != '-') {
        DateTime thisDateTime = record['date_time'].toDate();
        if (!(thisDateTime.day == dateTime.day &&
            thisDateTime.month == dateTime.month &&
            thisDateTime.year == dateTime.year)) {
          dateTime = thisDateTime;
          newList.add(record);
          double height = double.parse(record[widget.item]);
          if (height > max) max = height;
          if (height < min) min = height;
        }
      }
    }
    if (max == -1.0 || min == 999.0) {
      noData = true;
    }
    return newList.map((record) {
      DateTime dateTime = record['date_time'].toDate();
      double height = double.parse(record[widget.item]);
      return _ChartData(
        x: dateTime,
        y: height,
      );
    }).toList();
  }

  /// The method returns line series to chart.
  List<LineSeries<_ChartData, DateTime>> _getDefaultLineSeries(
      Query<Object?> query) {
    return <LineSeries<_ChartData, DateTime>>[
      LineSeries<_ChartData, DateTime>(
        dataSource: chartData!,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.y,
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 6.0,
          width: 6.0,
          borderWidth: 2.0,
          borderColor: Colors.purple,
          color: Colors.white,
        ),
        enableTooltip: true,
        name: getTooltipTitle(),
      ),
    ];
  }

  Widget body() {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.purple,
        ),
      );
    }
    if (noData) {
      return Center(
        child: Container(
          child: Text(
            'No data found. Please ensure that there is at lease one record on your "Records" page.',
            style: TextStyle(fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return _buildDefaultLineChart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: body(),
      ),
    );
  }
}

class _ChartData {
  _ChartData({this.x, this.y});
  DateTime? x;
  double? y;
}

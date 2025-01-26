import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ForecastChart extends StatelessWidget {
  final List<String> hours;
  final List<double> temps;

  const ForecastChart({
    super.key,
    required this.hours,
    required this.temps
  });

  @override
  Widget build(BuildContext context) {
    late List<String> formatted_hours = [];
    late List<double> numerical_time = [];
    DateFormat timeFormat = DateFormat('HH:mm a');

    // Format and prepare data
    for (var hour in hours) {
      DateTime parsed_time = DateTime.parse(hour);
      String formatted_time = DateFormat('hh:mm a').format(parsed_time);
      formatted_hours.add(formatted_time);
      numerical_time.add(parsed_time.hour.toDouble());
    }

    // Create FlSpot for the chart
    List<FlSpot> spots = List.generate(
      12,
          (index) => FlSpot(numerical_time[index], temps[index]),
    );

    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 1.5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                child: Container(
                  height: 600,
                  width: 1000, // Increase width to allow for horizontal scrolling
                  child: LineChart(
                    LineChartData(
                      minY: temps.reduce((a, b) => a < b ? a : b)-1,
                      maxY: temps.reduce((a, b) => a > b ? a : b)+1,
                      minX: numerical_time[0]-1,
                      maxX: numerical_time[11]+1,
                      borderData: FlBorderData(
                        show: false,
                      ),
                      gridData: FlGridData(
                        show: true,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Color.fromRGBO(128, 128, 128, .3),
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: Colors.transparent,
                            strokeWidth: 0,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                          axisNameWidget: Text(
                            "Temperature",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          axisNameSize: 20,
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              return Text(value.toStringAsFixed(1));
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          axisNameWidget: Text(
                            "Hour",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          axisNameSize: 20,
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              if (value >= 0 && value < 12) {
                                return Text(formatted_hours[value.toInt()]);
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          dotData: FlDotData(
                            getDotPainter: (FlSpot spot, double xPercentage, LineChartBarData bar,
                                int index, {double? size}) {
                              return FlDotCirclePainter(
                                color: Colors.blueAccent,
                                strokeWidth: 2,
                                strokeColor: Colors.blueAccent,
                              );
                            },
                          ),
                          color: Colors.green,
                          barWidth: 4,
                          spots: spots,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

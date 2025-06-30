import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/leads_chart_controller.dart';

class LeadsBarChart extends StatelessWidget {
  final List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  final leadsController = Get.put(ChartLeadsController());

  // Define gradient colors for bars
  final List<List<Color>> barGradients = [
    [Colors.blue.shade300, Colors.blue.shade700],
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, right: 16),
      child: Obx(() {
        return BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: _getMaxY(),
            minY: 0,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.blueGrey.shade800.withOpacity(0.8),
                tooltipPadding: const EdgeInsets.all(8),
                tooltipMargin: 8,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: '${rod.toY.round()}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(
                axisNameWidget: const Text(
                  'Leads',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                axisNameSize: 24,
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                axisNameWidget: const Text(
                  'Days of Week',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                axisNameSize: 24,
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= 0 && value.toInt() < days.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          days[value.toInt()],
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      );
                    } else {
                      return const Text('');
                    }
                  },
                  interval: 1,
                ),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: _getInterval(),
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey.shade200,
                  strokeWidth: 1,
                  dashArray: [5, 5],
                );
              },
            ),
            borderData: FlBorderData(
              show: false,
            ),
            barGroups: List.generate(
              leadsController.leadsData.length,
                  (index) => BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: leadsController.leadsData[index].toDouble(),
                    width: 18,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                    gradient: LinearGradient(
                      colors: barGradients[index % barGradients.length],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: _getMaxY(),
                      color: Colors.grey.shade100,
                    ),
                  ),
                ],
                showingTooltipIndicators: [0],
              ),
            ),
          ),
          swapAnimationDuration: const Duration(milliseconds: 800),
          swapAnimationCurve: Curves.easeInOutCubic,
        );
      }),
    );
  }

  // Helper method to calculate maximum Y value with some padding
  double _getMaxY() {
    double maxValue = 0;
    for (int value in leadsController.leadsData) {
      if (value > maxValue) maxValue = value.toDouble();
    }
    return maxValue * 1.2; // Add 20% padding at the top
  }

  // Helper method to calculate appropriate interval for grid lines
  double _getInterval() {
    double maxY = _getMaxY();
    if (maxY <= 20) return 5;
    if (maxY <= 50) return 10;
    if (maxY <= 100) return 20;
    return 50;
  }
}
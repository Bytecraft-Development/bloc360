import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../constants/layout_constants.dart';

class BarChartUsers extends StatelessWidget {
  const BarChartUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        borderData: FlBorderData(
          show: false,
        ),
        groupsSpace: 15,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(
                  color: lightTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                );
                Widget text;
                switch (value.toInt()) {
                  case 2:
                    text = const Text('jan 6', style: style);
                    break;
                  case 4:
                    text = const Text('jan 8', style: style);
                    break;
                  case 6:
                    text = const Text('jan 10', style: style);
                    break;
                  case 8:
                    text = const Text('jan 12', style: style);
                    break;
                  case 10:
                    text = const Text('jan 14', style: style);
                    break;
                  case 12:
                    text = const Text('jan 16', style: style);
                    break;
                  case 14:
                    text = const Text('jan 18', style: style);
                    break;
                  default:
                    text = const Text('', style: style);
                    break;
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: text,
                );
              },
              reservedSize: 42,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(
                  color: lightTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                );
                String text;
                switch (value.toInt()) {
                  case 2:
                    text = '1K';
                    break;
                  case 6:
                    text = '2K';
                    break;
                  case 10:
                    text = '3K';
                    break;
                  case 14:
                    text = '4K';
                    break;
                  default:
                    text = '';
                    break;
                }
                return Text(text, style: style);
              },
              reservedSize: 28,
              interval: 2,
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        barGroups: [
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: 10,
                width: 20,
                color: primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                toY: 3,
                width: 20,
                color: primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          ),
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(
                toY: 12,
                width: 20,
                color: primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          ),
          BarChartGroupData(
            x: 4,
            barRods: [
              BarChartRodData(
                toY: 8,
                width: 20,
                color: primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          ),
          BarChartGroupData(
            x: 5,
            barRods: [
              BarChartRodData(
                toY: 6,
                width: 20,
                color: primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          ),
          BarChartGroupData(
            x: 6,
            barRods: [
              BarChartRodData(
                toY: 10,
                width: 20,
                color: primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          ),
          BarChartGroupData(
            x: 7,
            barRods: [
              BarChartRodData(
                toY: 16,
                width: 20,
                color: primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          ),
          BarChartGroupData(
            x: 8,
            barRods: [
              BarChartRodData(
                toY: 6,
                width: 20,
                color: primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          ),
          BarChartGroupData(
            x: 9,
            barRods: [
              BarChartRodData(
                toY: 4,
                width: 20,
                color: primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          ),
          BarChartGroupData(
            x: 10,
            barRods: [
              BarChartRodData(
                toY: 9,
                width: 20,
                color: primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          ),
          BarChartGroupData(
            x: 11,
            barRods: [
              BarChartRodData(
                toY: 12,
                width: 20,
                color: primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          ),
          BarChartGroupData(
            x: 12,
            barRods: [
              BarChartRodData(
                toY: 2,
                width: 20,
                color: primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          ),
          BarChartGroupData(
            x: 13,
            barRods: [
              BarChartRodData(
                toY: 13,
                width: 20,
                color: primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          ),
          BarChartGroupData(
            x: 14,
            barRods: [
              BarChartRodData(
                toY: 15,
                width: 20,
                color: primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

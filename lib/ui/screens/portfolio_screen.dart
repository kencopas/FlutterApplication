import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dart_frontend/theme/color_manager.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================
          // ACCOUNT SUMMARY CARD
          // =========================
          _DashboardCard(
            context: context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Portfolio Balance",
                  style: TextStyle(
                    fontSize: 13,
                    color: ColorSettings.textSecondary(context),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "\$1,245.80",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: ColorSettings.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      "+\$42.15",
                      style: TextStyle(
                        color: ColorSettings.positive,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "today",
                      style: TextStyle(
                        color: ColorSettings.textSecondary(context),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 140, child: _PortfolioLineChart()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =========================
// SHARED WIDGETS
// =========================

class _DashboardCard extends StatelessWidget {
  final BuildContext context;
  final Widget child;

  const _DashboardCard({required this.context, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorSettings.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorSettings.border(context)),
      ),
      child: child,
    );
  }
}

// =========================
// LINE CHART
// =========================

class _PortfolioLineChart extends StatelessWidget {
  const _PortfolioLineChart();

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(enabled: false),
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 6,
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 3),
              FlSpot(1, 3.5),
              FlSpot(2, 3.2),
              FlSpot(3, 4),
              FlSpot(4, 4.6),
              FlSpot(5, 4.2),
              FlSpot(6, 5),
            ],
            isCurved: true,
            barWidth: 3,
            color: ColorSettings.accent,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: ColorSettings.accent.withValues(alpha: 0.15),
            ),
          ),
        ],
      ),
    );
  }
}

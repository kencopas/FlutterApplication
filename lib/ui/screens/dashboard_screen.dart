import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dart_frontend/theme/color_manager.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================
          // PORTFOLIO SUMMARY
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
                const SizedBox(height: 8),
                Text(
                  "+\$42.15 today",
                  style: TextStyle(
                    color: ColorSettings.positive,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(
                  height: 120,
                  child: _PortfolioLineChart(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // =========================
          // QUICK INSIGHTS
          // =========================
          Row(
            children: [
              _StatTile(
                context: context,
                label: "Open Positions",
                value: "8",
              ),
              const SizedBox(width: 12),
              _StatTile(
                context: context,
                label: "Active Markets",
                value: "21",
              ),
              const SizedBox(width: 12),
              _StatTile(
                context: context,
                label: "Win Rate",
                value: "63%",
              ),
            ],
          ),

          const SizedBox(height: 28),

          // =========================
          // TRENDING MARKETS
          // =========================
          Text(
            "Trending Markets",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ColorSettings.textPrimary(context),
            ),
          ),

          const SizedBox(height: 12),

          _MarketTile(
            context: context,
            title: "Will the Fed cut rates before July?",
            yesPrice: "Yes 62¢",
            noPrice: "No 38¢",
          ),
          _MarketTile(
            context: context,
            title: "Will Bitcoin exceed \$80k in 2025?",
            yesPrice: "Yes 47¢",
            noPrice: "No 53¢",
          ),

          const SizedBox(height: 24),

          // =========================
          // FAVORITES
          // =========================
          Text(
            "Your Favorites",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ColorSettings.textPrimary(context),
            ),
          ),

          const SizedBox(height: 12),

          _MarketTile(
            context: context,
            title: "Will the S&P hit new highs this year?",
            yesPrice: "Yes 55¢",
            noPrice: "No 45¢",
          ),
        ],
      ),
    );
  }
}

//
// =========================
// SHARED WIDGETS
// =========================
//

class _DashboardCard extends StatelessWidget {
  final BuildContext context;
  final Widget child;

  const _DashboardCard({
    required this.context,
    required this.child,
  });

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

class _StatTile extends StatelessWidget {
  final BuildContext context;
  final String label;
  final String value;

  const _StatTile({
    required this.context,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: ColorSettings.surface(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ColorSettings.border(context)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: ColorSettings.textPrimary(context),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: ColorSettings.textSecondary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarketTile extends StatelessWidget {
  final BuildContext context;
  final String title;
  final String yesPrice;
  final String noPrice;

  const _MarketTile({
    required this.context,
    required this.title,
    required this.yesPrice,
    required this.noPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorSettings.surface(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorSettings.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: ColorSettings.textPrimary(context),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(yesPrice, style: TextStyle(color: ColorSettings.positive)),
              const SizedBox(width: 16),
              Text(noPrice, style: TextStyle(color: ColorSettings.negative)),
            ],
          ),
        ],
      ),
    );
  }
}

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
              FlSpot(1, 3.4),
              FlSpot(2, 3.2),
              FlSpot(3, 4.0),
              FlSpot(4, 4.6),
              FlSpot(5, 4.3),
              FlSpot(6, 5.0),
            ],
            isCurved: true,
            barWidth: 3,
            color: ColorSettings.accent,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: ColorSettings.accent.withOpacity(0.15),
            ),
          ),
        ],
      ),
    );
  }
}

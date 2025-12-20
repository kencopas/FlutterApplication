import 'package:flutter/material.dart';
import 'package:dart_frontend/theme/color_manager.dart';

class MarketsScreen extends StatelessWidget {
  const MarketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================
          // HEADER
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
        ],
      ),
    );
  }
}

// =========================
// MARKET TILE
// =========================

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
        border: Border.all(
          color: ColorSettings.border(context),
        ),
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
              Text(
                yesPrice,
                style: TextStyle(color: ColorSettings.positive),
              ),
              const SizedBox(width: 16),
              Text(
                noPrice,
                style: TextStyle(color: ColorSettings.negative),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

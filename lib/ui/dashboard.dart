import 'package:flutter/material.dart';
import 'color_manager.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSettings.background(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              // HEADER
              // =========================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Foresee",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: ColorSettings.textPrimary(context),
                    ),
                  ),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: ColorSettings.surface(context),
                    child: Icon(
                      Icons.person_outline,
                      color: ColorSettings.iconDefault(context),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

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
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // =========================
              // QUICK ACTIONS
              // =========================
              Row(
                children: [
                  _QuickAction(
                    context: context,
                    icon: Icons.trending_up,
                    label: "Markets",
                    onTap: () {
                      Navigator.pushNamed(context, '/markets');
                    },
                  ),
                  const SizedBox(width: 12),
                  _QuickAction(
                    context: context,
                    icon: Icons.account_balance_wallet_outlined,
                    label: "Portfolio",
                    onTap: () {
                      Navigator.pushNamed(context, '/portfolio');
                    },
                  ),
                  const SizedBox(width: 12),
                  _QuickAction(
                    context: context,
                    icon: Icons.notifications_none,
                    label: "Alerts",
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 32),

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
            ],
          ),
        ),
      ),
    );
  }
}

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
        border: Border.all(
          color: ColorSettings.border(context),
        ),
      ),
      child: child,
    );
  }
}

class _QuickAction extends StatelessWidget {
  final BuildContext context;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.context,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: ColorSettings.surface(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ColorSettings.border(context)),
          ),
          child: Column(
            children: [
              Icon(icon, color: ColorSettings.iconActive(context)),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: ColorSettings.textSecondary(context),
                ),
              ),
            ],
          ),
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

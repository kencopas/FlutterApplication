import 'package:dart_frontend/theme/theme_toggle_button.dart';
import 'package:dart_frontend/ui/screens/dashboard_screen.dart';
import 'package:dart_frontend/widgets/profile_icon_button.dart';
import 'package:flutter/material.dart';
import '../theme/color_manager.dart';
import 'screens/markets_screen.dart';
import 'screens/portfolio_screen.dart';
import 'screens/alerts_screen.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentIndex = 0; // Dashboard default

  final List<String> _titles = const [
    "Dashboard",
    "Markets",
    "Portfolio",
    "Alerts",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSettings.background(context),

      body: SafeArea(
        child: Column(
          children: [
            // =========================
            // HEADER (GLOBAL)
            // =========================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _titles[_currentIndex],
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: ColorSettings.textPrimary(context),
                    ),
                  ),
                  Row(
                    children: [
                      const ThemeToggleButton(),
                      const SizedBox(width: 8),
                      ProfileIconButton(
                        onTap: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // =========================
            // ACTIVE SCREEN
            // =========================
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: const [
                  DashboardScreen(),
                  MarketsScreen(),
                  PortfolioScreen(),
                  AlertsScreen(),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        backgroundColor: ColorSettings.surface(context),
        selectedItemColor: ColorSettings.accent,
        unselectedItemColor: ColorSettings.textSecondary(context),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: "Markets",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: "Portfolio",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: "Alerts",
          ),
        ],
      ),
    );
  }
}

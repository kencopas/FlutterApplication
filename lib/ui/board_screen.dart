import 'package:dart_frontend/core/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../services/websocket_service.dart';
import '../ui/monopoly_board.dart';

/// Pretty JSON (same as your HomeScreen)
String prettyJsonString(String? jsonString) {
  if (jsonString == null || jsonString.isEmpty) return "...";

  try {
    final jsonObj = jsonDecode(jsonString);
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(jsonObj);
  } catch (_) {
    return jsonString; // fallback to raw string
  }
}

class BoardScreen extends StatelessWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<WebSocketService>(
          builder: (context, wss, _) {
            if (wss.lastPropertyEvent != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final event = wss.lastPropertyEvent!;
                wss.lastPropertyEvent = null;
                _showPropertyDialog(context, wss, event);
              });
            }

            final gameScreenHeader = Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Refresh Button
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () async {
                      await wss.connect();
                    },
                  ),
                  // Connection Status Text
                  Text(
                    wss.isConnected ? "Connected" : "Disconnected",
                    style: TextStyle(
                      color: wss.isConnected ? Colors.green : Colors.red,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );

            final gameBoard = Flexible(
              fit: FlexFit.tight,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Determine the maximum square size available
                  final size = constraints.biggest.shortestSide;

                  return Center(
                    child: SizedBox(
                      width: size,
                      height: size,
                      child: MonopolyBoard(
                        spaces:
                            context.watch<StateManager>().state?.boardSpaces ??
                            [],
                      ),
                    ),
                  );
                },
              ),
            );

            Widget rollDiceButton(double size) {
              return SizedBox(
                width: size,
                height: size,
                child: FloatingActionButton(
                  heroTag: "btn1",
                  onPressed: () => wss.sendEvent("monopolyMove"),
                  child: Icon(Icons.casino, size: size * 0.5),
                ),
              );
            }

            Widget saveGameButton(double size) {
              return SizedBox(
                width: size,
                height: size,
                child: FloatingActionButton(
                  heroTag: "btn2",
                  onPressed: () => wss.sendEvent("saveSession"),
                  child: Icon(Icons.save, size: size * 0.5),
                ),
              );
            }

            return Stack(
              children: [
                // Monopoly Board + Header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [gameScreenHeader, const Divider(), gameBoard],
                ),

                // Action Buttons
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Row(
                    spacing: 10.0,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      rollDiceButton(80),
                      saveGameButton(80),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ========================================================================
  // PROPERTY DIALOG — Backend-Driven
  // ========================================================================
  void _showPropertyDialog(
    BuildContext context,
    WebSocketService wss,
    Map<String, dynamic> event,
  ) {
    final prop = event["property"] ?? {};
    final name = prop["name"] ?? "Unknown";
    final price = prop["purchase_price"];
    final spaceIndex = event["space_index"];
    final owner = prop["owner"]; // null => unowned

    final isUnowned = owner == null;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("You landed on $name"),
        content: Text(
          isUnowned
              ? "$name is unowned.\nBuy for \$$price?"
              : "$name is owned by $owner.\nYou must pay rent.",
        ),
        actions: [
          if (isUnowned) ...[
            TextButton(
              onPressed: () {
                wss.sendEvent("skipProperty", {"spaceIndex": spaceIndex});
                Navigator.pop(context);
              },
              child: const Text("Skip"),
            ),
            TextButton(
              onPressed: () {
                wss.sendEvent("buyProperty", {"spaceIndex": spaceIndex});
                Navigator.pop(context);
              },
              child: const Text("Buy"),
            ),
          ],

          if (!isUnowned)
            TextButton(
              onPressed: () {
                wss.sendEvent("payRent", {"spaceIndex": spaceIndex});
                Navigator.pop(context);
              },
              child: const Text("Pay Rent"),
            ),
        ],
      ),
    );
  }
}

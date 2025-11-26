import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../services/websocket_service.dart';
import '../core/session_state.dart';
import '../core/session_manager.dart';

String prettyJsonString(String? jsonString) {
  if (jsonString == null || jsonString.isEmpty) return "...";

  try {
    final dynamic jsonObj = jsonDecode(jsonString);
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(jsonObj);
  } catch (e) {
    return jsonString; // Not JSON
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter WSS Client")),
      body: Consumer<WebSocketService>(
        builder: (context, wss, _) {
          // --- Check for landedOnProperty event ---
          if (wss.lastPropertyEvent != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final event = wss.lastPropertyEvent!;
              wss.lastPropertyEvent = null; // Clear it

              _showPropertyDialog(context, wss, event);
            });
          }

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wss.isConnected ? "Connected" : "Disconnected",
                      style: TextStyle(
                        color: wss.isConnected ? Colors.green : Colors.red,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),

                    FutureBuilder<String>(
                      future: SessionManager.instance.userId,
                      builder: (context, snapshot) {
                        return Text(
                          "User ID: ${snapshot.data ?? '...'}",
                          style: const TextStyle(fontSize: 14),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    FutureBuilder<Map<String, dynamic>>(
                      future: SessionManager.instance.userData,
                      builder: (context, snapshot) {
                        return SelectableText(
                          "User Data:\n${prettyJsonString(jsonEncode(snapshot.data))}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'monospace',
                          ),
                        );
                      },
                    ),

                    Consumer<SessionState>(
                      builder: (context, session, _) {
                        return SelectableText(
                          "Session State:\n${prettyJsonString(jsonEncode(session.state))}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'monospace',
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const Divider(),

              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await wss.sendEvent("ping");
                      },
                      child: const Text("Ping"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await wss.sendEvent("monopolyMove");
                      },
                      child: const Text("Monopoly Move"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await wss.sendEvent("saveSession");
                      },
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// ------------------------------------------------------------
  /// PROPERTY PURCHASE DIALOG
  /// ------------------------------------------------------------
  void _showPropertyDialog(
    BuildContext context,
    WebSocketService wss,
    Map<String, dynamic> data,
  ) {
    final propData = data["property"] ?? {};

    final name = propData["name"] ?? "Unknown Property";
    final price = propData["purchase_price"];
    final spaceIndex = data["space_index"];
    final owner = null;
    // final mortgage = propData["mortgage_value"];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("You landed on $name"),
        content: Text(
          owner == null
              ? "$name is unowned.\nWould you like to buy it for \$$price?"
              : "$name is owned by $owner.\nYou must pay rent.",
        ),
        actions: [
          // Unowned property → buy or skip
          if (owner == null) ...[
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

          // Owned property → pay rent
          if (owner != null)
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../services/websocket_service.dart';
import '../core/session_state.dart';
import '../core/session_manager.dart';
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

List<BoardSpaceData> _convertStateToBoard(Map<String, dynamic> session) {
  List<BoardSpaceData> boardSpaces = [];
  for (var i = 0; i < 40; i++) {
    boardSpaces.add(
      BoardSpaceData(index: i, name: "test space $i", type: "property"),
    );
  }

  return boardSpaces;
}

class BoardScreen extends StatelessWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Monopoly Board")),
      body: Consumer<WebSocketService>(
        builder: (context, wss, _) {
          // ------------------------------------------------------------
          // 1. Handle "landedOnProperty" event sent from backend
          // ------------------------------------------------------------
          if (wss.lastPropertyEvent != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final event = wss.lastPropertyEvent!;
              wss.lastPropertyEvent = null; // clear event after handling

              _showPropertyDialog(context, wss, event);
            });
          }

          // ------------------------------------------------------------
          // 2. UI Display (no game logic here)
          // ------------------------------------------------------------
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP PANEL (status)
              // Padding(
              //   padding: const EdgeInsets.all(12),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         wss.isConnected ? "Connected" : "Disconnected",
              //         style: TextStyle(
              //           color: wss.isConnected ? Colors.green : Colors.red,
              //           fontSize: 18,
              //         ),
              //       ),

              //       const SizedBox(height: 8),

              //       // Show user ID
              //       FutureBuilder<String>(
              //         future: SessionManager.instance.userId,
              //         builder: (context, snapshot) {
              //           return Text(
              //             "User ID: ${snapshot.data ?? '...'}",
              //             style: const TextStyle(fontSize: 14),
              //           );
              //         },
              //       ),

              //       const SizedBox(height: 12),

              //       // Current Session State (fully backend-driven)
              //       Consumer<SessionState>(
              //         builder: (context, session, _) {
              //           return SelectableText(
              //             "Session State:\n${prettyJsonString(jsonEncode(session.state))}",
              //             style: const TextStyle(
              //               fontSize: 14,
              //               fontFamily: 'monospace',
              //             ),
              //           );
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              const Divider(),

              // Dynamically rendered board
              Expanded(
                child: Consumer<SessionState>(
                  builder: (context, session, _) {
                    final boardData = _convertStateToBoard(session.state);
                    return MonopolyBoard(spaces: boardData);
                  },
                ),
              ),

              const Divider(),

              // ------------------------------------------------------------
              // 4. USER ACTIONS (all sent to backend)
              // ------------------------------------------------------------
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => wss.sendEvent("monopolyMove"),
                      child: const Text("Roll / Move"),
                    ),
                    ElevatedButton(
                      onPressed: () => wss.sendEvent("saveSession"),
                      child: const Text("Save Game"),
                    ),
                    ElevatedButton(
                      onPressed: () => wss.sendEvent("loadSession"),
                      child: const Text("Load Game"),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../services/websocket_service.dart';
import '../core/session_state.dart';
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

List<BoardSpaceData> _convertStateToBoard(Map<String, dynamic> sessionState) {
  List<BoardSpaceData> boardSpaces = [];
  for (Map<String, dynamic> space in (sessionState["board_spaces"] ?? [])) {
    boardSpaces.add(
      BoardSpaceData(
        name: space["name"] ?? "Unknown",
        spaceType: space["space_type"] ?? "unknown",
        spaceId: space["space_id"] ?? "unknown",
        spaceIndex: space["space_index"] ?? 0,
        visualProperties: VisualProperties(
          color: space["visual_properties"]?["color"],
          icon: space["visual_properties"]?["icon"],
          description: space["visual_properties"]?["description"],
          occupiedBy: space["visual_properties"]?["occupied_by"],
        ),
      ),
    );
  }
  return boardSpaces;
}

class BoardScreen extends StatelessWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WebSocketService>(
        builder: (context, wss, _) {
          if (wss.lastPropertyEvent != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final event = wss.lastPropertyEvent!;
              wss.lastPropertyEvent = null;
              _showPropertyDialog(context, wss, event);
            });
          }

          return Stack(
            children: [
              // ============================================================
              // MAIN MONOPOLY BOARD + HEADER
              // ============================================================
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.refresh),
                          onPressed: () async {
                            await wss.connect();
                          },
                        ),
                        Text(
                          wss.isConnected ? "Connected" : "Disconnected",
                          style: TextStyle(
                            color: wss.isConnected ? Colors.green : Colors.red,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(),

                  Expanded(
                    child: Consumer<SessionState>(
                      builder: (context, session, _) {
                        final boardData = _convertStateToBoard(session.state);
                        return Center(child: MonopolyBoard(spaces: boardData));
                      },
                    ),
                  ),
                ],
              ),

              // ============================================================
              // FLOATING BUTTON OVERLAY (BOTTOM RIGHT)
              // ============================================================
              Positioned(
                bottom: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      heroTag: "btn1",
                      onPressed: () => wss.sendEvent("monopolyMove"),
                      child: const Icon(Icons.casino),
                    ),
                    const SizedBox(height: 12),
                    FloatingActionButton(
                      heroTag: "btn2",
                      onPressed: () => wss.sendEvent("saveSession"),
                      child: const Icon(Icons.save),
                    ),
                    const SizedBox(height: 12),
                    FloatingActionButton(
                      heroTag: "btn3",
                      onPressed: () => wss.sendEvent("loadSession"),
                      child: const Icon(Icons.download),
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

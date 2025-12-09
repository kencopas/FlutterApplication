import 'package:dart_frontend/core/session_manager.dart';
import 'package:dart_frontend/core/state_manager.dart';
import 'package:dart_frontend/models/board_space_data.dart';
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

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  String? userId;  // stored once here

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final id = await SessionManager.instance.userId;  // <-- async getter

    setState(() {
      userId = id;   // store it
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      // still loading user ID
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Consumer<WebSocketService>(
          builder: (context, wss, _) {
            final gameState = context.watch<StateManager>().state;
            final userState = gameState?.playerStates[userId];

            // Trigger dialogs using side-effects OUTSIDE build
            _scheduleDialogIfNeeded(context, wss);

            // Header
            final header = Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  _RefreshButton(wss: wss),
                  _ConnectionStatusText(isConnected: wss.isConnected),
                ],
              ),
            );

            // Owned properties names
            final ownedPropertyNames = [
              for (var propId in userState?.ownedProperties ?? [])
                gameState?.gameBoard
                    .firstWhere((space) => space.spaceId == propId)
                    .name,
            ].join(", ");

            // Game State Info
            final gameStateInfo = Padding(
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                child: Text(
                  "Money: \$${userState?.moneyDollars}\n"
                  "Position: ${userState?.position}\n"
                  "Current Space ID: ${userState?.currentSpaceId}\n"
                  "Owned Properties: $ownedPropertyNames\n\n",
                  style: const TextStyle(fontFamily: 'Courier'),
                ),
              ),
            );

            // Game board
            final gameBoard = LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.biggest.shortestSide;

                return Center(
                  child: SizedBox(
                    width: size,
                    height: size,
                    child: userState != null
                    ? MonopolyBoard(userState: userState, spaces: gameState?.gameBoard ?? [])
                    : Placeholder(),
                  ),
                );
              },
            );

            // Portrait Action bar overlay
            final portraitActionBar = Row(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                _RollDiceButton(size: 80),
                _SaveGameButton(size: 80),
                _StartOnlineGameButton(size: 80),
              ],
            );

            final landscapeActionBar = Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                _RollDiceButton(size: 80),
                _SaveGameButton(size: 80),
                _StartOnlineGameButton(size: 80),
              ],
            );

            Widget _responsiveBoard(BuildContext context) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final boardSize = constraints.biggest.shortestSide;

                  return SizedBox(
                    width: boardSize,
                    height: boardSize,
                    child: gameBoard,
                  );
                },
              );
            }

            Widget _buildLandscapeLayout(BuildContext context) {
              return Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [header, const Divider(), gameStateInfo],
                        ),
                      ),

                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: _responsiveBoard(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(bottom: 20, right: 20, child: landscapeActionBar),
                ],
              );
            }

            Widget _buildPortraitLayout(BuildContext context) {
              return Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      header,
                      const Divider(),
                      gameStateInfo,

                      Padding(
                        padding: const EdgeInsets.only(bottom: 80),
                        child: _responsiveBoard(context),
                      ),
                    ],
                  ),
                  Positioned(bottom: 20, right: 20, child: portraitActionBar),
                ],
              );
            }

            return OrientationBuilder(
              builder: (context, orientation) {
                final isPortrait = orientation == Orientation.portrait;

                return SafeArea(
                  child: isPortrait
                      ? _buildPortraitLayout(context)
                      : _buildLandscapeLayout(context),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _RefreshButton extends StatelessWidget {
  final WebSocketService wss;

  const _RefreshButton({required this.wss});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: () async {
        await wss.connect();
      },
    );
  }
}

class _ConnectionStatusText extends StatelessWidget {
  final bool isConnected;

  const _ConnectionStatusText({required this.isConnected});

  @override
  Widget build(BuildContext context) {
    return Text(
      isConnected ? "Connected" : "Disconnected",
      style: TextStyle(
        color: isConnected ? Colors.green : Colors.red,
        fontSize: 18,
      ),
    );
  }
}

class _RollDiceButton extends StatelessWidget {
  final double size;

  const _RollDiceButton({this.size = 80});

  @override
  Widget build(BuildContext context) {
    final wss = context.read<WebSocketService>();

    return SizedBox(
      width: size,
      height: size,
      child: FloatingActionButton(
        heroTag: "roll_dice_btn",
        onPressed: () => wss.sendEvent("monopolyMove"),
        child: Icon(Icons.casino, size: size * 0.5),
      ),
    );
  }
}

class _SaveGameButton extends StatelessWidget {
  final double size;

  const _SaveGameButton({this.size = 80});

  @override
  Widget build(BuildContext context) {
    final wss = context.read<WebSocketService>();

    return SizedBox(
      width: size,
      height: size,
      child: FloatingActionButton(
        heroTag: "save_game_btn",
        onPressed: () => wss.sendEvent("saveSession"),
        child: Icon(Icons.save, size: size * 0.5),
      ),
    );
  }
}

class _StartOnlineGameButton extends StatelessWidget {
  final double size;

  const _StartOnlineGameButton({this.size = 80});

  @override
  Widget build(BuildContext context) {
    final wss = context.read<WebSocketService>();

    return SizedBox(
      width: size,
      height: size,
      child: FloatingActionButton(
        heroTag: "online_game_btn",
        onPressed: () => _showOnlineGameDialog(context, wss),
        child: Icon(Icons.connect_without_contact, size: size * 0.5),
      ),
    );
  }
}

class _OnlineGameDialog extends StatefulWidget {
  @override
  State<_OnlineGameDialog> createState() => _OnlineGameDialogState();
}

class _OnlineGameDialogState extends State<_OnlineGameDialog> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Start/Join Online Game"),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(labelText: "Online Game ID"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // return null
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, controller.text.trim()); // return text
          },
          child: const Text("Go"),
        ),
      ],
    );
  }
}

void _showOnlineGameDialog(BuildContext context, WebSocketService wss) async {
  // Open dialog and wait for result
  final result = await showDialog<String>(
    context: context,
    builder: (_) => _OnlineGameDialog(),
  );

  // If user pressed cancel, result is null
  if (result != null && result.isNotEmpty) {
    SessionManager.instance.gameId = result;
    context.read<WebSocketService>().sendEvent("onlineGame", {
      "onlineGameId": result,
    });
  }
}

void _showEventDialog(
  BuildContext context,
  WebSocketService wss,
  Map<String, dynamic> event,
) {
  final String promptType = event["promptType"];
  final Map<String, dynamic>? space = event["space"];
  final String message = event["message"] ?? "You landed on a space.";
  final int? rentAmount = event["rentAmount"];
  final String? action = event["action"];

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text("You landed on ${space?["name"] ?? "a space."}"),
      content: Text(message),
      actions: [
        // Alert
        if (promptType == "alert") ...[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ]
        // Ask to purchase property
        else if (promptType == "askPurchaseProperty") ...[
          TextButton(
            onPressed: () {
              wss.sendEvent("skipProperty");
              Navigator.pop(context);
            },
            child: const Text("Skip"),
          ),
          TextButton(
            onPressed: () {
              wss.sendEvent("buyProperty");
              Navigator.pop(context);
            },
            child: const Text("Buy"),
          ),
        ]
        // Pay rent
        else if (promptType == "payRent" && rentAmount != null) ...[
          TextButton(
            onPressed: () {
              wss.sendEvent("payRentConfirmation");
              Navigator.pop(context);
            },
            child: const Text("Pay Rent"),
          ),
        ]
        // Action space
        else if (promptType == "actionSpace") ...[
          TextButton(
            onPressed: () {
              wss.sendEvent("performAction", {"action": action});
              Navigator.pop(context);
            },
            child: const Text("Perform Action"),
          ),
        ],
      ],
    ),
  );
}

void _scheduleDialogIfNeeded(BuildContext context, WebSocketService wss) {
  final event = wss.lastPromptEvent;
  if (event == null) {
    return;
  }
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final event = wss.lastPromptEvent!;
    wss.lastPromptEvent = null;
    _showEventDialog(context, wss, event);
  });
}

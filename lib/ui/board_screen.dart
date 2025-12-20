import 'package:dart_frontend/core/session_manager.dart';
import 'package:dart_frontend/core/sound_effects.dart';
import 'package:dart_frontend/core/state_manager.dart';
import 'package:dart_frontend/models/board_space_data.dart';
import 'package:dart_frontend/models/user_state.dart';
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
  String? userId; // stored once here

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final id = await SessionManager.instance.userId; // <-- async getter

    setState(() {
      userId = id; // store it
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      // still loading user ID
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      body: SafeArea(
        child: Consumer<WebSocketService>(
          builder: (context, wss, _) {
            final gameState = context.watch<StateManager>().state;
            final userState = gameState?.playerStates[userId];
            final currentUserId = SessionManager.instance.currentUserId;

            // Trigger dialogs using side-effects OUTSIDE build
            _scheduleDialogIfNeeded(context, wss);

            // Header
            final header = Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Spacer(),
                  _RefreshButton(wss: wss),
                  _ConnectionStatusText(isConnected: wss.isConnected),
                ],
              ),
            );

            final List<Widget> userStates = [
              // 1️⃣ Current user first
              if (userState != null) _playerStateItem(userState),

              // 2️⃣ All other players
              if (gameState != null)
                ...gameState.playerStates.entries
                    .where((entry) => entry.key != currentUserId)
                    .map((entry) => _playerStateItem(entry.value)),
            ];

            // Game board
            final gameBoard = LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.biggest.shortestSide;

                return Center(
                  child: SizedBox(
                    width: size,
                    height: size,
                    child: userState != null
                        ? MonopolyBoard(
                            userState: userState,
                            spaces: gameState?.gameBoard ?? [],
                          )
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
                          children: [
                            header,
                            const Divider(),
                            SizedBox(
                              height: 400,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: userStates,
                              ),
                            ),
                          ],
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
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: userStates,
                        ),
                      ),

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
    final wss = context.watch<WebSocketService>();
    final enabled = wss.isPlayersTurn;

    return SizedBox(
      width: size,
      height: size,
      child: FloatingActionButton(
        heroTag: "roll_dice_btn",
        onPressed: enabled
            ? () async {
                await wss.sendEvent("monopolyMove");
                await SoundEffects.playDiceRoll();
              }
            : null,
        backgroundColor: enabled
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.primaryContainer.withAlpha(140),
        foregroundColor: enabled ? Colors.white : Colors.white.withAlpha(140),
        elevation: enabled ? 6 : 0,
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

Widget _playerStateItem(UserState state) {
  return Expanded(
    child: ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 100, // ← your minimum height
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          "Money: \$${state.moneyDollars}",
          softWrap: true,
          style: const TextStyle(fontFamily: 'Courier'),
        ),
      ),
    ),
  );
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
              SoundEffects.playMoneySound();
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

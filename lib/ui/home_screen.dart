import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/websocket_service.dart';
import '../core/wsp_event.dart';

import 'message_bubble.dart';
import '../core/session_state.dart';
import '../core/session_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter WSS Client")),
      body: Consumer<WebSocketService>(
        builder: (context, wss, _) {
          return Column(
            children: [
              // Insert the new extended status panel here
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
                    const SizedBox(height: 12),
                    FutureBuilder<String>(
                      future: SessionManager.instance.userId,
                      builder: (context, snapshot) {
                        return Text(
                          "User ID: ${snapshot.data ?? '...'}",
                          style: const TextStyle(fontSize: 14),
                        );
                      },
                    ),
                    FutureBuilder<Map<String, dynamic>>(
                      future: SessionManager.instance.userData,
                      builder: (context, snapshot) {
                        return Text(
                          "User Data: ${snapshot.data ?? '...'}",
                          style: const TextStyle(fontSize: 14),
                        );
                      },
                    ),
                    Consumer<SessionState>(
                      builder: (context, session, _) {
                        return Text(
                          "Session State: ${session.state}",
                          style: const TextStyle(fontSize: 14),
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
                      onPressed: () {
                        wss.send(WSPEvent(event: "ping", data: {}));
                      },
                      child: const Text("Ping"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        wss.send(
                          WSPEvent(
                            event: "statusUpdate",
                            data: {"timestamp": DateTime.now().toString()},
                          ),
                        );
                      },
                      child: const Text("Status Update"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final sessionState = Provider.of<SessionState>(
                          context,
                          listen: false,
                        );

                        final userId = await SessionManager.instance.userId;
                        final sessionId =
                            await SessionManager.instance.sessionId;

                        wss.send(
                          WSPEvent(
                            event: "saveSession",
                            data: {
                              "userId": userId,
                              "sessionId": sessionId,
                              "state": sessionState.state,
                            },
                          ),
                        );
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
}

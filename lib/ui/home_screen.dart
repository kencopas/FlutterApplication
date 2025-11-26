import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/websocket_service.dart';

import '../core/session_state.dart';
import '../core/session_manager.dart';

import 'dart:convert';

String prettyJsonString(String? jsonString) {
  if (jsonString == null || jsonString.isEmpty) return "...";

  try {
    final dynamic jsonObj = jsonDecode(jsonString);
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(jsonObj);
  } catch (e) {
    // Not JSON? Just return it.
    return jsonString;
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
                    FutureBuilder<String>(
                      future: SessionManager.instance.userId,
                      builder: (context, snapshot) {
                        return SelectableText(
                          "User Data:\n${prettyJsonString(snapshot.data)}",
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
}

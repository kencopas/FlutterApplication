import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'services/websocket_service.dart';
import 'core/session_state.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SessionState()),

        ChangeNotifierProvider<WebSocketService>(
          create: (context) {
            final sessionState = Provider.of<SessionState>(
              context,
              listen: false,
            );
            final wss = WebSocketService("ws://localhost:8080", sessionState);

            // Let SessionState register its handlers
            sessionState.registerHandlers(wss);

            wss.on("landedOnProperty", (data) {
              // We can't use context here (we're outside widget tree),
              // so instead store the event and notify listeners:
              wss.lastPropertyEvent = data;
              wss.notifyListeners();
            });

            wss.connect();
            return wss;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

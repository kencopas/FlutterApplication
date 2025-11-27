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

        ChangeNotifierProvider(
          create: (context) {
            final sessionState = context.read<SessionState>();
            final wss = WebSocketService("ws://localhost:8080", sessionState);

            // Initialize AFTER the widget tree is mounted
            Future.microtask(() {
              wss.init();
            });

            return wss;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

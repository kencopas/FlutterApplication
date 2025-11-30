import 'package:dart_frontend/core/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'services/websocket_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StateManager()),

        ChangeNotifierProvider(
          create: (context) {
            final sessionState = context.read<StateManager>();
            final wss = WebSocketService("wss://seem-personal-muscles-his.trycloudflare.com", sessionState);

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

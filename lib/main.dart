import 'package:dart_frontend/core/session_manager.dart';
import 'package:dart_frontend/core/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'services/websocket_service.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StateManager()),

        ChangeNotifierProvider(
          create: (context) {
            final sessionState = context.read<StateManager>();
            final wss = WebSocketService(
              "wss://api.kencopasdev.work",
              sessionState,
            );

            // Initialize AFTER the widget tree is mounted
            Future.microtask(() async {
              wss.init();
              await SessionManager.instance.userId;
            });

            return wss;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

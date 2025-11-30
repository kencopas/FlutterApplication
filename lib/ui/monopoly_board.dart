import 'package:flutter/material.dart';
import '../models/board_space_data.dart';

/// Widget for rendering a single Monopoly tile.
class BoardSpaceWidget extends StatelessWidget {
  final BoardSpaceData space;

  const BoardSpaceWidget({super.key, required this.space});

  @override
  Widget build(BuildContext context) {
    Color background;
    final visualProps = space.visualProperties;

    if (visualProps.color != null) {
      background = Color(int.parse(visualProps.color!)); // e.g. "0xFFAA0000"
    } else if (visualProps.occupiedBy == "Player") {
      background = Colors.red;
    } else if (visualProps.occupiedBy == "Opponent") {
      background = Colors.blue;
    } else {
      background = Colors.indigo;
    }

    final box = Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1),
        color: background,
      ),
      padding: const EdgeInsets.all(3),
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          space.name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );

    // Corners must be perfect squares.
    if (space.isCorner) {
      return AspectRatio(aspectRatio: 1, child: box);
    }

    return box;
  }
}

/// The full Monopoly board layout widget.
class MonopolyBoard extends StatelessWidget {
  final List<BoardSpaceData> spaces;

  const MonopolyBoard({super.key, required this.spaces});

  @override
  Widget build(BuildContext context) {
    if (spaces.length != 40) {
      return const Center(child: Text("Board requires exactly 40 spaces"));
    }

    // Ensure proper ordering by index.
    final sorted = [...spaces]
      ..sort((a, b) => a.spaceIndex.compareTo(b.spaceIndex));

    // Split board into edges.
    final bottom = sorted.sublist(0, 11).reversed.toList();
    final left = sorted.sublist(11, 20).reversed.toList();
    final top = sorted.sublist(20, 31);
    final right = sorted.sublist(31, 40);

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(border: Border.all(width: 3)),
        child: Column(
          children: [
            // ---------------- TOP ROW: 11 tiles ----------------
            ConstrainedBox(
              constraints: const BoxConstraints.tightFor(height: 120),
              child: Row(
                children: [
                  // GO (index 0)
                  SizedBox(width: 120, child: BoardSpaceWidget(space: top[0])),

                  // Middle 9 top tiles: indexes 1..9
                  ...top
                      .sublist(1, 10)
                      .map((s) => Expanded(child: BoardSpaceWidget(space: s))),

                  // Jail / Just Visiting (index 10)
                  SizedBox(width: 120, child: BoardSpaceWidget(space: top[10])),
                ],
              ),
            ),

            // ---------------- MIDDLE SECTION ----------------
            Expanded(
              child: Row(
                children: [
                  // -------- LEFT COLUMN: 9 tiles --------
                  ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(width: 120),
                    child: Column(
                      children: [
                        // Middle 7 left tiles: indexes 31..37
                        ...left
                            .sublist(0, 9)
                            .map(
                              (s) =>
                                  Expanded(child: BoardSpaceWidget(space: s)),
                            ),
                      ],
                    ),
                  ),

                  // -------- CENTER AREA --------
                  Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "MONOPOLY",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),

                  // -------- RIGHT COLUMN: 9 tiles --------
                  ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(width: 120),
                    child: Column(
                      children: [
                        // Middle 7 right tiles: indexes 12..18
                        ...right
                            .sublist(0, 9)
                            .map(
                              (s) =>
                                  Expanded(child: BoardSpaceWidget(space: s)),
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ---------------- BOTTOM ROW: 11 tiles ----------------
            ConstrainedBox(
              constraints: const BoxConstraints.tightFor(height: 120),
              child: Row(
                children: [
                  // FREE PARKING (index 20)
                  SizedBox(
                    width: 120,
                    child: BoardSpaceWidget(space: bottom.first),
                  ),

                  // Middle 9 bottom tiles: indexes 21..29
                  ...bottom
                      .sublist(1, 10)
                      .map((s) => Expanded(child: BoardSpaceWidget(space: s))),

                  // GO TO JAIL (index 30)
                  SizedBox(
                    width: 120,
                    child: BoardSpaceWidget(space: bottom.last),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

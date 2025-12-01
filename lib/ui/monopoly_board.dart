import 'package:flutter/material.dart';
import '../models/board_space_data.dart';
import 'dart:math';

/// Widget for rendering an individual Monopoly tile.
class BoardSpaceWidget extends StatelessWidget {
  final BoardSpaceData space;
  final double cellSize;

  const BoardSpaceWidget({
    super.key,
    required this.space,
    required this.cellSize,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    final vp = space.visualProperties;

    if (vp.color != null) {
      bg = Color(int.parse(vp.color!));
    } else if (vp.occupiedBy == "Player") {
      bg = Colors.red;
    } else if (vp.occupiedBy == "Opponent") {
      bg = Colors.blue;
    } else {
      bg = Colors.indigo;
    }

    return InkWell(
      onTap: () {
        _showTileInfo(context, space, cellSize, bg);
      },
      child: SizedBox(
        width: 200,
        height: 200,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1),
            color: bg,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                space.name,
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontSize: space.isCorner ? cellSize * 0.3 : cellSize * 0.15,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MonopolyBoard extends StatelessWidget {
  final List<BoardSpaceData> spaces;

  const MonopolyBoard({super.key, required this.spaces});

  @override
  Widget build(BuildContext context) {
    if (spaces.length != 40) {
      return const Center(child: Text("Board requires exactly 40 spaces"));
    }

    final sorted = [...spaces]
      ..sort((a, b) => a.spaceIndex.compareTo(b.spaceIndex));

    final bottom = sorted.sublist(0, 11).reversed.toList();
    final left = sorted.sublist(11, 20).reversed.toList();
    final top = sorted.sublist(20, 31);
    final right = sorted.sublist(31, 40);

    return LayoutBuilder(
      builder: (context, constraints) {
        final boardSize = min(constraints.maxWidth, constraints.maxHeight);
        final cellSize = boardSize / 13;

        // Top Row | Free Parking -> Go To Jail
        final topRowSpaces = Row(
          children: [
            _CornerTile(s: top[0], cellSize: cellSize),
            for (var topSpaceData in top.sublist(1, 10)) ...[
              _RowTile(s: topSpaceData, cellSize: cellSize),
            ],
            _CornerTile(s: top[10], cellSize: cellSize),
          ],
        );

        // Bottom Row | Go -> Jail
        final bottomRowSpaces = Row(
          children: [
            _CornerTile(s: bottom[0], cellSize: cellSize),
            for (var bottomSpaceData in bottom.sublist(1, 10)) ...[
              _RowTile(s: bottomSpaceData, cellSize: cellSize),
            ],
            _CornerTile(s: bottom[10], cellSize: cellSize),
          ],
        );

        // Left Column | St. Charles Place -> New York Avenue
        final leftColumnSpaces = Column(
          children: [
            for (var leftSpaceData in left) ...[
              _ColumnTile(s: leftSpaceData, cellSize: cellSize),
            ],
          ],
        );

        // Right Column | Pacific Avenue -> Boardwalk
        final rightColumnSpaces = Column(
          children: [
            for (var rightSpaceData in right) ...[
              _ColumnTile(s: rightSpaceData, cellSize: cellSize),
            ],
          ],
        );

        // Middle Section | Left Row, Middle Area, Right Row
        final middleSection = Row(
          children: [
            leftColumnSpaces,
            _MiddleArea(cellSize: cellSize),
            rightColumnSpaces,
          ],
        );

        // Game Board Layout | Top Row, Middle Section, Bottom Row
        return Column(children: [topRowSpaces, middleSection, bottomRowSpaces]);
      },
    );
  }
}

void _showTileInfo(
  BuildContext context,
  BoardSpaceData space,
  double cellSize,
  Color bg,
) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(space.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Price: \$${100}"),
            Text("Rent: \$${50}"),
            // Add more fields here
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}

class _Tile extends StatelessWidget {
  final BoxConstraints constraints;
  final BoardSpaceData s;
  final double cellSize;

  const _Tile({
    required this.constraints,
    required this.s,
    required this.cellSize,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: constraints,
      child: BoardSpaceWidget(space: s, cellSize: cellSize),
    );
  }
}

class _RowTile extends StatelessWidget {
  final BoardSpaceData s;
  final double cellSize;

  const _RowTile({required this.s, required this.cellSize});

  @override
  Widget build(BuildContext context) {
    return _Tile(
      constraints: BoxConstraints(maxWidth: cellSize, maxHeight: cellSize * 2),
      s: s,
      cellSize: cellSize,
    );
  }
}

class _ColumnTile extends StatelessWidget {
  final BoardSpaceData s;
  final double cellSize;

  const _ColumnTile({required this.s, required this.cellSize});

  @override
  Widget build(BuildContext context) {
    return _Tile(
      constraints: BoxConstraints(maxWidth: cellSize * 2, maxHeight: cellSize),
      s: s,
      cellSize: cellSize,
    );
  }
}

class _CornerTile extends StatelessWidget {
  final BoardSpaceData s;
  final double cellSize;

  const _CornerTile({required this.s, required this.cellSize});

  @override
  Widget build(BuildContext context) {
    return _Tile(
      constraints: BoxConstraints(
        maxWidth: cellSize * 2,
        maxHeight: cellSize * 2,
      ),
      s: s,
      cellSize: cellSize,
    );
  }
}

class _MiddleArea extends StatelessWidget {
  final double cellSize;

  const _MiddleArea({required this.cellSize});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: cellSize * 9,
        maxHeight: cellSize * 9,
      ),
      child: Container(
        alignment: Alignment.center,
        child: Text(
          "NOT Monopoly",
          textScaler: TextScaler.linear(cellSize * 0.07),
        ),
      ),
    );
  }
}

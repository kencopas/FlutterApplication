import 'package:flutter/material.dart';
import '../models/board_space_data.dart';
import 'dart:math';

/// Widget for rendering an individual Monopoly tile.
class BoardSpaceWidget extends StatelessWidget {
  final BoardSpaceData space;

  const BoardSpaceWidget({super.key, required this.space});

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

    return SizedBox(
      width: 200,
      height: 200,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          color: bg,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            space.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
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

        Widget _tile(BoxConstraints constraints, BoardSpaceData s) {
          return ConstrainedBox(
            constraints: constraints,
            child: BoardSpaceWidget(space: s),
          );
        }
        Widget _rowTile(BoardSpaceData s) {
          return _tile(
            BoxConstraints(maxWidth: cellSize, maxHeight: cellSize * 2),
            s,
          );
        }
        Widget _columnTile(BoardSpaceData s) {
          return _tile(
            BoxConstraints(maxWidth: cellSize * 2, maxHeight: cellSize),
            s,
          );
        }
        Widget _cornerTile(BoardSpaceData s) {
          return _tile(
            BoxConstraints(maxWidth: cellSize * 2, maxHeight: cellSize * 2),
            s,
          );
        }

        final middleArea = ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: cellSize * 9,
            maxHeight: cellSize * 9,
          ),
          child: Placeholder(),
        );

        final topRowSpaces = Row(
          children: [
            _cornerTile(top[0]),
            for (var topSpaceData in top.sublist(1, 10)) ...[_rowTile(topSpaceData)],
            _cornerTile(top[10]),
          ],
        );

        final bottomRowSpaces = Row(
          children: [
            _cornerTile(bottom[0]),
            for (var bottomSpaceData in bottom.sublist(1, 10)) ...[_rowTile(bottomSpaceData)],
            _cornerTile(bottom[10]),
          ],
        );

        final leftColumnSpaces = Column(
          children: [
            for (var leftSpaceData in left) ...[_columnTile(leftSpaceData)]
          ],
        );

        final rightColumnSpaces = Column(
          children: [
            for (var rightSpaceData in right) ...[_columnTile(rightSpaceData)]
          ],
        );

        final middleSection = Row(
          children: [leftColumnSpaces, middleArea, rightColumnSpaces],
        );

        return Column(children: [topRowSpaces, middleSection, bottomRowSpaces]);
      },
    );
  }
}

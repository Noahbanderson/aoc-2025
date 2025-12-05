import '../utils.dart';

final input = getInput().readAsLinesSync();
final _logger = getLogger();

final map = input
    .map((final line) => line.split('').map((final cell) => cell == '@').toList())
    .toList();

void main() {
  part1();
  part2();
}

typedef Coord = (int, int);

extension on Coord {
  Coord moveBy(final Coord offset) => (this.$1 + offset.$1, this.$2 + offset.$2);

  bool isValid(final int maxRow, final int maxCol) =>
      0 <= this.$1 && this.$1 <= maxRow && 0 <= this.$2 && this.$2 <= maxCol;
}

void part1() {
  final maxRowIdx = map.length - 1;
  final maxColIdx = map.first.length - 1;

  var count = 0;

  for (final (rowIdx, row) in map.indexed) {
    for (final (colIdx, cell) in row.indexed) {
      if (!cell) {
        // Skip '.' cells from being evaluated
        continue;
      }

      final position = (rowIdx, colIdx);

      const directions = [
        (-1, 0), // north
        (-1, 1), // northeast
        (0, 1), // east
        (1, 1), // southeast
        (1, 0), // south
        (1, -1), // southwest
        (0, -1), // west
        (-1, -1), // northwest
      ];

      final neighborValues = directions.map((final dir) {
        final newPos = position.moveBy(dir);
        if (newPos.isValid(maxRowIdx, maxColIdx)) {
          return map[newPos.$1][newPos.$2];
        } else {
          // Default to a '.'
          return false;
        }
      });

      final nearbyRolls =
          neighborValues.fold(0, (final count, final cell) => count + (cell ? 1 : 0));

      // The forklifts can only access a roll of paper if there are fewer than four rolls of paper in the eight adjacent positions.
      if (nearbyRolls < 4) {
        count++;
      }
    }
  }

  _logger.info('Result <part_1>: $count');
}

void part2() {
  final maxRowIdx = map.length - 1;
  final maxColIdx = map.first.length - 1;

  var count = 0;

  var hasFoundSome = false;
  do {
    hasFoundSome = false;
    for (final (rowIdx, row) in map.indexed) {
      for (final (colIdx, cell) in row.indexed) {
        if (!cell) {
          // Skip '.' cells from being evaluated
          continue;
        }

        final position = (rowIdx, colIdx);

        const directions = [
          (-1, 0), // north
          (-1, 1), // northeast
          (0, 1), // east
          (1, 1), // southeast
          (1, 0), // south
          (1, -1), // southwest
          (0, -1), // west
          (-1, -1), // northwest
        ];

        final neighborValues = directions.map((final dir) {
          final newPos = position.moveBy(dir);
          if (newPos.isValid(maxRowIdx, maxColIdx)) {
            return map[newPos.$1][newPos.$2];
          } else {
            // Default to a '.'
            return false;
          }
        });

        final nearbyRolls =
            neighborValues.fold(0, (final count, final cell) => count + (cell ? 1 : 0));

        // The forklifts can only access a roll of paper if there are fewer than four rolls of paper in the eight adjacent positions.
        if (nearbyRolls < 4) {
          count++;
          hasFoundSome = true;

          // replace the cell
          map[rowIdx][colIdx] = false;
        }
      }
    }
  } while (hasFoundSome);

  _logger.info('Result <part_2>: $count');
}

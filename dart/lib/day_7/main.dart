import 'package:collection/collection.dart';

import '../utils.dart';

final input = getInput().readAsLinesSync();
final _logger = getLogger();

/// (rowIdx, colIdx)
typedef Coord = (int, int);

extension Beam on Coord {
  /// Also moves the beam down 2 levels because splitters are separated by empty lines
  List<Coord> split({final int moveDownAmount = 2}) {
    return [
      // Left
      (this.$1, this.$2 - 1).moveDown(moveDownAmount),
      // Right
      (this.$1, this.$2 + 1).moveDown(moveDownAmount),
    ];
  }

  Coord moveDown([final int amount = 1]) => (this.$1 + amount, this.$2);
}

final Coord start = (0, input[0].indexOf("S"));

/// `true` is indicative of a splitter. `false` for everything else.
final matrix = input
    .map((final line) => line.split("").map((final cell) => cell == '^').toList())
    .toList();

void main() {
  part1();
  part2();
}

void part1() {
  var splittersHit = 0;

  final beams = <Coord>{start.moveDown(2)};

  // Move down the matrix
  for (var row = 2; row < matrix.length; row += 2) {
    final newlySplitBeams = <Coord>{};

    // Yes, we don't need to check EVERY place, we could've trimmed it down earlier, not important while trying to get working
    for (var colIdx = 0; colIdx < matrix[row].length; colIdx++) {
      final isSplitter = matrix[row][colIdx];
      final coord = (row, colIdx);
      if (isSplitter && beams.contains(coord)) {
        newlySplitBeams.addAll(coord.split());
        beams.remove(coord);
        splittersHit++;
      }
    }

    // FIXED: We need to materialize this mapped list before clearing or the lazy evaluation will happen after clear...
    final nonIntersectingBeams = beams.map((final beam) => beam.moveDown(2)).toList();

    beams.clear();
    beams.addAll(nonIntersectingBeams);
    beams.addAll(newlySplitBeams);
  }

  _logger.info('Result <part_1>: $splittersHit');
}

typedef CoordAndCount = (Coord, int);

extension on CoordAndCount {
  Coord get coord => this.$1;
  int get count => this.$2;
}

void part2() {
  final beamsAndCounts = <CoordAndCount>[(start.moveDown(2), 1)];

  // Move down the matrix
  for (var row = 2; row < matrix.length; row += 2) {
    final newlySplitBeams = <CoordAndCount>[];

    for (var colIdx = 0; colIdx < matrix[row].length; colIdx++) {
      final isSplitter = matrix[row][colIdx];
      if (isSplitter) {
        final coord = (row, colIdx);
        final beamAndCount = beamsAndCounts
            .firstWhereOrNull((final beamAndCount) => beamAndCount.coord == coord);

        if (beamAndCount == null) {
          continue;
        }

        newlySplitBeams.addAll(
          beamAndCount //
              .coord
              .split()
              .map((final coord) => (coord, beamAndCount.count)),
        );

        beamsAndCounts.remove(beamAndCount);
      }
    }

    // FIXED: We need to materialize this mapped list before clearing or the lazy evaluation will happen after clear...
    final nonIntersectingBeams = beamsAndCounts //
        .map((final beam) => (beam.coord.moveDown(2), beam.count))
        .toList();

    beamsAndCounts.clear();

    // Merge beams and sum counts

    final mergedBeamCounts = <Coord, int>{};

    for (final CoordAndCount(:coord, :count) in [
      ...nonIntersectingBeams,
      ...newlySplitBeams
    ]) {
      mergedBeamCounts.update(
        coord,
        (final existing) => existing + count,
        ifAbsent: () => count,
      );
    }

    beamsAndCounts.addAll(
      mergedBeamCounts.entries.map((final entry) => (entry.key, entry.value)),
    );
  }

  final totalCount = beamsAndCounts.fold(0, (final sum, final e) => sum + e.count);
  _logger.info('Result <part_2>: $totalCount');
}

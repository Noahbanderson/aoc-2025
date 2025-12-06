import '../utils.dart';

final _logger = getLogger();

typedef Range = (int, int);

extension on Range {
  int get start => this.$1;
  int get end => this.$2;

  bool contains(final int value) => start <= value && value <= end;

  Range merge(final Range other) =>
      (start < other.start ? start : other.start, end > other.end ? end : other.end);
}

void main() {
  final [rawRanges, rawIngredientIds] = getInput().readAsStringSync().split('\n\n');

  final ranges = rawRanges.split('\n').map((final line) {
    final [start, end] = line.split('-');
    return (int.parse(start), int.parse(end));
  }).toList();

  final List<int> ingredientIds = rawIngredientIds
      .split('\n')
      .map(int.tryParse)
      .where((final id) => id != null)
      .cast<int>()
      .toList();

  part1(ranges, ingredientIds);
  part2(ranges);
}

void part1(final List<Range> ranges, final List<int> ingredientIds) {
  var count = 0;
  for (final id in ingredientIds) {
    for (final range in ranges) {
      if (range.contains(id)) {
        count++;
        break;
      }
    }
  }

  _logger.info('Result <part_1>: $count');
}

void part2(final List<Range> ranges) {
  // Initial Sorting
  ranges.sort((final a, final b) {
    final startCompare = a.start.compareTo(b.start);
    if (startCompare == 0) {
      return a.end.compareTo(b.end);
    } else {
      return startCompare;
    }
  });

  // Start with the lowest
  final merged = [ranges[0]];

  // Skip the first entry
  for (var idx = 1; idx < ranges.length; idx++) {
    final range = ranges[idx];
    final last = merged.last;

    // Check if has overlap
    if (range.start <= last.end) {
      // Update the last entry
      merged[merged.length - 1] = last.merge(range);
    } else {
      // Append to list
      merged.add(range);
    }
  }

  final count =
      merged.fold(0, (final count, final range) => count + range.end - range.start + 1);

  _logger.info('Result <part_2>: $count');
}

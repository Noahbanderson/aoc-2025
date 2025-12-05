import 'package:collection/collection.dart';

import '../utils.dart';

final input = getInput().readAsLinesSync();
final _logger = getLogger();

final Iterable<(int, int)> ranges = input[0].split(',').map((final range) {
  final parts = range.split('-').map(int.parse).toList();
  return (parts[0], parts[1]);
});

final expandedRanges = ranges.map(
  (final range) => List.generate(
      range.$2 - range.$1 + 1, //
      (final index) => (index + range.$1).toString()),
);

final allValues = expandedRanges.expand((final i) => i);

void main() {
  part1();
  part2();
}

void part1() {
  final re = RegExp(r'^(.+)\1$');
  final List<int> invalidIds = [];
  for (final value in allValues) {
    if (re.hasMatch(value)) {
      invalidIds.add(int.parse(value));
    }
  }

  final sum = invalidIds.sum;

  _logger.info('Result <part_1>: $sum');
}

void part2() {
  final re = RegExp(r'^(.+?)\1+$');
  final List<int> invalidIds = [];
  for (final value in allValues) {
    if (re.hasMatch(value)) {
      invalidIds.add(int.parse(value));
    }
  }

  final sum = invalidIds.sum;
  _logger.info('Result <part_2>: $sum');
}

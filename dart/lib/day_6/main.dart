import 'package:collection/collection.dart';

import '../utils.dart';

final lines = getInput().readAsLinesSync();
final _logger = getLogger();

final re = RegExp(r' +');

void main() {
  part1();
  part2();
}

void part1() {
// Get all but the last lines
  final parsedLines = lines //
      .take(lines.length - 1)
      .map(
        (final line) => line //
            .split(re)
            .where((final i) => i.isNotEmpty)
            .map(int.parse)
            .toList(),
      )
      .toList();

// True means isMultiplication, false means isAddition
  final operators = lines
      .skip(lines.length - 1)
      .toList()[0]
      .split(re)
      .where((final i) => i.isNotEmpty)
      .map((final cell) => cell == '*')
      .toList();

  // Set up the start of the sum with the first values
  final sums = [...parsedLines.first];

  for (final lines in parsedLines.skip(1)) {
    for (final (idx, number) in lines.indexed) {
      sums[idx] = operators[idx] ? sums[idx] * number : sums[idx] + number;
    }
  }

  _logger.info('Result <part_1>: ${sums.sum}');
}

// For Debugging
extension Matrix on List<List<String>> {
  String toStr() {
    return '\n${map((final line) => line.join()).join('\n')}';
  }
}

void part2() {
  final matrix = lines.map((final line) => line.split('').toList()).toList();

  final rowLength = matrix.length;
  final columnLength = matrix.first.length;

  // Create a new matrix with transposed dimensions
  final transposed = List.generate(
    columnLength,
    (final j) => List.generate(
      rowLength,
      (final i) => matrix[i][j],
    ),
  );

  // _logger.info(transposed.toStr());

  final List<List<List<String>>> sections = [];
  var lastIdx = 0;

  // partition by empty lines
  for (final (idx, row) in transposed.indexed) {
    if (row.every((final str) => str == ' ')) {
      sections.add(transposed.sublist(lastIdx, idx));
      // break up
      lastIdx = idx + 1;

      // Account for the last section
    } else if (idx == transposed.length - 1) {
      sections.add(transposed.sublist(lastIdx, idx + 1));
    }
  }

  final sum = sections.reversed.map(parseAndCompute).sum;
  _logger.info('Result <part_2>: $sum');
}

int parseAndCompute(final List<List<String>> section) {
  final isMultiplication = section.first.last == '*';
  section.first.last = '';

  final ints = section.map((final line) => int.parse(line.join(''))).toList();

  var total = ints.first;

  for (final integer in ints.skip(1)) {
    if (isMultiplication) {
      total *= integer;
    } else {
      total += integer;
    }
  }

  // _logger.info('We are `${ints.reversed.join(isMultiplication ? ' * ' : ' + ')}` = $total');

  return total;
}

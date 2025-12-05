import '../utils.dart';

final input = getInput().readAsLinesSync();
final _logger = getLogger();

void main() {
  part1();
  part2();
}

void part1() {
  var position = 50;
  var zeroCount = 0;

  for (final line in input) {
    final isNegative = line[0] == 'L';
    final value = int.parse(line.substring(1));

    position = (isNegative ? position - value : position + value) % 100;

    if (position == 0) {
      zeroCount++;
    }
  }

  _logger.info('Part 1 Result: $zeroCount');
}

void part2() {
  var position = 50;
  var zeroCount = 0;

  for (final line in input) {
    final isNegative = line[0] == 'L';
    final originalPosition = position;
    final value = int.parse(line.substring(1));

    final rawNewPosition = isNegative ? position - value : position + value;

    position = rawNewPosition % 100;

    var crossOverCount = (rawNewPosition ~/ 100).abs();
    if (originalPosition != 0 && rawNewPosition.isNegative) {
      crossOverCount++;
    }
    zeroCount += crossOverCount + (rawNewPosition == 0 ? 1 : 0);

    // _logger.info(
    //     'The dial is rotated $line to point at $position${crossOverCount == 0 ? '' : '; during this rotation, it points at 0 ($crossOverCount) times.'}');
  }

  _logger.info('Part 2 Result: $zeroCount');
}

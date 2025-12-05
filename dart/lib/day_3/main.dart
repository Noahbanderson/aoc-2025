import 'package:collection/collection.dart';

import '../utils.dart';

final input = getInput().readAsLinesSync();
final _logger = getLogger();

final allBanks = input.map((final line) => line.split('').map(int.parse).toList());

void main() {
  part1();
  part2();
}

void part1() {
  final List<int> largestJolts = [];

  for (final bank in allBanks) {
    var digitOne = 0;
    var digitTwo = 0;

    for (final (index, cell) in bank.indexed) {
      final isLastCell = index + 1 == bank.length;

      if (!isLastCell && digitOne < cell) {
        digitOne = cell;
        digitTwo = 0;
      } else if (digitTwo < cell) {
        digitTwo = cell;
      }
    }

    final jolt = int.parse('$digitOne$digitTwo');
    // _logger.info('In ${bank.join()}, the largest jolt is $jolt');
    largestJolts.add(jolt);
  }

  final sum = largestJolts.sum;

  _logger.info('Result <part_1>: $sum');
}

void part2() {
  final List<int> largestJolts = [];
  for (final bank in allBanks) {
    final jolt = processBank(bank);
    // _logger.info('In ${bank.join()}, the largest jolt is $jolt');
    largestJolts.add(jolt);
  }

  final sum = largestJolts.sum;

  _logger.info('Result <part_2>: $sum');
}

int processBank(final List<int> bank) {
  final bankStr = bank.join();
  const numOfBatteries = 12;
  var levels = numOfBatteries;

  final List<int> batteries = [];

  var startIndex = 0;

  while (levels > 0) {
    final sub = bankStr.substring(startIndex, bank.length - levels + 1);

    var highestVal = 0;
    var maxIndex = 0;
    for (final (index, val) in sub.split('').map(int.parse).indexed) {
      if (highestVal < val) {
        highestVal = val;
        maxIndex = index;
      }
    }

    batteries.add(highestVal);

    startIndex += maxIndex + 1;

    // _logger.info('sub: $sub --> highestVal: $highestVal AND new index: $startIndex');

    levels--;
  }

  return int.parse(batteries.join());
}

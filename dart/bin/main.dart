import 'package:args/args.dart';
import 'package:dart/day_1/main.dart' as day1;
import 'package:dart/day_10/main.dart' as day10;
import 'package:dart/day_11/main.dart' as day11;
import 'package:dart/day_12/main.dart' as day12;
import 'package:dart/day_2/main.dart' as day2;
import 'package:dart/day_3/main.dart' as day3;
import 'package:dart/day_4/main.dart' as day4;
import 'package:dart/day_5/main.dart' as day5;
import 'package:dart/day_6/main.dart' as day6;
import 'package:dart/day_7/main.dart' as day7;
import 'package:dart/day_8/main.dart' as day8;
import 'package:dart/day_9/main.dart' as day9;

void main(final List<String> arguments) {
  final parser = ArgParser() //
    ..addOption(
      'day',
      abbr: 'd',
      mandatory: true,
      help: 'Day to run',
      valueHelp: '1',
      allowed: Iterable.generate(24, (final i) => '${i + 1}'),
      hide: false,
    )
    ..addOption(
      'part',
      abbr: 'p',
      mandatory: false,
      help: 'Part 1 or 2',
      valueHelp: '1',
      allowed: ['1', '2'],
      hide: false,
    );
  final args = parser.parse(arguments);
  final day = int.parse(args['day'] as String);
  final partStr = args['part'] as String?;
  final part = partStr == null ? 1 : int.parse(partStr);
  functions[day - 1][part - 1]();
}

final functions = [
  [day1.part1, day1.part2],
  [day2.part1, day2.part2],
  [day3.part1, day3.part2],
  [day4.part1, day4.part2],
  [day5.part1, day5.part2],
  [day6.part1, day6.part2],
  [day7.part1, day7.part2],
  [day8.part1, day8.part2],
  [day9.part1, day9.part2],
  [day10.part1, day10.part2],
  [day11.part1, day11.part2],
  [day12.part1, day12.part2],
];

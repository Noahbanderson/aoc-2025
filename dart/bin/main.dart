import 'package:args/args.dart';
import 'package:dart/day_1/main.dart' as day1;
import 'package:dart/day_10/main.dart' as day10;
import 'package:dart/day_11/main.dart' as day11;
import 'package:dart/day_12/main.dart' as day12;
import 'package:dart/day_13/main.dart' as day13;
import 'package:dart/day_14/main.dart' as day14;
import 'package:dart/day_15/main.dart' as day15;
import 'package:dart/day_16/main.dart' as day16;
import 'package:dart/day_17/main.dart' as day17;
import 'package:dart/day_18/main.dart' as day18;
import 'package:dart/day_19/main.dart' as day19;
import 'package:dart/day_2/main.dart' as day2;
import 'package:dart/day_20/main.dart' as day20;
import 'package:dart/day_21/main.dart' as day21;
import 'package:dart/day_22/main.dart' as day22;
import 'package:dart/day_23/main.dart' as day23;
import 'package:dart/day_24/main.dart' as day24;
import 'package:dart/day_25/main.dart' as day25;
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
  [day13.part1, day13.part2],
  [day14.part1, day14.part2],
  [day15.part1, day15.part2],
  [day16.part1, day16.part2],
  [day17.part1, day17.part2],
  [day18.part1, day18.part2],
  [day19.part1, day19.part2],
  [day20.part1, day20.part2],
  [day21.part1, day21.part2],
  [day22.part1, day22.part2],
  [day23.part1, day23.part2],
  [day24.part1, day24.part2],
  [day25.part1, day25.part2],
];

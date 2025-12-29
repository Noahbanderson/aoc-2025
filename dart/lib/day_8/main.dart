import 'dart:math';

import 'package:collection/collection.dart';

import '../utils.dart';

final nodes = getInput() //
    .readAsLinesSync()
    .map((final line) {
  final [x, y, z] = line.split(',').map(int.parse).toList();
  return (x, y, z);
}) //
    .toList()
  ..sort((final a, final b) {
    final x = a.x.compareTo(b.x);
    if (x != 0) {
      return x;
    }
    final y = a.y.compareTo(b.y);
    if (y != 0) {
      return y;
    }
    return a.z.compareTo(b.z);
  });
final _logger = getLogger();

typedef Coord = (int, int, int);

extension on Coord {
  int get x => this.$1;
  int get y => this.$2;
  int get z => this.$3;

  double distance(final Coord other) {
    return sqrt(pow(other.x - x, 2) + pow(other.y - y, 2) + pow(other.z - z, 2));
  }

  int compare(final Coord other) {
    final xCmp = x.compareTo(other.x);
    if (xCmp != 0) {
      return xCmp;
    }
    final yCmp = y.compareTo(other.y);
    if (yCmp != 0) {
      return yCmp;
    }
    return z.compareTo(other.z);
  }
}

void main() {
  part1();
  part2();
}

class Circuit implements Comparable {
  final Coord start;
  final Coord end;
  final double distance;

  List<Coord> get coords => [start, end];

  Circuit({
    required this.start,
    required this.end,
    final double? distance,
  }) : distance = distance ?? start.distance(end);

  bool connectsTo(final Circuit other) {
    return start == other.start ||
        end == other.end ||
        start == other.end ||
        end == other.start;
  }

  @override
  int compareTo(final other) {
    if (other is! Circuit) {
      throw ArgumentError('Cannot compare Circuit with non-Circuit: $other');
    }
    // Compare by distance, then by start, then by end
    final d = distance.compareTo(other.distance);
    if (d != 0) {
      return d;
    }

    // Compare the start coordinates
    final startCmp = start.compare(other.start);
    if (startCmp != 0) {
      return startCmp;
    }

    // Compare the end coordinates
    return end.compare(other.end);
  }

  // These two methods determine Set uniqueness
  @override
  bool operator ==(final Object other) {
    if (identical(this, other) || other is! Circuit) {
      return true;
    }

    return (start == other.start && end == other.end) ||
        (start == other.end && end == other.start);
  }

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() =>
      'Circuit(start: $start, end: $end, distance: ${distance.toStringAsFixed(2)})';
}

class JunctionBox implements Comparable {
  final circuits = <Circuit>{};

  Iterable<Coord> get coords => circuits //
      .map((final circuit) => circuit.coords)
      .flattened;

  int get circuitLength => circuits.length;

  @override
  int compareTo(final other) {
    if (other is! JunctionBox) {
      throw ArgumentError('Cannot compare JunctionBox with non-JunctionBox: $other');
    }
    return circuits.length.compareTo(other.circuits.length);
  }
}

void part1() {
  const numberOfConnections = 1000;
  const numberOfLargestCircuits = 3;

  // Faster approach:
  final circuits = <Circuit>[];
  for (var i = 0; i < nodes.length; i++) {
    for (var j = i + 1; j < nodes.length; j++) {
      circuits.add(
        Circuit(
          start: nodes[i],
          end: nodes[j],
        ),
      );
    }
  }
  circuits.sort();

  // Use Union-Find to track connected components
  // 'parent' is a map where the key is a node and the value is its parent in the disjoint set structure.
  // So: parent[child] = parent_of_child
  final parent = <Coord, Coord>{};
  final size = <Coord, int>{};

  // Initialize each node as its own parent
  for (final node in nodes) {
    parent[node] = node;
    size[node] = 1;
  }

  // Find with path compression
  Coord find(final Coord node) {
    if (parent[node] != node) {
      parent[node] = find(parent[node]!);
    }
    return parent[node]!;
  }

  // Union by size
  void union(final Coord a, final Coord b) {
    final rootA = find(a);
    final rootB = find(b);

    if (rootA == rootB) {
      return; // Already in same component
    }

    // Attach smaller tree under larger tree
    if (size[rootA]! < size[rootB]!) {
      parent[rootA] = rootB;
      size[rootB] = size[rootB]! + size[rootA]!;
    } else {
      parent[rootB] = rootA;
      size[rootA] = size[rootA]! + size[rootB]!;
    }
  }

  // Connect the shortest pairs
  var connectionsProcessed = 0;
  for (final circuit in circuits) {
    if (connectionsProcessed >= numberOfConnections) {
      break;
    }
    union(circuit.start, circuit.end);
    connectionsProcessed++;
  }

  // Count component sizes
  final componentSizes = <Coord, int>{};
  for (final node in nodes) {
    final root = find(node);
    componentSizes[root] = size[root]!;
  }

  // Get the sizes and sort them
  final sizes = componentSizes.values.toList()
    ..sort((final a, final b) => b.compareTo(a));

  _logger.info('Number of circuits: ${sizes.length}');
  _logger.info('Circuit sizes: $sizes');

  final result = sizes.take(numberOfLargestCircuits).reduce((final a, final b) => a * b);

  _logger.info('Result <part_1>: $result');
}

void part2() {
  // Faster approach:
  final circuits = <Circuit>[];
  for (var i = 0; i < nodes.length; i++) {
    for (var j = i + 1; j < nodes.length; j++) {
      circuits.add(
        Circuit(
          start: nodes[i],
          end: nodes[j],
        ),
      );
    }
  }
  circuits.sort();

  // Use Union-Find to track connected components
  // 'parent' is a map where the key is a node and the value is its parent in the disjoint set structure.
  // So: parent[child] = parent_of_child
  final parent = <Coord, Coord>{};
  final size = <Coord, int>{};

  // Initialize each node as its own parent
  for (final node in nodes) {
    parent[node] = node;
    size[node] = 1;
  }

  // Find with path compression
  Coord find(final Coord node) {
    if (parent[node] != node) {
      parent[node] = find(parent[node]!);
    }
    return parent[node]!;
  }

  // Union by size
  void union(final Coord a, final Coord b) {
    final rootA = find(a);
    final rootB = find(b);

    if (rootA == rootB) {
      return; // Already in same component
    }

    // Attach smaller tree under larger tree
    if (size[rootA]! < size[rootB]!) {
      parent[rootA] = rootB;
      size[rootB] = size[rootB]! + size[rootA]!;
    } else {
      parent[rootB] = rootA;
      size[rootA] = size[rootA]! + size[rootB]!;
    }
  }

  // Connect pairs until all nodes are in a single circuit
  Circuit? lastConnection;
  var numberOfComponents = nodes.length;

  for (final circuit in circuits) {
    final rootA = find(circuit.start);
    final rootB = find(circuit.end);

    // If they're already connected, skip
    if (rootA == rootB) {
      continue;
    }

    // Connect them
    union(circuit.start, circuit.end);
    numberOfComponents--;

    // Check if we've reached a single circuit
    if (numberOfComponents == 1) {
      lastConnection = circuit;
      break;
    }
  }

  if (lastConnection != null) {
    final result = lastConnection.start.x * lastConnection.end.x;
    _logger.info('Last connection: ${lastConnection.start} <-> ${lastConnection.end}');
    _logger.info('Result <part_2>: $result');
  } else {
    _logger.info('Could not connect all junction boxes into a single circuit');
  }
}

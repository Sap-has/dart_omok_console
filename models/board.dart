import 'move.dart';

class Board {
  int size;
  dynamic grid;

  Board(this.size) {
    grid = List.generate(size, (_) => List.generate(size, (_) => '.'));
  }

  void update(Move move, String playerSymbol) {
    grid[move.x][move.y] = playerSymbol;
  }

  @override
  String toString() {
    return grid.map((row) => row.join(' ')).join('\n');
  }
}
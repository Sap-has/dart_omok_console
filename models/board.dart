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

  markWinningLine(winningLine) {
    for (var move in winningLine) {
      grid[move.x][move.y] = 'W';
    }
  }

  @override
  String toString() {
    // Column headers with modulo operation to wrap around after 9
    String header = ' x ${List.generate(size, (i) => ((i + 1) % 10).toString()).join(' ')}\n';

    // Rows with row numbers
    String boardRepresentation = ' y\n';
    for (int i = 0; i < size; i++) {
      String row = '${(i + 1) % 10} '.padLeft(3);  // Row number with modulo to wrap after 9
      row += grid[i].join(' ');                    // Add cells in the row
      boardRepresentation += '$row\n';
    }
    return header + boardRepresentation;
  }
}
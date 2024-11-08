import 'move.dart';

class Board {
  int size;
  dynamic grid;
  Move? lastComputerMove;

  Board(this.size) {
    grid = List.generate(size, (_) => List.generate(size, (_) => '.'));
  }

  void update(Move move, String playerSymbol, {bool isComputerMove = false}) {
    grid[move.x][move.y] = playerSymbol;

    // Store the last computer move to highlight it
    if (isComputerMove) {
      lastComputerMove = move;
    } else {
      lastComputerMove = null;  // Clear highlight if it's not the computer's move
    }
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
      String row = '${(i + 1) % 10} '.padLeft(3);

      for (int j = 0; j < size; j++) {
        // Show '*' for the last computer move
        if (lastComputerMove != null && lastComputerMove!.x == i && lastComputerMove!.y == j) {
          row += '* ';
        } else {
          row += '${grid[i][j]} ';
        }
      }
      boardRepresentation += '$row\n';
    }
    return header + boardRepresentation;
  }
}
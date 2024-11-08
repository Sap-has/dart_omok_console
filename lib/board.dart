import 'move.dart';

//MODEL 
///Class [Board] creates the playing board for the game
class Board {
  int size;
  dynamic grid;
  Move? lastComputerMove;

  //Function [Board] generates a board with the given size
  Board(this.size) {
    grid = List.generate(size, (_) => List.generate(size, (_) => '.'));
  }

  ///Function [update] changes the board based on the game state
  void update(Move move, String playerSymbol, {bool isComputerMove = false}) {
    grid[move.x][move.y] = playerSymbol;

    //Store the last computer move to highlight it
    if (isComputerMove) {
      lastComputerMove = move;
    } else {
      lastComputerMove = null;  //Clear highlight if it's not the computer's move
    }
  }

  ///Function [markWinningLine] changes the winning line to W when game is over
  markWinningLine(winningLine) {
    for (var move in winningLine) {
      grid[move.x][move.y] = 'W';
    }
  }

  @override
  ///Function [toString] shows the board in the terminal for user to see
  String toString() {
    //Column headers with modulo operation to wrap around after 9
    String header = ' x ${List.generate(size, (i) => ((i + 1) % 10).toString()).join(' ')}\n';

    //Rows with row numbers
    String boardRepresentation = ' y\n';
    for (int i = 0; i < size; i++) {
      String row = '${(i + 1) % 10} '.padLeft(3);

      for (int j = 0; j < size; j++) {
        //Show '*' for the last computer move
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
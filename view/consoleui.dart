import 'dart:io';
import '../models/move.dart';
import '../models/board.dart';

class ConsoleUI {
  void welcome() => print("Welcome to Omok!");

  promptURL() {
    const defaultUrl = 'https://www.cs.utep.edu/cheon/cs3360/project/omok/';
    String? url;

    while (true) {
      stdout.write('Enter the server URL [default: $defaultUrl]');
      url = stdin.readLineSync()?.trim(); // removes any whitespace that is trailing
      url = (url == null || url.isEmpty) ? defaultUrl : url;
      if (Uri.tryParse(url)!.isAbsolute) {
        return url;
      } else {
        print("Please enter a valid URL.");
      }
    }
  }

  promptStrategy(strategies) {
    print("Select the server strategy: $strategies [default: 1]");
    int selection = 1;

    while (true) {
      var line = stdin.readLineSync()?.trim();
      line = (line == null || line.isEmpty) ? "1" : line;

      try {
        selection = int.parse(line);
        if (selection == 1 || selection == 2) {
          print("Creating new game .....");
          return strategies[selection - 1];
        } else {
          print("Invalid selection: $selection");
        }
      } on FormatException {
        print("Invalid input. Please enter a valid number.");
      }
    }
  }

  promptMove(int boardSize) async {
    print("Enter your move (1-$boardSize for both x and y): ");
    var input = stdin.readLineSync()?.split(' ');
    while (input == null || input.length != 2) {
      print("Invalid input! Enter two numbers separated by a space.");
      input = stdin.readLineSync()?.split(' ');
    }
    return Move(int.parse(input[0]) - 1, int.parse(input[1]) - 1); // updates moves from the class move
  }

  displayBoard(Board board) {
    print("Current Board:");
    print(board); // Uses Board's toString method to display the grid
  }

  displayConsoleMoves(playerMove, computerMove) {
    print("Your move: (${playerMove['x'] + 1}, ${playerMove['y'] + 1})"); // it is 1-based indexing
    print("Computer move: (${computerMove['x'] + 1}, ${computerMove['y'] + 1})");
  }

  showEndGameResult(response, bool playerWon) {
    if (response['ack_move']['isWin'] && playerWon) {
      print("Congratulations, you won!");
    } else if (response['move']['isWin'] && !playerWon) {
      print("Game over. The computer won!");
    } else if (response['ack_move']['isDraw'] || response['move']['isDraw']) {
      print("It's a draw!");
    }
  }
}

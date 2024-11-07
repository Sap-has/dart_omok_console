import 'dart:io';
import '../models/move.dart';
import '../models/board.dart';

class ConsoleUI {
  void welcome() => print("Welcome to Omok!");

  promptURL() {
    var defaultUrl = 'https://www.cs.utep.edu/cheon/cs3360/project/omok/';
    while (true) {
      stdout.write('Enter the server URL [default: $defaultUrl] ');
      var url = stdin.readLineSync()?.trim();
      url = (url == null || url.isEmpty) ? defaultUrl : url;
      if (Uri.tryParse(url)!.isAbsolute) return url;
      print("Please enter a valid URL.");
    }
  }

  promptStrategy(strategies) {
    print("Select the server strategy: $strategies [default: 1]");
    while (true) {
      var line = stdin.readLineSync()?.trim() ?? '1';
      try {
        int selection = int.parse(line);
        if (selection > 0 && selection <= strategies.length) {
          print("Creating new game ....."); 
          return strategies[selection - 1];
        }
        print("Invalid selection: $selection");
      } on FormatException {
        print("Invalid input. Please enter a valid number.");
      }
    }
  }

  promptMove(int boardSize) async {
    print("Enter your move (1-$boardSize for both x and y): ");
    var input;
    while (true) {
      input = stdin.readLineSync()?.split(' ');
      if (input != null && input.length == 2) {
        try {
          int x = int.parse(input[0]) - 1;
          int y = int.parse(input[1]) - 1;
          return Move(x, y);
        } on FormatException {
          print("Invalid input! Enter two numbers separated by a space.");
        }
      }
      print("Invalid input! Enter two numbers separated by a space.");
    }
  }

  void displayBoard(Board board) {
    print("Current Board:");
    print(board);
  }

  void displayError(String reason) {
    print(reason);
    print("Error: $reason");
  }

  void showEndGameResult(response, bool playerWon) {
    if (response['ack_move']['isWin'] && playerWon) {
      print("Congratulations, you won!");
    } else if (response['move']['isWin'] && !playerWon) {
      print("Game over. The computer won!");
    } else if (response['ack_move']['isDraw'] || response['move']['isDraw']) {
      print("It's a draw!");
    }
  }
}

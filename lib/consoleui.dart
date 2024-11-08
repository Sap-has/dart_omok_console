import 'dart:io';
import 'move.dart';
import 'board.dart';
import 'jsonparser.dart';

//VIEW
///Class [ConsoleUI] interacts with the user for the game
class ConsoleUI {
  void welcome() => print("Welcome to Omok!");

  ///Function [promptURL] asks the user for the game URL
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

  ///Function [promptStrategy] asks the user for the desired game strategy
  promptStrategy(strategies) {
    print("Select the server strategy (1 or 2): 1.${strategies[0]} 2.${strategies[1]} [default: 1]");
    while (true) {
      var line = stdin.readLineSync()?.trim();
      if (line == "") line = "1";
      try {
        int selection = int.parse(line!);
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

  ///Function [promptMove] asks the user for the desired move
  promptMove(int boardSize) async {
    print("Enter your move (1-$boardSize for both y,x): ");
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

  ///Function [displayBoard] shows the user the current board's state
  void displayBoard(Board board) {
    print("Current Board (Computer O, Player X, Computer's Last Move *):");
    print(board);
  }

  ///Function [displayError] gives the user an error if there's an issue
  void displayError(String reason) {
    if((reason.split(" "))[2] == "empty,"){
      var num1 = int.parse(reason[18])+1;
      var num2 = int.parse(reason[21])+1;
      print("Error: Place not empty, ($num1, $num2)");
    }
    else{
      print("Error: $reason");
    }
  }

  ///Function [showEndGameResult] shows the user the last state of the board
  void showEndGameResult(response, board) {
    JSONParser parse = JSONParser();
    if (response['ack_move']['isWin']) {
      var winningLine = parse.parseWinningLine(response['ack_move']['row']);
      board.markWinningLine(winningLine);
      displayBoard(board);
      print("Congratulations, you won!");
    } else if (response['move']['isWin']) {
      var winningLine = parse.parseWinningLine(response['move']['row']);
      board.markWinningLine(winningLine);
      displayBoard(board);
      print("Game over. The computer won!");
    } else if (response['ack_move']['isDraw'] || response['move']['isDraw']) {
      print("It's a draw!");
    }
  }
}

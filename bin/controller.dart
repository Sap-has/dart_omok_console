import '../services/webclient.dart';
import '../view/consoleui.dart';
import '../models/move.dart';
import '../models/board.dart';

class Controller {
  runGame() async {
    ConsoleUI ui = ConsoleUI();
    WebClient webClient = WebClient();
    Board board;

    ui.welcome();
    var url = ui.promptURL();

    // Retrieve game info and prompt for strategy
    var info = await webClient.getInfo(url);
    int boardSize = webClient.getBoardSize(info);
    board = Board(boardSize); // Initialize board size
    var strategies = webClient.getStrategies(info);
    var strategy = ui.promptStrategy(strategies);

    // Start a new game with the chosen strategy
    String pid;
    pid = await webClient.createNewGame(url, strategy);
    bool gameEnded = false;

    while (!gameEnded) {
      ui.displayBoard(board); // Display the board at the beginning of each turn

      // Prompt user for a move
      var move = await ui.promptMove(boardSize);

      // Send move to server and handle response
      var playResponse = await webClient.playResponse(url, move, pid);

      if (!playResponse['response']) {
        // Display server error (e.g., invalid move or other issue)
        print("Error: ${playResponse['reason']}");
        continue;
      }

      // Update board with the player's move
      board.update(move, 'X');  // 'X' for player

      // Display computer's move if the game continues
      var computerMove = Move(playResponse['move']['x'], playResponse['move']['y']);
      board.update(computerMove, 'O'); // 'O' for computer

      // Check for game ending conditions based on server response
      ui.displayConsoleMoves(playResponse['ack_move'], playResponse['move']);
      if (playResponse['ack_move']['isWin'] || playResponse['ack_move']['isDraw']) {
        ui.showEndGameResult(playResponse, true);
        gameEnded = true;
      } else if (playResponse['move']['isWin'] || playResponse['move']['isDraw']) {
        ui.showEndGameResult(playResponse, false);
        gameEnded = true;
      }
    } // while loop ends

  } // method runGame ends
} // class ends
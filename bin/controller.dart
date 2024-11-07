import '../services/webclient.dart';
import '../view/consoleui.dart';
import '../models/move.dart';
import '../models/board.dart';

class Controller {
  runGame() async {
    ConsoleUI ui = ConsoleUI();
    WebClient webClient = WebClient();

    ui.welcome();
    var url = ui.promptURL();
    var info = await webClient.getInfo(url);

    int boardSize = webClient.getBoardSize(info);
    var board = Board(boardSize);
    var strategies = webClient.getStrategies(info);
    var strategy = ui.promptStrategy(strategies);

    // Start a new game with the chosen strategy
    String pid = await webClient.createNewGame(url, strategy);
    bool gameEnded = false;

    while (!gameEnded) {
      ui.displayBoard(board);
      var move = await ui.promptMove(boardSize);
      
      // Send move to server and handle response
      var playResponse = await webClient.playResponse(url, move, pid);

      if (!playResponse['response']) {
        ui.displayError(playResponse['reason']);
        continue;
      }

      // Process player's move
      board.update(move, 'X');
      gameEnded = webClient.checkGameEnd(playResponse, board);
      if (gameEnded) {
        continue;
      }

      // Process computer's move
      var computerMove = Move(playResponse['move']['x'], playResponse['move']['y']);
      board.update(computerMove, 'O');
      gameEnded = webClient.checkGameEnd(playResponse, board);
    }
  }
} // class ends
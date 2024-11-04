import 'webclient.dart';
import 'consoleui.dart';

class Controller {
  runGame() async {
    // SOLID
    // Controller Class
    // first welcome user
    var ui = ConsoleUI(); // this class only interacts with user
    ui.welcome();
    var url = ui.promptURL();

    // new class to get info, new, play api's
    var net = WebClient();
    var info = await net.getInfo(url);
    var boardSize = net.getBoardSize(info);
    var strategies = net.getStrategies(info);
    var strategy = ui.promptStrategy(strategies);

    // make a new game, use strategy to create it
    var pid = await net.createNewGame(url, strategy);

    // go to play to make a move from the specified game using its pid
    // play takes pid, x and y position

    var currMove = await ui.promptMove(boardSize); // array of ["x", "y"]
    var playResponse = await net.playResponse(url, currMove, pid); // json of response of game
    print(playResponse);
    bool empty = net.evalPlayResponse(playResponse); // checking for empty spot, if false, promptMove()

    while(!empty) {
      currMove = await ui.promptMove(boardSize);
      playResponse = await net.playResponse(url, currMove, pid);
      print(playResponse);
      empty = net.evalPlayResponse(playResponse); // checking for empty spot
    }

    bool gameEnded = false;
    while(!gameEnded) {
      currMove = await ui.promptMove(boardSize);
      playResponse = await net.playResponse(url, currMove, pid);
      print(playResponse);
      empty = net.evalPlayResponse(playResponse);
      while(!empty) {
        currMove = await ui.promptMove(boardSize);
        playResponse = await net.playResponse(url, currMove, pid);
        print(playResponse);
        empty = net.evalPlayResponse(playResponse); // checking for empty spot
      }
      gameEnded = net.gameWon(playResponse);
    }
  }
}
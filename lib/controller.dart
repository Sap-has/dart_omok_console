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
    print(strategy);

    // make a new game, use strategy to create it
    var pid = await net.createNewGame(url, strategy);
    print(pid);

    // go to play to make a move from the specified game using its pid
    var gameURL = net.findGame(url, pid);
    print(gameURL);

    print(ui.promptMove(boardSize));
  }
}
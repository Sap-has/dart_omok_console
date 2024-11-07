import 'package:http/http.dart' as http;
import '../models/board.dart';
import 'jsonparser.dart';
import '../view/consoleui.dart';

class WebClient {
  getInfo(url) async { // return array of strategies
    print("connecting to server: info ....");

    var response = await http.get(Uri.parse("$url/info/"));
    var parser = JSONParser();
    var info = parser.parse(response);
    // parse json, return json of info
    return info;
  }

  getBoardSize(info) {
    return info['size']; // default board size if not provided
  }

  getStrategies(info) {
    return (info['strategies']);
  }

  createNewGame(url, strategy) async {
    var newGameUrl = '$url/new/?strategy=$strategy';
    var response = await http.get(Uri.parse(newGameUrl));
    var parser = JSONParser();
    var newGame = parser.parse(response);

    if (newGame['response']) {
      return newGame['pid'];
    } else {
      throw Exception("Failed to create a new game: ${newGame['reason']}");
    }
  }

  playResponse(gameURL, currMove, pid) async {
    gameURL = '$gameURL/play/?pid=$pid&x=${currMove.x}&y=${currMove.y}';
    var response = await http.get(Uri.parse(gameURL));
    var parser = JSONParser();
    var playResponse = parser.parse(response);
    return playResponse;
  }

  bool checkGameEnd(playResponse, Board board) {
    ConsoleUI ui = ConsoleUI();
    if (playResponse['ack_move']['isWin'] || playResponse['move']['isWin']) {
      ui.showEndGameResult(playResponse, board);
      return true;
    } else if (playResponse['ack_move']['isDraw'] || playResponse['move']['isDraw']) {
      ui.showEndGameResult(playResponse, board);
      return true;
    }
    return false;

  }
}

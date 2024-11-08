import 'package:dart_omok_console/consoleui.dart';
import 'package:http/http.dart' as http;
import 'board.dart';
import 'jsonparser.dart';

//CONTROLLER
///Class [WebClient] works with the decoded JSON code and web service
class WebClient {
  ///Function [getInfo] gets the information from the server url
  getInfo(url) async { // return array of strategies
    print("connecting to server: info ....");

    var response = await http.get(Uri.parse("$url/info/"));
    var parser = JSONParser();
    var info = parser.parse(response);
    // parse json, return json of info
    return info;
  }

  ///Function [getBoardSize] gets the board size from decoded info JSON code
  getBoardSize(info) {
    return info['size']; // default board size if not provided
  }

  ///Function [getStrategies] gets the board strategies from decoded info JSON code
  getStrategies(info) {
    return (info['strategies']);
  }

  ///Function [createNewGame] gets the new game URL and ID using the desired strategy 
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

  ///Function [playResponse] gets the game URL and returns the decoded JSON response
  playResponse(gameURL, currMove, pid) async {
    gameURL = '$gameURL/play/?pid=$pid&x=${currMove.x}&y=${currMove.y}';
    var response = await http.get(Uri.parse(gameURL));
    var parser = JSONParser();
    var playResponse = parser.parse(response);
    return playResponse;
  }

  ///Function [checkGameEnd] checks the JSON response to check if the game is over
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

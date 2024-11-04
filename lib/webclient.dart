import 'jsonparser.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// network class, only to make connection, not parsing
class WebClient { // make info call  
  getInfo(url) async { // return array of strategies
    print("connecting to server: info ....");

    var response = await http.get(Uri.parse(url+"/info/"));
    var parser = JSONParser();
    var info = parser.parse(response);
    // parse json, return json of info
    return info;
  }
  
  getStrategies(info) {
    String smart = (info['strategies'])[0];
    String random = (info['strategies'])[1];
    return <String> [smart, random];
  }
  
  getBoardSize(info) {
    return (info['size']);
  }

  createNewGame(url, strategy) async {
    var newGameUrl = url + "/new/?strategy=" + strategy;
    var response = await http.get(Uri.parse(newGameUrl));
    var parser = JSONParser();
    var newGame = parser.parse(response);

    var pid = (newGame['pid']);
    return pid;
  }

  playResponse(String gameURL, currMove, pid) async {
    gameURL = "$gameURL/play/?pid=${pid.toString()}&x=${currMove[0]}&y=${currMove[1]}";
    var response = await http.get(Uri.parse(gameURL));
    var parser = JSONParser();
    var playResponse = parser.parse(response);
    return playResponse;
  }

  evalPlayResponse(playResponse) {
    if(!(playResponse['response'])){
        if((playResponse['reason']).startsWith("Place not empty")){
          print("Not empty!");
          return false;
        }
    }
    return true;
  }

  bool gameWon(playResponse) {
    if((playResponse['ack_move']['row']).length == 0) {
      return false;
    }
    return true;
  }
}
import 'jsonparser.dart';
import 'package:http/http.dart' as http;

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
  
  String findGame(url, pid) {
    return url+"/play/?pid="+pid.toString();
  }
}
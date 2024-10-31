import 'dart:convert';
import 'dart:io'; 
import 'package:http/http.dart' as http;

void main() {
  var game = Controller();
  game.runGame();
}

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
    int pid = await net.createNewGame(url, strategy);

    // go to play to make a move from the specified game using its pid
    String gameURL = net.findGame(url, pid);

    print(ui.promptMove(boardSize));
  }
}


// make a parsing class
class JSONParser {
  parse(response) {
    return json.decode(response.body);
  }
}


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
    print(response);
    var parser = JSONParser();
    var newGame = parser.parse(response);

    int pid = (newGame['pid']);
    return pid;
  }
  
  String findGame(url, int pid) {
    return url+pid.toString();
  }
}

class ConsoleUI {
  void welcome() {
    print("Welcome to new Omok!");
  }
  
  promptURL() {
    var defaultUrl = 'https://www.cs.utep.edu/cheon/cs3360/project/omok/';
    stdout.write('Enter the server URL [default: $defaultUrl] ');
    var url = stdin.readLineSync();
    if (url == "") url = defaultUrl;
    bool validURL = Uri.parse(url!).isAbsolute;
    try {
      while(!validURL) {
        print("Please give a valid url");
        url = stdin.readLineSync();
        if (url == "") url = defaultUrl;
        validURL = Uri.parse(url!).isAbsolute;
      }
    } on FormatException {
      print("No url given");
    }

    return url;
  }
  
  promptStrategy(strategies) {
    print("Select the server strategy: $strategies [default: 1]");
    var line = stdin.readLineSync();
    if(line == "") line = "1";
    int selecetion = 1;
    try {
      selecetion = int.parse(line!);
      while(selecetion != 1 && selecetion != 2) {
        print("Invalid selection: $selecetion");
        line = stdin.readLineSync();
        if(line == "") line = "1";
        selecetion = int.parse(line!);
      }
      print("Creating new game .....");
    } on FormatException {
      print("No value given");
    }
    return strategies[selecetion-1];
  }

  // for the assignment due 10/30/2024, only focus on user inputing valid numbers
  // strictly 1-15, no letters/words, 2 numbers
  promptMove(boardSize) {
    print("Enter x and y (1-$boardSize, e.g., 8 10):");
    
    var indexInput = stdin.readLineSync()!.split(" "); // array of strings

    try {
      while(indexInput.isEmpty && indexInput.length > 2) {
        
      }
    } on FormatException {
      print("Invalid Index!");
    }
  }
}

class Board {
  int? size; // nullable variable
}

class Player {
  int? stone;
}
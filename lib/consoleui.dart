import 'dart:io';
import 'board.dart';
import 'webclient.dart';

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
  promptMove(boardSize, gameURL) {
    var net = WebClient();
    print("Enter x and y (1-$boardSize, e.g., 8 10):");
    var indexInput = stdin.readLineSync()!.split(" "); // array of strings
    var newGameURL = net.getPlayURL(gameURL, indexInput);
    var play = net.playResponse(gameURL);
    try {
        while(!(play['response'])){
          if(indexInput.length != 2){
            print("Invalid index!");
          }else if((play['reason']) == "Place not empty,(${indexInput[0]},${indexInput[1]})"){
            print("Not empty!");
          }
          stdout.write('Enter x and y (1-15, e.g., 8 10): ');
          indexInput = (stdin.readLineSync())!.split(" ");
          newGameURL = net.getPlayURL(gameURL, indexInput);
          play = net.playResponse(gameURL);
        }
      } on FormatException {
        print("Invalid Index!");
        promptMove(boardSize, gameURL);
      }
  }

  showBoard(size) {
    var board = Board(size);
    print(board);
  }
}
// make a parsing class
import 'dart:convert';
import 'move.dart';

//MODEL
///Class [JSONParser] parses JSON code 
class JSONParser {
  ///Function [parse] parses responses
  parse(response) {
    return json.decode(response.body);
  }

  ///Function [parseWinningLine] parses the board's winning line
  parseWinningLine(List<dynamic> row) {
    var winningLine = [];
    for (int i = 0; i < row.length; i += 2) {
      winningLine.add(Move(row[i], row[i + 1]));
    }
    return winningLine;
  }
}
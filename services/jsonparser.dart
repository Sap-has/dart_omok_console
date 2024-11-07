// make a parsing class
import 'dart:convert';
import '../models/move.dart';

class JSONParser {
  parse(response) {
    return json.decode(response.body);
  }

  parseWinningLine(List<dynamic> row) {
    var winningLine = [];
    for (int i = 0; i < row.length; i += 2) {
      winningLine.add(Move(row[i], row[i + 1]));
    }
    return winningLine;
  }
}
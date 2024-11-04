// make a parsing class
import 'dart:convert';

class JSONParser {
  parse(response) {
    return json.decode(response.body);
  }
}
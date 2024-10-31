import 'dart:convert';
import 'dart:io'; 
import 'package:http/http.dart' as http;
import 'package:dart_omok_console/controller.dart';

void main() {
  var game = Controller();
  game.runGame();
}
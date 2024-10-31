import "player.dart";

class Board {
  int size;
  List<List<int>>? boardState;
  var player = Player("1");

  // 0 is empty, 1 is human, 2 is computer
  Board(this.size) {
    boardState = List.generate(size, (_) => List.filled(size, 0)); // 2d array filled with 0 of size 'size'
  }
  
  placeStone(player) {

  }
}
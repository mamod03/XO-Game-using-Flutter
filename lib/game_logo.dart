class Player {
  static const x = 'X';
  static const o = 'O';
  static const empty = '';

  static List<int> playerX = [];
  static List<int> playerO = [];
}

extension ContainsAll on List {
  bool containsAll(int x, int y, [z]) {
    if (z == null)
      return contains(x) && contains(y);
    else
      return contains(x) && contains(y) && contains(z);
  }
}

class Game {
  void playGame(index, String activePlayer) {
    if (activePlayer == 'X')
      Player.playerX.add(index);
    else
      Player.playerO.add(index);
  }

  List<int> winningPattern = [];
  String checkWinner() {
    String winner = '';
    List<List<int>> winningCombinations = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6] // Diagonals
    ];

    for (var combination in winningCombinations) {
      if (combination.every((index) => Player.playerX.contains(index))) {
        winner = 'X';
        winningPattern = combination;
        break;
      } else if (combination.every((index) => Player.playerO.contains(index))) {
        winner = 'O';
        winningPattern = combination;

        break;
      }
    }

    return winner;
  }

  Future<void> autoPlay(String activePlayer) async {
    await Future.delayed(const Duration(milliseconds: 200));
    int index = 0;
    List<int> emptyCells = [];
    for (var i = 0; i < 9; i++) {
      if (!(Player.playerX.contains(i) || Player.playerO.contains(i))) {
        emptyCells.add(i);
      }
    }

    // Prioritize center
    if (emptyCells.contains(4)) {
      index = 4;
    } else {
      // Defend or Attack
      List<List<int>> winPatterns = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
        [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
        [0, 4, 8], [2, 4, 6] // Diagonals
      ];

      for (var pattern in winPatterns) {
        int countX =
            pattern.where((index) => Player.playerX.contains(index)).length;
        int countO =
            pattern.where((index) => Player.playerO.contains(index)).length;
        int empty = pattern.where((index) => emptyCells.contains(index)).length;

        // Block or win
        if (countX == 2 && empty == 1) {
          index = pattern.firstWhere((index) => emptyCells.contains(index));
          break;
        } else if (countO == 2 && empty == 1) {
          index = pattern.firstWhere((index) => emptyCells.contains(index));
          break;
        }
      }

      // If no immediate win or block, choose a corner
      if (index == 0 && emptyCells.isNotEmpty) {
        List<int> corners = [0, 2, 6, 8];
        index = corners.firstWhere((corner) => emptyCells.contains(corner),
            orElse: () => emptyCells[0]);
      }
    }

    // Make the move
    if (emptyCells.contains(index)) {
      if (activePlayer == 'O') {
        Player.playerO.add(index);
      } else {
        Player.playerX.add(index);
      }
      ;
    }
  }
}

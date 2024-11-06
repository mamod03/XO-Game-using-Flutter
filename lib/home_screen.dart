import 'package:flutter/material.dart';
import 'package:xo_Game/game_logo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activePlayer = 'X';
  bool gameOver = false;
  int turn = 0;
  String result = '==========';
  Game game = Game();
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
          child: MediaQuery.of(context).orientation == Orientation.landscape
              ? Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ...firstBlock(),
                          const SizedBox(
                            height: 50,
                          ),
                          ...lastBlock()
                        ],
                      ),
                    ),
                    Expanded(
                        child: Column(
                      children: [
                        Expanded(
                            child: Container(
                          height: 300,
                          width: 350,
                          child: GridView.count(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(16),
                            crossAxisCount: 3,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 1,
                            children: List.generate(9, (index) {
                              return InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: gameOver ? null : () => onTap(index),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).shadowColor,
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Center(
                                    child: Text(
                                      Player.playerX.contains(index)
                                          ? 'X'
                                          : Player.playerO.contains(index)
                                              ? 'O'
                                              : '',
                                      style: TextStyle(
                                          fontSize: 75,
                                          color: Player.playerX.contains(index)
                                              ? Colors.blue
                                              : Colors.pink),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        )),
                      ],
                    ))
                  ],
                )
              : Column(
                  children: [
                    ...firstBlock(),
                    Expanded(
                        child: GridView.count(
                      padding: const EdgeInsets.all(16),
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1,
                      children: List.generate(9, (index) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: gameOver ? null : () => onTap(index),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).shadowColor,
                                borderRadius: BorderRadius.circular(16)),
                            child: Center(
                              child: Text(
                                Player.playerX.contains(index)
                                    ? 'X'
                                    : Player.playerO.contains(index)
                                        ? 'O'
                                        : '',
                                style: TextStyle(
                                    fontSize: 89,
                                    color: Player.playerX.contains(index)
                                        ? Colors.blue
                                        : Colors.pink),
                              ),
                            ),
                          ),
                        );
                      }),
                    )),
                    ...lastBlock()
                  ],
                )),
    );
  }

  List<Widget> firstBlock() {
    return [
      SwitchListTile.adaptive(
          title: const Text(
            'Turn on/off two players',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 28),
          ),
          value: isSwitched,
          onChanged: (val) {
            setState(() {
              isSwitched = val;
              activePlayer == 'X';
              gameOver = false;
              turn = 0;
              result = '==========';
              Player.playerO.clear();
              Player.playerX.clear();
            });
          }),
      Text(
        gameOver ? '' : "It's $activePlayer turn".toUpperCase(),
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 52),
      ),
    ];
  }

  List<Widget> lastBlock() {
    return [
      Text(
        result,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 42),
      ),
      ElevatedButton.icon(
        onPressed: () {
          setState(() {
            activePlayer = 'X';
            gameOver = false;
            turn = 0;
            result = '';
            Player.playerO.clear();
            Player.playerX.clear();
          });
        },
        label: const Text('Replay the game'),
        icon: const Icon(Icons.replay),
        style: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.all(Theme.of(context).splashColor),
        ),
      )
    ];
  }

  onTap(index) async {
    if (activePlayer == 'X' || isSwitched) {
      if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
          (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
        game.playGame(index, activePlayer);

        updateState();

        if (!isSwitched && !gameOver && turn != 9) {
          await game.autoPlay(activePlayer);
          updateState();
        }
      }
    }
  }

  void updateState() {
    setState(() {
      activePlayer = activePlayer == 'X' ? 'O' : 'X';
      turn++;
      String winnerPlayer = game.checkWinner();
      if (winnerPlayer != '') {
        gameOver = true;
        result = '$winnerPlayer is the Winner';
      } else if (!gameOver && turn == 9) {
        result = "it's Draw!";
        gameOver = true;
      }
    });
  }
}

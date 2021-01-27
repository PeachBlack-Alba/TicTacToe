import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Components/CustomDialog.dart';
import 'Components/gameButton.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GameButton> buttonsList;
  var player1;
  var player2;
  var activePlayer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buttonsList = doInitalitation();
  }

  List<GameButton> doInitalitation() {
    player1 = List();
    player2 = List();
    activePlayer = 1;
    var gameButtons = <GameButton>[
      GameButton(id: 1),
      GameButton(id: 2),
      GameButton(id: 3),
      GameButton(id: 4),
      GameButton(id: 5),
      GameButton(id: 6),
      GameButton(id: 7),
      GameButton(id: 8),
      GameButton(id: 9),
    ];
    return gameButtons;
  }

  void PlayGame(GameButton gb) {
    setState(() {
      if (activePlayer == 1) {
        gb.text = 'X';
        gb.background = Colors.black;
        // change player to 2
        activePlayer = 2;
        player1.add(gb.id);
      } else {
        gb.text = '0';
        gb.background = Colors.redAccent;
        // change player again to 1
        activePlayer = 1;
        // We want to add the button to the list
        player2.add(gb.id);
      }
      // button now should be desabled so its not clickable
      gb.enabled = false;
      // check winner
      int winner = checkWinner();
      if (winner == -1) {
        // if the buttonList is = '' means is empate
        if (buttonsList.every((e) => e.text != '')) {
          showDialog(context: context, builder: (_) => CustomDialog('Both are winners', 'Press restart button to play again', resetGame));
        }else{
          activePlayer == 2? autoGame(): null;
        }
      }
    });
  }

  void autoGame (){
    var emptyCells = List();
    var list = List.generate(9, (index) => index +1 );
    for (var cellID in list){
      if(!(player1.contains (cellID) || player2.contains(cellID))){
        emptyCells.add(cellID);
      }
    }
    var random = Random();
    var randomIndex = random.nextInt(emptyCells.length-1);
    var cellID = emptyCells[randomIndex];
    int i = buttonsList.indexWhere((e) => e.id == cellID);
    PlayGame (buttonsList[i]);
  }

  int checkWinner() {
    var winner = -1;
    if (player1.contains(1) && player1.contains(2) && player1.contains(3)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(2) && player2.contains(3)) {
      winner = 2;
    }

    // row 2
    if (player1.contains(4) && player1.contains(5) && player1.contains(6)) {
      winner = 1;
    }
    if (player2.contains(4) && player2.contains(5) && player2.contains(6)) {
      winner = 2;
    }

    // row 3
    if (player1.contains(7) && player1.contains(8) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(7) && player2.contains(8) && player2.contains(9)) {
      winner = 2;
    }

    // col 1
    if (player1.contains(1) && player1.contains(4) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(4) && player2.contains(7)) {
      winner = 2;
    }

    // col 2
    if (player1.contains(2) && player1.contains(5) && player1.contains(8)) {
      winner = 1;
    }
    if (player2.contains(2) && player2.contains(5) && player2.contains(8)) {
      winner = 2;
    }

    // col 3
    if (player1.contains(3) && player1.contains(6) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(6) && player2.contains(9)) {
      winner = 2;
    }

    //diagonal
    if (player1.contains(1) && player1.contains(5) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(5) && player2.contains(9)) {
      winner = 2;
    }

    if (player1.contains(3) && player1.contains(5) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(5) && player2.contains(7)) {
      winner = 2;
    }
    if (winner != -1) {
      if (winner == 1) {
        showDialog(context: context, builder: (_) => CustomDialog('Player 1 is the winner', 'Press Restart to play again', resetGame));
      } else {
        showDialog(context: context, builder: (_) => CustomDialog('Player 2 is the winner', 'Press Restart to play again', resetGame));
      }
    }
    return winner;
  }

  void resetGame() {
    if (Navigator.canPop(context)) Navigator.pop(context);
    setState(() {
      buttonsList = doInitalitation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('TicTacToe')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 9.0,
                mainAxisSpacing: 9.0,
              ),
              itemCount: buttonsList.length,
              itemBuilder: (context, index) => SizedBox(
                width: 100,
                height: 100,
                child: RaisedButton(
                  padding: EdgeInsets.all(8.0),
                  onPressed: buttonsList[index].enabled ? () => PlayGame(buttonsList[index]) : null,
                  child: Text(
                    buttonsList[index].text,
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                  color: buttonsList[index].background,
                  disabledColor: buttonsList[index].background,
                ),
              ),
            ),
          ),
          RaisedButton(
            child: Text(
              'Restart',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            color: Colors.black,
            padding: EdgeInsets.all(20),
            onPressed: resetGame,
          )
        ],
      ),
    );
  }
}

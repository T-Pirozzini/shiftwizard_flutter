import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:shift_wizard_flutter/shift_wizard.dart';
import 'dart:math';

import '/utility/sprite_utils.dart';
import '/utility/tiles_info.dart';

// void main() {
//   print('start game');
//   runApp(GameWidget(
//     game: ShiftWizard(),
//   ));
// }

// class ShiftWizard extends FlameGame {
//   @override
//   Future<void> onLoad() async {
//     final spriteSize = Vector2.all(200);
//     for (var imagePath in tilesInfo.keys) {
//       final positions = tilesInfo[imagePath]?['positions'] as List<Vector2>;
//       final stepTime = tilesInfo[imagePath]?['stepTime'] as double;
//       final sprites = await loadSprites(
//           images, imagePath, positions, Vector2(64, 64));
//       final animation = SpriteAnimation.spriteList(sprites, stepTime: stepTime);
//       final component = SpriteAnimationComponent(
//         animation: animation,
//         position: (size - spriteSize) / 2,
//         size: spriteSize,
//       );
//       add(component);
//     }
//   }
// }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  ShiftWizard game = ShiftWizard();
  runApp(GameWidget(game: kDebugMode ? ShiftWizard(): game));
}

class ShiftWizardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shift Wizard',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late List<Tile> board;

  Player player1 = Player('Wizard 1');
  Player player2 = Player('Wizard 2');
  Player? currentPlayer;
  bool initialTileSelection = true;

  @override
  void initState() {
    super.initState();

    currentPlayer = player1;
    board = generateBoard();
  }

  List<Tile> generateBoard() {
    List<TileType> deck = generateDeck();

    return List.generate(25, (index) {
      if (index == 12) {
        return Tile(type: TileType.Crystal);
      }
      return Tile(type: deck.removeLast());
    });
  }

  List<TileType> generateDeck() {
    List<TileType> deck = List.generate(10, (index) => TileType.Yellow)
      ..addAll(List.generate(10, (index) => TileType.Red))
      ..addAll(List.generate(10, (index) => TileType.Green));

    deck.shuffle();

    return deck;
  }

  void _handleTileTap(int index) {
    // Check if it's the initial tile selection
    if (initialTileSelection) {
      // Ensure the tapped tile is a perimeter tile
      if (index < 5 || index % 5 == 0 || index % 5 == 4 || index > 19) {
        currentPlayer!.currentPosition = index;
        currentPlayer!.collectedElement = board[index].type;
        _swapPlayers(); // Swap the turn to the other player

        if (currentPlayer == player1) {
          // If it's back to player 1, end initial selection phase
          initialTileSelection = false;
        }
        setState(() {}); // Rebuild to reflect changes in UI
        return;
      }
    }

    // Regular game move logic (outside the initialTileSelection conditional)
    if (_isAdjacent(currentPlayer!.currentPosition!, index)) {
      currentPlayer!.currentPosition = index;
      currentPlayer!.collectedElement = board[index].type;

      if (board[index].type == TileType.Crystal) {
        _showVictoryDialog(currentPlayer!.name);
      } else {
        _swapPlayers(); // Swap the turn to the other player
      }
      setState(() {}); // Rebuild to reflect changes in UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shift Wizard'),
        actions: [
          Row(
            children: [
              Text(
                '${player1.name}: ${player1.collectedElement ?? 'None'}',
              ),
              SizedBox(width: 20),
              Text(
                '${player2.name}: ${player2.collectedElement ?? 'None'}',
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${currentPlayer!.name}\'s turn',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
              ),
              itemCount: board.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _handleTileTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      border: (index == player1.currentPosition ||
                              index == player2.currentPosition)
                          ? Border.all(color: Colors.black, width: 3)
                          : null,
                    ),
                    child: board[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _isAdjacent(int currentPosition, int selectedIndex) {
    List<int> adjacentIndices = [
      currentPosition - 5, // tile above
      currentPosition + 5, // tile below
      currentPosition - 1, // tile to the left
      currentPosition + 1 // tile to the right
    ];

    // Check for edge cases: If on the left edge, remove left tile, if on the right edge, remove right tile
    if (currentPosition % 5 == 0) {
      adjacentIndices.remove(currentPosition - 1);
    } else if ((currentPosition + 1) % 5 == 0) {
      adjacentIndices.remove(currentPosition + 1);
    }

    return adjacentIndices.contains(selectedIndex);
  }

  void _swapPlayers() {
    print("Swapping players. Current player: ${currentPlayer!.name}");
    currentPlayer = (currentPlayer == player1) ? player2 : player1;
    print("New current player: ${currentPlayer!.name}");
  }

  void _showVictoryDialog(String winnerName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Victory!'),
        content: Text('$winnerName wins!'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              // Optionally, reset the game or navigate elsewhere
            },
          ),
        ],
      ),
    );
  }
}

class Tile extends StatelessWidget {
  final TileType type;

  Tile({required this.type});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (type) {
      case TileType.Red:
        color = Colors.red;
        break;
      case TileType.Green:
        color = Colors.green;
        break;
      case TileType.Crystal:
        color = Colors.blue;
        break;
      default:
        color = Colors.yellow;
        break;
    }

    return Container(
      color: color,
      margin: EdgeInsets.all(2.0),
    );
  }
}

enum TileType { Yellow, Red, Green, Crystal }

class Player {
  final String name;
  TileType? collectedElement;
  int? currentPosition;

  Player(this.name);
}

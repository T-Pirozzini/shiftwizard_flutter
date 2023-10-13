// import 'package:flame/components.dart';
// import 'package:flame/sprite.dart';

// import 'package:flame_texturepacker/flame_texturepacker.dart';
// import 'package:flame/flame.dart';
// import 'package:flame/sprite.dart';
// import 'package:flame/extensions.dart'; // For Vector2
// import 'package:flame/animation.dart' as flame_animation;
// import 'package:flame/game.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
// import 'package:examples/commons/ember.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

void main() {
  print('start game');
  runApp(GameWidget(
    game: AsepriteExample(),
  ));
}

class AsepriteExample extends FlameGame {
  static const String description = '''
    This example shows how to load animations from an Aseprite json file and a
    sprite sheet. There is no interaction on this example.
  ''';

  @override
  Future<void> onLoad() async {
    // final chopperImage = await images.load('chopper.png');
    // final chopperJsonData = await assets.readJson('chopper.json');
    // final chopperAnimation =
    //     SpriteAnimation.fromAsepriteData(chopperImage, chopperJsonData);
    final spriteSize = Vector2.all(200);
    // final chopperComponent = SpriteAnimationComponent(
    //   animation: chopperAnimation,
    //   position: (size - spriteSize) / 2,
    //   size: spriteSize,
    // );
    // add(chopperComponent);

    final wizardImage = await images.load('wizard.png');    
    final sprite1 = Sprite(wizardImage,
        srcPosition: Vector2(0, 0), srcSize: Vector2(64, 64));
    final sprite2 = Sprite(wizardImage,
        srcPosition: Vector2(64, 0), srcSize: Vector2(64, 64));
    final sprite3 = Sprite(wizardImage,
        srcPosition: Vector2(128, 0), srcSize: Vector2(64, 64));
    final sprite4 = Sprite(wizardImage,
        srcPosition: Vector2(192, 0), srcSize: Vector2(64, 64));
    final sprite5 = Sprite(wizardImage,
        srcPosition: Vector2(256, 0), srcSize: Vector2(64, 64));
    final sprite6 = Sprite(wizardImage,
        srcPosition: Vector2(320, 0), srcSize: Vector2(64, 64));
    final sprites = [sprite1, sprite2, sprite3, sprite4, sprite5, sprite6];

    final wizardAnimation = SpriteAnimation.spriteList(sprites, stepTime: .1);
    final wizardComponent = SpriteAnimationComponent(
      animation: wizardAnimation,
      position: (size - spriteSize) / 2,
      size: spriteSize,
    );
    add(wizardComponent);
  }
}

// class MySpriteTutorial extends FlameGame {
//   late Image wizard;
//   late SpriteAnimation animation;

//   @override
//   Future<void> onLoad() async {
//     wizard = await images.load('assets/wizard1_sprite.png');

//     animation = await loadSpriteAnimation(
//       'assets/wizard1_spritesheet.png',
//       SpriteAnimationData.sequenced(
//         amount: 4,
//         textureSize: Vector2.all(48),
//         stepTime: 0.15,
//       ),
//     );

//     final spriteSize = Vector2.all(100.0);
//     final animationComponent = SpriteAnimationComponent(
//       animation: animation,
//       position: Vector2(-spriteSize.x, 0),
//       size: spriteSize,
//       anchor: Anchor.center,
//     );

//     final reversedAnimationComponent = SpriteAnimationComponent(
//       animation: animation.reversed(),
//       position: Vector2(spriteSize.x, 0),
//       size: spriteSize,
//       anchor: Anchor.center,
//     );

//     add(animationComponent);
//     add(reversedAnimationComponent);    

//     return super.onLoad();
//   }

//   @override
//   void onTapDown(TapDownEvent event) {
//     final size = Vector2(291, 178);

//     final animationComponent = SpriteAnimationComponent.fromFrameData(
//       wizard,
//       SpriteAnimationData.sequenced(
//         amount: 18,
//         amountPerRow: 10,
//         textureSize: size,
//         stepTime: 0.15,
//         loop: false,
//       ),
//       position: event.localPosition,
//       anchor: Anchor.center,
//       size: size,
//       removeOnFinish: true,
//     );

//     add(animationComponent);
//   }
// }

// void main() {
//   runApp(ShiftWizardApp());
// }

// class ShiftWizardApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Shift Wizard',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: GameScreen(),
//     );
//   }
// }

// class GameScreen extends StatefulWidget {
//   @override
//   _GameScreenState createState() => _GameScreenState();
// }

// class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
//   late List<Tile> board;

//   Player player1 = Player('Wizard 1', 'assets/wizard1_sprite.png');
//   Player player2 = Player('Wizard 2', 'assets/wizard2_sprite.png');
//   Player? currentPlayer;
//   bool initialTileSelection = true;

//   late SpriteAnimation _wizardAnimation;

//   late AnimationController _spriteAnimationController;
//   late Image _spriteSheetImage;
//   Sprite? wizardSprite;

//   void loadSprites() async {
//     final spriteSheet = await SpriteSheet.load(
//         'assets/wizard_spritesheet.png', // path to your spritesheet
//         'assets/wizard_spritesheet.json' // path to your JSON file
//         );
//     final wizardAnimation = spriteSheet.createAnimation(
//         from: 0, // starting frame index
//         to: 3, // ending frame index
//         stepTime: 0.1 // time duration for each frame
//         );
//   }

//   bool assetsLoaded =
//       false; // Declare this variable at the beginning of your _GameScreenState class.

//   @override
//   void initState() {
//     super.initState();

//     _spriteAnimationController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 1), // or whatever duration you need
//     )..repeat(); // this will make the animation run continuously

//     currentPlayer = player1;
//     board = generateBoard();
//     loadWizardSprite();

//     /// Load the sprite sheet
//     loadSprites();
//   }

//   Future<void> loadWizardSprite() async {
//     wizardSprite = await Sprite.load('wizard1_sprite.png');
//     setState(() {});
//   }

//   void loadSprites() async {
//     final spriteSheet = SpriteSheet(
//       image: await Flame.images.load('wizard2_sprite.png'),
//       srcSize: Vector2(10, 10), // Frame size
//     );

//     _wizardAnimation = spriteSheet.createAnimation(row: 0, stepTime: 0.0625);

//     setState(() {
//       assetsLoaded = true;
//     });
//   }

//   List<Tile> generateBoard() {
//     List<TileType> deck = generateDeck();

//     return List.generate(25, (index) {
//       if (index == 12) {
//         return Tile(type: TileType.Crystal);
//       }
//       return Tile(type: deck.removeLast());
//     });
//   }

//   List<TileType> generateDeck() {
//     List<TileType> deck = List.generate(10, (index) => TileType.Yellow)
//       ..addAll(List.generate(10, (index) => TileType.Red))
//       ..addAll(List.generate(10, (index) => TileType.Green));

//     deck.shuffle();

//     return deck;
//   }

//   void _handleTileTap(int index) {
//     // Check if it's the initial tile selection
//     if (initialTileSelection) {
//       // Ensure the tapped tile is a perimeter tile
//       if (index < 5 || index % 5 == 0 || index % 5 == 4 || index > 19) {
//         currentPlayer!.currentPosition = index;
//         currentPlayer!.collectedElement = board[index].type;
//         _swapPlayers(); // Swap the turn to the other player

//         if (currentPlayer == player1) {
//           // If it's back to player 1, end initial selection phase
//           initialTileSelection = false;
//         }
//         setState(() {}); // Rebuild to reflect changes in UI
//         return;
//       }
//     }

//     // Regular game move logic (outside the initialTileSelection conditional)
//     if (_isAdjacent(currentPlayer!.currentPosition!, index)) {
//       currentPlayer!.currentPosition = index;
//       currentPlayer!.collectedElement = board[index].type;

//       if (board[index].type == TileType.Crystal) {
//         _showVictoryDialog(currentPlayer!.name);
//       } else {
//         _swapPlayers(); // Swap the turn to the other player
//       }
//       setState(() {}); // Rebuild to reflect changes in UI
//     }
//   }

//   @override
//   void dispose() {
//     _spriteAnimationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Shift Wizard'),
//         actions: [
//           Row(
//             children: [
//               Text(
//                 '${player1.name}: ${player1.points} (${player1.collectedElement ?? 'None'})',
//               ),
//               SizedBox(width: 20),
//               Text(
//                 '${player2.name}: ${player2.points} (${player2.collectedElement ?? 'None'})',
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               '${currentPlayer!.name}\'s turn',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: AnimatedBuilder(
//               animation: _spriteAnimationController,
//               builder: (context, child) {
//                 int frameIndex =
//                     (_spriteAnimationController.value * 16).floor();
//                 // Ensure that the frame index does not exceed the total number of frames.
//                 frameIndex = frameIndex.clamp(0, 15);
//                 // Get the sprite frame from the animation using the frame index.
//                 Sprite? frame;
//                 if (!assetsLoaded) {
//                   return Container(); // or any placeholder
//                 }

//                 if (_wizardAnimation != null &&
//                     _wizardAnimation!.frames.length > frameIndex) {
//                   frame = _wizardAnimation!
//                       .frames[frameIndex].sprite; // Note the additional .sprite
//                 }

//                 return GridView.builder(
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 5),
//                     itemCount: board.length,
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                         onTap: () => _handleTileTap(index),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             border: (index == player1.currentPosition ||
//                                     index == player2.currentPosition)
//                                 ? Border.all(color: Colors.black, width: 3)
//                                 : null,
//                           ),
//                           child: (index == player1.currentPosition ||
//                                   index == player2.currentPosition)
//                               ? (wizardSprite != null
//                                   ? WizardSpriteWidget(sprite: wizardSprite!)
//                                   : Container())
//                               : board[index],
//                         ),
//                       );
//                     });
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   bool _isAdjacent(int currentPosition, int selectedIndex) {
//     List<int> adjacentIndices = [
//       currentPosition - 5, // tile above
//       currentPosition + 5, // tile below
//       currentPosition - 1, // tile to the left
//       currentPosition + 1 // tile to the right
//     ];

//     // Check for edge cases: If on the left edge, remove left tile, if on the right edge, remove right tile
//     if (currentPosition % 5 == 0) {
//       adjacentIndices.remove(currentPosition - 1);
//     } else if ((currentPosition + 1) % 5 == 0) {
//       adjacentIndices.remove(currentPosition + 1);
//     }

//     return adjacentIndices.contains(selectedIndex);
//   }

//   void _swapPlayers() {
//     print("Swapping players. Current player: ${currentPlayer!.name}");
//     currentPlayer = (currentPlayer == player1) ? player2 : player1;
//     print("New current player: ${currentPlayer!.name}");
//   }

//   void _showVictoryDialog(String winnerName) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Victory!'),
//         content: Text('$winnerName wins!'),
//         actions: [
//           TextButton(
//             child: Text('OK'),
//             onPressed: () {
//               Navigator.of(context).pop();
//               // Optionally, reset the game or navigate elsewhere
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Tile extends StatefulWidget {
//   final TileType
//       type; // This will represent the type of the tile (Yellow, Red, Green, or Crystal)

//   Tile({this.type = TileType.Yellow}); // Default to Yellow for now

//   @override
//   _TileState createState() => _TileState();
// }

// class _TileState extends State<Tile> {
//   @override
//   Widget build(BuildContext context) {
//     Color color;
//     switch (widget.type) {
//       case TileType.Red:
//         color = Colors.red;
//         break;
//       case TileType.Green:
//         color = Colors.green;
//         break;
//       case TileType.Crystal:
//         color = Colors.blue;
//         break;
//       default:
//         color = Colors.yellow;
//         break;
//     }

//     return Container(
//       color: color,
//       margin: EdgeInsets.all(2.0),
//     );
//   }
// }

// enum TileType { Yellow, Red, Green, Crystal }

// class Player {
//   final String name;
//   final String spriteAsset;
//   int points = 0;
//   TileType? collectedElement;
//   int? currentPosition; // the index on the board

//   Player(this.name, this.spriteAsset);
// }

// class SpritePainter extends CustomPainter {
//   final Sprite sprite;

//   SpritePainter({required this.sprite});

//   @override
//   void paint(Canvas canvas, Size size) {
//     sprite.render(canvas,
//         position: Vector2(0, 0), size: Vector2(size.width, size.height));
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false; // for simplicity, but might need conditions based on your requirements.
//   }
// }

// class WizardSpriteWidget extends StatelessWidget {
//   final Sprite sprite;

//   WizardSpriteWidget({required this.sprite});

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: _SpritePainter(sprite),
//       child:
//           Container(), // This can be an empty container, just to give the CustomPaint a child.
//     );
//   }
// }

// class _SpritePainter extends CustomPainter {
//   final Sprite sprite;

//   _SpritePainter(this.sprite);

//   @override
//   void paint(Canvas canvas, Size size) {
//     sprite.render(canvas, position: Vector2(0, 0), size: size.toVector2());
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false; // In most cases, this won't need to repaint. Adjust if needed.
//   }
// }

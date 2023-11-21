import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:shift_wizard_flutter/components/gameboard.dart';
import 'package:shift_wizard_flutter/components/parallax.dart';
import 'package:shift_wizard_flutter/components/play_area.dart';
import 'package:shift_wizard_flutter/components/tile.dart';
import 'package:shift_wizard_flutter/hud.dart';
import 'package:flame/text.dart';

class ShiftWizardGame extends FlameGame {
  late GameBoard gameBoard;
  late CollectedCardDisplay collectedCardDisplay;
  late HUD hud;

  @override
  bool debugMode = false;

  ShiftWizardGame()
      : super(
          camera: CameraComponent.withFixedResolution(width: 400, height: 1024),
          world: HUD(),
        ) {}

  // Player turn indicator
  int currentPlayer = 1; // Start with player 1

  // Method to switch turns
  void switchTurn() {
    currentPlayer = currentPlayer == 1 ? 2 : 1;
  }

  void handleTileTap(int index) {
    // Assuming 'tiles' is your list of Tile objects
    Tile selectedTile = gameBoard.tiles[index];

    // Collect the card for the current player
    if (currentPlayer == 1) {
      // Collect the card for Player 1
      // Display it above the gameboard
      // ...
      print("Tile $index tapped!");
    } else {
      // Collect the card for Player 2
      // Display it above the gameboard
      // ...
      print("Tile $index tapped!");
    }

    // Switch turns after collecting the card
    switchTurn();
  }

  void handleTileInteraction(Tile tile) {
    print(tile); // Print the tile's object ID
    print('tile tapped!! in shiftwizard_game'); // Print the tile's object ID
    // Logic when a tile is tapped
    // You can access the tile's properties here, e.g., tile.tileType
    // and implement logic based on the current player
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(MyParallaxComponent());
    Vector2 tileSize = Vector2(
      // Define the tile size // Set the width and height for each tile
      50.0, 50.0,
    );

    gameBoard = GameBoard(5, 5, tileSize,
        handleTileInteraction); // Create an instance of GameBoard
    // After creating the gameBoard, set its position to center it
    Vector2 boardSize = Vector2(
      gameBoard.columns * (tileSize.x + gameBoard.spacing), // Total width
      gameBoard.rows * (tileSize.y + gameBoard.spacing), // Total height
    );
    gameBoard.position = (size - boardSize) / 2; // Center the gameBoard
    add(gameBoard); // Add the gameBoard to the FlameGame

    collectedCardDisplay = CollectedCardDisplay();
    add(collectedCardDisplay);

    hud = HUD();
    add(hud);

    final textRenderer = TextPaint(
      style: TextStyle(fontSize: 25, color: BasicPalette.white.color),
    );
    camera.viewfinder.add(
      TextButton(
        text: 'Play Again?',
        textRenderer: textRenderer,
        position: Vector2(0, 400),
        anchor: Anchor.center,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Update your game state
  }

  // Other game logic methods...
}

class TextButton extends ButtonComponent {
  TextButton({
    required String text,
    required super.position,
    super.anchor,
    TextRenderer? textRenderer,
  }) : super(
          button: RectangleComponent(
            size: Vector2(200, 100),
            paint: Paint()
              ..color = Colors.orange
              ..strokeWidth = 2
              ..style = PaintingStyle.stroke,
          ),
          buttonDown: RectangleComponent(
            size: Vector2(200, 100),
            paint: Paint()..color = BasicPalette.orange.color.withOpacity(0.5),
          ),
          children: [
            TextComponent(
              text: text,
              textRenderer: textRenderer,
              position: Vector2(100, 50),
              anchor: Anchor.center,
            ),
          ],
        );
}

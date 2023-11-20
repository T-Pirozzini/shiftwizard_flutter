import 'package:flame/game.dart';
import 'package:shift_wizard_flutter/components/gameboard.dart';

class ShiftWizardGame extends FlameGame {
  late GameBoard gameBoard;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    Vector2 tileSize = Vector2(
      // Define the tile size
      // Set the width and height for each tile
      50.0, 50.0,
    );
    gameBoard = GameBoard(5, 5, tileSize); // Create an instance of GameBoard
    // After creating the gameBoard, set its position to center it
    Vector2 boardSize = Vector2(
      gameBoard.columns * (tileSize.x + gameBoard.spacing), // Total width
      gameBoard.rows * (tileSize.y + gameBoard.spacing), // Total height
    );
    gameBoard.position = (size - boardSize) / 2; // Center the gameBoard
    add(gameBoard); // Add the gameBoard to the FlameGame
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Update your game state
  }

  void handleTileTap(int index) {
    // Handle tile tap interactions
  }

  // Other game logic methods...
}

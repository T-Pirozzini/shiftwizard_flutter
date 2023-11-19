import 'package:flame/game.dart';
import 'package:shift_wizard_flutter/gameboard.dart';

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

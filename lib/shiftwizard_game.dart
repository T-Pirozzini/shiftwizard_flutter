import 'package:flame/game.dart';
import 'package:shift_wizard_flutter/components/gameboard.dart';
import 'package:shift_wizard_flutter/components/play_area.dart';
import 'package:shift_wizard_flutter/components/tile.dart';

class ShiftWizardGame extends FlameGame {
  late GameBoard gameBoard;

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

  late CollectedCardDisplay collectedCardDisplay;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    Vector2 tileSize = Vector2(
      // Define the tile size // Set the width and height for each tile
      50.0, 50.0,
    );

    gameBoard = GameBoard(5, 5, tileSize, handleTileInteraction); // Create an instance of GameBoard
    // After creating the gameBoard, set its position to center it
    Vector2 boardSize = Vector2(
      gameBoard.columns * (tileSize.x + gameBoard.spacing), // Total width
      gameBoard.rows * (tileSize.y + gameBoard.spacing), // Total height
    );
    gameBoard.position = (size - boardSize) / 2; // Center the gameBoard
    add(gameBoard); // Add the gameBoard to the FlameGame

    collectedCardDisplay = CollectedCardDisplay();
    add(collectedCardDisplay);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Update your game state
  }

  // Other game logic methods...
}

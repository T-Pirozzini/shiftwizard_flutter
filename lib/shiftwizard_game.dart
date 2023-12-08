import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:shift_wizard_flutter/components/gameboard.dart';
import 'package:shift_wizard_flutter/components/parallax.dart';
import 'package:shift_wizard_flutter/components/player.dart';
import 'package:shift_wizard_flutter/components/stored_cards.dart';
import 'package:shift_wizard_flutter/components/stored_points.dart';
import 'package:shift_wizard_flutter/components/tile.dart';
import 'package:shift_wizard_flutter/components/level.dart';

enum MoveEffectDirection { up, down, left, right }

class ShiftWizardGame extends FlameGame with TapDetector, DragCallbacks {
  late GameBoard gameBoard;

  @override
  bool debugMode = false;
  late final CameraComponent cam;
  late Player player1;
  late Player player2;
  late JoystickComponent joystick;

  // Player turn indicator
  List<Tile> player1Collection = [];
  List<Tile> player1PointsCollection = [];
  List<Tile> player2Collection = [];
  List<Tile> player2PointsCollection = [];
  int currentPlayer = 1; // Start with player 1

  // Stored elements display
  late StoredElementsDisplay p1StoredElementsDisplay;
  late StoredElementsDisplay p2StoredElementsDisplay;
  late StoredPointsDisplay p1StoredPointsDisplay;
  late StoredPointsDisplay p2StoredPointsDisplay;

  late TextComponent playerTurnText;

  Point<int>? lastCollectedPositionPlayer1;
  Point<int>? lastCollectedPositionPlayer2;

  bool isFirstRound = true;
  bool isSpellPhase = true;

  @override
  Future<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();

    // final world = Level(player: player1);

    cam = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 360);
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, world]);

    add(MyParallaxComponent());

    playerTurnText = TextComponent(
      text: '', // Initial empty text
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(playerTurnText);
    updatePlayerTurnText();

    // Initialize the stored elements display
    p1StoredElementsDisplay = StoredElementsDisplay(
      player1Collection,
      tileSize: Vector2(60, 60),
      'Player 1',
    )..position = Vector2(20, 10); // Position on the right side of the screen
    add(p1StoredElementsDisplay);
    p2StoredElementsDisplay = StoredElementsDisplay(
      player2Collection,
      tileSize: Vector2(60, 60),
      'Player 2',
    )..position = Vector2(640, 10); // Position on the right side of the screen
    add(p2StoredElementsDisplay);

    p1StoredPointsDisplay = StoredPointsDisplay(
      player1PointsCollection,
      tileSize: Vector2(60, 60),
      'Player 1',
    )..position = Vector2(20, 30); // Position on the right side of the screen
    add(p1StoredPointsDisplay);
    p2StoredPointsDisplay = StoredPointsDisplay(
      player2PointsCollection,
      tileSize: Vector2(60, 60),
      'Player 2',
    )..position = Vector2(640, 30); // Position on the right side of the screen
    add(p2StoredPointsDisplay);

    super.onLoad();

    Vector2 tileSize = Vector2(
      // Define the tile size // Set the width and height for each tile
      50.0, 50.0,
    );

    gameBoard = GameBoard(
        5, 5, tileSize, handleTileTap); // Create an instance of GameBoard
    // After creating the gameBoard, set its position to center it
    Vector2 boardSize = Vector2(
      gameBoard.columns * (tileSize.x + gameBoard.spacing), // Total width
      gameBoard.rows * (tileSize.y + gameBoard.spacing), // Total height
    );
    gameBoard.position = (size - boardSize) / 2; // Center the gameBoard
    add(gameBoard); // Add the gameBoard to the FlameGame

    player1 = Player();
    player1.position = Vector2(220, 30);
    add(player1);
    player2 = Player();
    player2.position = Vector2(600, 30);
    add(player2);

    giveRandomTileToPlayer(player1);
    giveRandomTileToPlayer(player2);

    addJoystick();
  }

  @override
  void update(double dt) {
    updateJoystick();
    super.update(dt);
  }

  void giveRandomTileToPlayer(Player player) {
    var randomTileType = getRandomTileType();
    var tile = Tile(tileType: randomTileType, onTileTapped: handleTileTap);
    tile.isStoredCard = true; // Indicate that this is a stored card
    player.storedElements.add(tile);
    if (player == player1) {
      player1Collection.add(tile);
      p1StoredElementsDisplay.updateDisplay();
    } else if (player == player2) {
      player2Collection.add(tile);
      p2StoredElementsDisplay.updateDisplay();
    }
  }

  TileType getRandomTileType() {
    var rng = Random();
    switch (rng.nextInt(3)) {
      case 0:
        return TileType.red;
      case 1:
        return TileType.yellow;
      case 2:
        return TileType.green;
      default:
        return TileType.red; // Fallback, should not be reached
    }
  }

  // Method to switch turns
  void switchTurn() {
    currentPlayer = currentPlayer == 1 ? 2 : 1;
    isSpellPhase = true; // Reset for the new player's turn
    updatePlayerTurnText();
  }

  void handleTileTap(Tile tile) {
    Point<int>? tilePosition = gameBoard.tilePositions[tile];
    if (tilePosition == null) return;

    // if (isSpellPhase) {
    //   // Don't proceed with tile collection, waiting for spell phase to complete
    //   return;
    // }
    // Check if it's the first round
    if (isFirstRound) {
      if (currentPlayer == 2) {
        isFirstRound = false;
      }
      if (!isTileOnPerimeter(tile)) {
        // If it's the first round and the tile is not on the perimeter, ignore the tap
        return;
      }
    } else {
      if (!isTileAdjacent(tile)) {
        // In subsequent rounds, only allow adjacent tiles to be selected
        return;
      }
    }
    if (currentPlayer == 1) {
      if (tile.tileType == TileType.point) {
        player1PointsCollection.add(tile);
        lastCollectedPositionPlayer1 = tilePosition;
        p1StoredPointsDisplay.updateDisplay();
        tile.startCollectedAnimation();
        moveToLastCollectedTile(
            player1, lastCollectedPositionPlayer1); // Move the player
        if (player1PointsCollection.length >= 3) {
          endGame(1);
          return;
        }
      } else {
        if (player1Collection.length < 5) {
          player1Collection.add(tile);
          player1.storedElements.add(tile);
          lastCollectedPositionPlayer1 = tilePosition;
          p1StoredElementsDisplay.updateDisplay();
          tile.startCollectedAnimation();
          moveToLastCollectedTile(
              player1, lastCollectedPositionPlayer1); // Move the player
        } else {
          lastCollectedPositionPlayer1 = tilePosition;
        }
      }
    } else {
      if (tile.tileType == TileType.point) {
        player2PointsCollection.add(tile);
        lastCollectedPositionPlayer2 = tilePosition;
        p2StoredPointsDisplay.updateDisplay();
        tile.startCollectedAnimation();
        moveToLastCollectedTile(
            player2, lastCollectedPositionPlayer2); // Move the player
        if (player2PointsCollection.length >= 3) {
          endGame(2);
          return;
        }
      } else {
        if (player2Collection.length < 5) {
          player2Collection.add(tile);
          player2.storedElements.add(tile);
          lastCollectedPositionPlayer2 = tilePosition;
          p2StoredElementsDisplay.updateDisplay();
          tile.startCollectedAnimation();
          moveToLastCollectedTile(
              player2, lastCollectedPositionPlayer2); // Move the player
        } else {
          lastCollectedPositionPlayer2 = tilePosition;
        }
      }
    }
    tile.isStoredCard = true;
    switchTurn(); // switch turn even if no element is stored
  }

  bool isTileOnPerimeter(Tile tile) {
    Point<int>? position = gameBoard.tilePositions[tile];
    if (position == null) return false;

    int row = position.y;
    int col = position.x;

    return row == 0 ||
        row == gameBoard.rows - 1 ||
        col == 0 ||
        col == gameBoard.columns - 1;
  }

  // bool isFirstRound() {
  //   return player1Collection.isEmpty || player2Collection.isEmpty;
  // }

  bool isTileAdjacent(Tile tile) {
    Point<int>? lastPosition = currentPlayer == 1
        ? lastCollectedPositionPlayer1
        : lastCollectedPositionPlayer2;
    Point<int>? currentPosition = gameBoard.tilePositions[tile];
    if (currentPosition == null || lastPosition == null) {
      return false;
    }

    // Check for adjacency (up, down, left, right)
    return (currentPosition.x == lastPosition.x &&
            (currentPosition.y == lastPosition.y - 1 ||
                currentPosition.y == lastPosition.y + 1)) ||
        (currentPosition.y == lastPosition.y &&
            (currentPosition.x == lastPosition.x - 1 ||
                currentPosition.x == lastPosition.x + 1));
  }

  void updatePlayerTurnText() {
    if (isSpellPhase) {
      playerTurnText.text =
          "Player $currentPlayer's Turn:\nSelect a spell to cast, or skip.";
    } else {
      playerTurnText.text =
          "Player $currentPlayer's Turn:\nCollect an Element to end your turn.";
    }
    playerTurnText.position = Vector2(300, 365);
  }

  void endGame(int player) {
    overlays.add(
        'P${player}WinningOverlay'); // Assuming you have a 'WinningOverlay' defined
    // Here you would also handle any other end-of-game logic, such as disabling input,
    // showing a dialog, playing a sound, or transitioning to another screen.
  }

  void moveToLastCollectedTile(
      Player player, Point<int>? lastCollectedPosition) {
    if (lastCollectedPosition != null) {
      // Calculate the top-left position of the tile in the game world, including spacing
      Vector2 tileTopLeftPosition = Vector2(
        lastCollectedPosition.x * (gameBoard.tileSize.x + gameBoard.spacing),
        lastCollectedPosition.y * (gameBoard.tileSize.y + gameBoard.spacing),
      );

      // // Add half the size of a tile to get to its center
      Vector2 tileCenterOffset =
          Vector2(gameBoard.tileSize.x / 2 - 10, gameBoard.tileSize.y / 2 - 10);

      // // Combine with the gameBoard's position to get the absolute position
      Vector2 targetPosition =
          tileTopLeftPosition + tileCenterOffset + gameBoard.position;

      // Create the MoveToEffect
      final effect = MoveToEffect(
        targetPosition,
        EffectController(duration: 1),
      );
      player.add(effect);
    }
  }

  // THIS IS ALL FIRE ELEMENT LOGIC BELOW - LOOK THROUGH AND UNDERSTAND
  void prepareToDeleteAdjacentTile(Tile redTile) {
    // Determine the position of the red tile on the game board
    Point<int>? redTilePosition = gameBoard.tilePositions[redTile];

    if (redTilePosition == null) return;

    // Find adjacent tiles
    List<Tile> adjacentTiles = getAdjacentTiles(redTilePosition);

    // Highlight the adjacent tiles for selection
    highlightAdjacentTiles(adjacentTiles);

    // Setup logic to handle player's selection on these adjacent tiles
    setupSelectionLogic(adjacentTiles);
  }

  List<Tile> getAdjacentTiles(Point<int> position) {
    List<Tile> adjacentTiles = [];

    // Define adjacent positions
    List<Point<int>> adjacentPositions = [
      Point(position.x, position.y - 1), // Up
      Point(position.x, position.y + 1), // Down
      Point(position.x - 1, position.y), // Left
      Point(position.x + 1, position.y), // Right
    ];

    for (var adjacentPosition in adjacentPositions) {
      // Check if the adjacent position is within the bounds of the game board
      if (isPositionValid(adjacentPosition)) {
        Tile? adjacentTile = getTileAt(adjacentPosition);
        if (adjacentTile != null) {
          adjacentTiles.add(adjacentTile);
        }
      }
    }

    return adjacentTiles;
  }

  bool isPositionValid(Point<int> position) {
    return position.x >= 0 &&
        position.x < gameBoard.columns &&
        position.y >= 0 &&
        position.y < gameBoard.rows;
  }

  Tile? getTileAt(Point<int> position) {
    // Iterate through the tilePositions map to find the tile at the given position
    for (var entry in gameBoard.tilePositions.entries) {
      if (entry.value == position) {
        // Return the tile if its position matches the given position
        return entry.key;
      }
    }
    return null; // Return null if no tile is found at the position
  }

  void highlightAdjacentTiles(List<Tile> tiles) {
    // Iterate through each tile in the list
    for (var tile in tiles) {
      // Set the highlighted property to true
      tile.highlighted = true;

      // If you have implemented a specific highlight method in your Tile class
      // tile.highlight(); // Uncomment this if you have a highlight() method in Tile class

      // If you want to add a visual effect (like a border or overlay), you can add it here
      // Example: Add a border effect to the tile
      // final borderEffect = BorderEffect(...); // Define your effect according to your needs
      // tile.add(borderEffect); // Add the effect to the tile
    }
  }

  void setupSelectionLogic(List<Tile> tiles) {
    // Implement logic that allows the player to select one of these tiles
    // Upon selection, call 'deleteTile' method for the selected tile
  }

  void deleteTile(Tile tileToDelete) {
    // Remove the tile from the game and display fire particle effect
    remove(tileToDelete);
    addFireParticleEffectAt(tileToDelete.position);
  }

  void addFireParticleEffectAt(Vector2 position) {
    final fireParticle = ParticleSystemComponent(
      particle: Particle.generate(
        count: 100,
        generator: (i) => FireParticle(),
      ),
      position: position,
    );
    add(fireParticle);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('hud/knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('hud/joystick.png'),
        ),
      ),
      position: Vector2(50, 50),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.up:
        player1.playerDirection = PlayerDirection.up;
        player1.velocity = Vector2(0, -player1.moveSpeed);
        break;
      case JoystickDirection.upLeft:
        player1.playerDirection = PlayerDirection.upLeft;
        player1.velocity = Vector2(0, -player1.moveSpeed);
        break;
      case JoystickDirection.upRight:
        player1.playerDirection = PlayerDirection.upRight;
        player1.velocity = Vector2(0, -player1.moveSpeed);
        break;
      case JoystickDirection.right:
        player1.playerDirection = PlayerDirection.right;
        player1.velocity = Vector2(player1.moveSpeed, 0);
        break;
      case JoystickDirection.down:
        player1.playerDirection = PlayerDirection.down;
        player1.velocity = Vector2(0, player1.moveSpeed);
        break;
      case JoystickDirection.downLeft:
        player1.playerDirection = PlayerDirection.downLeft;
        player1.velocity = Vector2(0, player1.moveSpeed);
        break;
      case JoystickDirection.downRight:
        player1.playerDirection = PlayerDirection.downRight;
        player1.velocity = Vector2(0, player1.moveSpeed);
        break;
      case JoystickDirection.left:
        player1.playerDirection = PlayerDirection.left;
        player1.velocity = Vector2(-player1.moveSpeed, 0);
        break;
      default:
        player1.playerDirection = PlayerDirection.none;
        break;
    }
  }
}

class FireParticle extends Particle {
  @override
  void render(Canvas canvas) {
    // Render fire particle
    // This is where you'd draw your fire particle effect
  }
}

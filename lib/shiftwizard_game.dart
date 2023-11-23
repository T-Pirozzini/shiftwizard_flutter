import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:shift_wizard_flutter/components/gameboard.dart';
import 'package:shift_wizard_flutter/components/parallax.dart';
import 'package:shift_wizard_flutter/components/player.dart';
import 'package:shift_wizard_flutter/components/stored_cards.dart';
import 'package:shift_wizard_flutter/components/stored_points.dart';
import 'package:shift_wizard_flutter/components/tile.dart';
import 'package:shift_wizard_flutter/components/level.dart';

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
    player1.position = Vector2(0, 0);
    add(player1);

    addJoystick();
  }

  @override
  void update(double dt) {
    updateJoystick();
    super.update(dt);
  }

  // Method to switch turns
  void switchTurn() {
    currentPlayer = currentPlayer == 1 ? 2 : 1;
    updatePlayerTurnText();
  }

  void handleTileTap(Tile tile) {
    Point<int>? tilePosition = gameBoard.tilePositions[tile];
    if (tilePosition == null) return;
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
        // moveToLastCollectedTile(
        //     player, lastCollectedPositionPlayer2); // Move the player
        if (player2PointsCollection.length >= 3) {
          endGame(2);
          return;
        }
      } else {
        if (player2Collection.length < 5) {
          player2Collection.add(tile);
          lastCollectedPositionPlayer2 = tilePosition;
          p2StoredElementsDisplay.updateDisplay();
          tile.startCollectedAnimation();
          // moveToLastCollectedTile(
          //     player, lastCollectedPositionPlayer2); // Move the player
        } else {
          lastCollectedPositionPlayer2 = tilePosition;
        }
      }
    }
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
    String text;
    if (currentPlayer == 1) {
      text =
          "Player 1's Turn:\nYou may play a Stored Element.\nCollect an Element to end your turn.";
    } else {
      text =
          "Player 2's Turn:\nYou may play a Stored Element.\nCollect an Element to end your turn.";
    }

    playerTurnText.text = text;
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

      // Apply the effect to the player
      player.add(effect);
    }
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

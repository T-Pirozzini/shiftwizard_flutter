import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:shift_wizard_flutter/components/gameboard.dart';
import 'package:shift_wizard_flutter/components/parallax.dart';
import 'package:shift_wizard_flutter/components/player.dart';
import 'package:shift_wizard_flutter/components/stored_cards.dart';
import 'package:shift_wizard_flutter/components/tile.dart';
import 'package:shift_wizard_flutter/components/level.dart';

class ShiftWizardGame extends FlameGame with TapDetector, DragCallbacks {
  late GameBoard gameBoard;

  @override
  bool debugMode = true;
  late final CameraComponent cam;
  Player player = Player();
  late JoystickComponent joystick;

  // Player turn indicator
  List<Tile> player1Collection = [];
  List<Tile> player2Collection = [];
  int currentPlayer = 1; // Start with player 1

  // Stored elements display
  late StoredElementsDisplay p1StoredElementsDisplay;
  late StoredElementsDisplay p2StoredElementsDisplay;

  // Method to switch turns
  void switchTurn() {
    currentPlayer = currentPlayer == 1 ? 2 : 1;

    // collectedCardDisplay.setCurrentPlayer(currentPlayer);
  }

  void handleTileTap(Tile tile) {
    if (currentPlayer == 1) {
      player1Collection.add(tile);
      p1StoredElementsDisplay.updateDisplay();
    } else {
      player2Collection.add(tile);
      p2StoredElementsDisplay.updateDisplay();
    }
    tile.startCollectedAnimation(); // Start the animation
    switchTurn();
  }

  @override
  Future<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();

    final world = Level(player: player);

    cam = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 360);
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);

    camera.viewport.addAll(
      [
        // TextComponent(
        //   text: 'Player 1: Elements',
        //   position: Vector2(20, 10),
        // ),
        // TextComponent(
        //   text: 'Player 2: Elements',
        //   position: Vector2(640, 10),
        // ),
      ],
    );

    add(MyParallaxComponent());

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

    addJoystick();
  }

  @override
  void update(double dt) {
    updateJoystick();
    super.update(dt);
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
        player.playerDirection = PlayerDirection.up;
        player.velocity = Vector2(0, -player.moveSpeed);
        break;
      case JoystickDirection.upLeft:
        player.playerDirection = PlayerDirection.upLeft;
        player.velocity = Vector2(0, -player.moveSpeed);
        break;
      case JoystickDirection.upRight:
        player.playerDirection = PlayerDirection.upRight;
        player.velocity = Vector2(0, -player.moveSpeed);
        break;
      case JoystickDirection.right:
        player.playerDirection = PlayerDirection.right;
        player.velocity = Vector2(player.moveSpeed, 0);
        break;
      case JoystickDirection.down:
        player.playerDirection = PlayerDirection.down;
        player.velocity = Vector2(0, player.moveSpeed);
        break;
      case JoystickDirection.downLeft:
        player.playerDirection = PlayerDirection.downLeft;
        player.velocity = Vector2(0, player.moveSpeed);
        break;
      case JoystickDirection.downRight:
        player.playerDirection = PlayerDirection.downRight;
        player.velocity = Vector2(0, player.moveSpeed);
        break;
      case JoystickDirection.left:
        player.playerDirection = PlayerDirection.left;
        player.velocity = Vector2(-player.moveSpeed, 0);
        break;
      default:
        player.playerDirection = PlayerDirection.none;
        break;
    }
  }
}

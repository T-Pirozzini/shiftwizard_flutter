import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:shift_wizard_flutter/components/gameboard.dart';
import 'package:shift_wizard_flutter/components/parallax.dart';
import 'package:shift_wizard_flutter/components/play_area.dart';
import 'package:shift_wizard_flutter/components/player.dart';
import 'package:shift_wizard_flutter/components/tile.dart';
import 'package:shift_wizard_flutter/hud.dart';
import 'package:flame/text.dart';

enum WizardState {
  idle,
  running,
}

class ShiftWizardGame extends FlameGame with TapDetector {
  late GameBoard gameBoard;
  late CollectedCardDisplay collectedCardDisplay;
  late HUD hud;
  late WizardAnimation wizardAnimation;

  @override
  bool debugMode = true;

  ShiftWizardGame()
      : super(
        // camera: CameraComponent.withFixedResolution(width: 400, height: 1024),
        // world: HUD(),
        ) {}

  // Player turn indicator
  List<Tile> player1Collection = [];
  List<Tile> player2Collection = [];
  int currentPlayer = 1; // Start with player 1

  // Method to switch turns
  void switchTurn() {
    currentPlayer = currentPlayer == 1 ? 2 : 1;
    collectedCardDisplay.setCurrentPlayer(currentPlayer);
  }

  void handleTileTap(Tile tile) {
    if (currentPlayer == 1) {
      player1Collection.add(tile);
    } else {
      player2Collection.add(tile);
    }
    updateCollectedCardDisplay();
    switchTurn();
  }

  void updateCollectedCardDisplay() {
    List<Tile> currentPlayerCollection =
        (currentPlayer == 1) ? player1Collection : player2Collection;
    collectedCardDisplay.updateCards(currentPlayerCollection);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    renderCollectedTiles(canvas, player1Collection, Vector2(10, size.y - 100));
    renderCollectedTiles(
        canvas, player2Collection, Vector2(size.x - 210, size.y - 100));
  }

  void renderCollectedTiles(
      Canvas canvas, List<Tile> tiles, Vector2 startPosition) {
    double x = startPosition.x;
    double y = startPosition.y;
    for (var tile in tiles) {
      tile.renderPositioned(canvas, Vector2(x, y));
      x += tile.size.x + 5;
      if (x + tile.size.x > size.x) {
        x = startPosition.x;
        y -= tile.size.y + 5;
      }
    }
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    add(MyParallaxComponent());
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

    collectedCardDisplay = CollectedCardDisplay()
      ..size = Vector2(200, 300) // Set appropriate size
      ..position = Vector2(110, 700); // Below the gameboard

    collectedCardDisplay.setCurrentPlayer(currentPlayer);
    add(collectedCardDisplay);

    // hud = HUD();
    // add(hud);

    final textRenderer = TextPaint(
      style: TextStyle(fontSize: 25, color: BasicPalette.white.color),
    );
    final textRendererBlk = TextPaint(
      style: TextStyle(fontSize: 25, color: BasicPalette.black.color),
    );
    camera.viewfinder.add(
      TextButton(
        text: 'Play Again?',
        textRenderer: textRenderer,
        position: Vector2(0, 375),
        anchor: Anchor.center,
      ),
    );
    camera.viewport.addAll([
      TextComponent(
        text: 'SHIFT WIZARD',
        textRenderer: textRendererBlk,
        position: Vector2(120, 50),
      ),
    ]);
    // Load animations
    final runningAnimation = await loadSpriteAnimation(
      'actors/wizard_animation.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.2,
        textureSize: Vector2(32, 32),
      ),
    );
    final idleAnimation = await loadSpriteAnimation(
      'actors/wizard_animation.png',
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: 0.4,
        textureSize: Vector2(32, 32),
      ),
    );

    // Create and add the WizardAnimation component
    final wizardAnimation = WizardAnimation(
      runningAnimation: runningAnimation,
      idleAnimation: idleAnimation,
      onTileTapped: (wizard) {
        // Handle tile tap
        print('Wizard Tapped!');
      },
    );
    add(wizardAnimation);
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
            size: Vector2(200, 50),
            paint: Paint()
              ..color = Colors.orange
              ..strokeWidth = 2
              ..style = PaintingStyle.stroke,
          ),
          buttonDown: RectangleComponent(
            size: Vector2(200, 50),
            paint: Paint()..color = BasicPalette.orange.color.withOpacity(0.5),
          ),
          children: [
            TextComponent(
              text: text,
              textRenderer: textRenderer,
              position: Vector2(100, 25),
              anchor: Anchor.center,
            ),
          ],
        );
}

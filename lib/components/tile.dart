import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';
import 'package:shift_wizard_flutter/shiftwizard_game.dart';

enum TileType { red, yellow, green, blue }

class Tile extends SpriteAnimationComponent
    with HasGameRef<ShiftWizardGame>, TapCallbacks {
  final TileType tileType;

  // Add a callback function for when the tile is tapped
  final Function(Tile) onTileTapped;

  Tile({required this.tileType, Vector2? size, required this.onTileTapped})
      : super(size: size) {
    // Size can be passed to the super constructor
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Load the animation for the tile based on its tileType
    animation = await _loadAnimationForType(tileType);
    // If you have a fixed size for tiles, you can set it here
    size = Vector2(60.0, 60.0); // Example size, adjust as needed
  }

  Future<SpriteAnimation> _loadAnimationForType(TileType tileType) async {
    String imagePath;
    int frameCount;
    double stepTime = 0.1; // Default step time, adjust as needed

    switch (tileType) {
      case TileType.red:
        imagePath = 'tiles/red_tile.png'; // Replace with your actual asset path
        frameCount = 6; // Replace with the actual frame count for red tiles
        break;
      case TileType.yellow:
        imagePath =
            'tiles/yellow_tile.png'; // Replace with your actual asset path
        frameCount = 6; // Replace with the actual frame count for yellow tiles
        break;
      case TileType.green:
        imagePath =
            'tiles/green_tile.png'; // Replace with your actual asset path
        frameCount = 9; // Replace with the actual frame count for green tiles
        break;
      case TileType.blue:
        imagePath =
            'tiles/blue_tile.png'; // Replace with your actual asset path
        frameCount = 4; // Replace with the actual frame count for blue tiles
        break;
      default:
        imagePath = 'tiles/default_tile.png'; // Fallback image path
        frameCount = 1; // Default frame count for fallback
        break;
    }
    final spriteSheet = await _loadSpriteSheet(imagePath, frameCount);
    return spriteSheet.createAnimation(
        row: 0, stepTime: stepTime, from: 0, to: frameCount - 1);
  }

  Future<SpriteSheet> _loadSpriteSheet(String path, int frameCount) async {
    final image = await Flame.images.load(path);
    return SpriteSheet(
        image: image,
        srcSize: Vector2(
            image.width / frameCount, // Calculate the width of a single frame
            60.0 // The height of the frame
            ));
  }

  @override
  void onTapDown(TapDownEvent event) {
    // Call the callback function when the tile is tapped
    onTileTapped(this);
    print(event);
    print("Tile tapped!!!!");
  }

  void renderPositioned(Canvas canvas, Vector2 vector2) {
    this.position = position;
    render(canvas);
  }

  void startCollectedAnimation() {
    // Example: Scale animation
    add(
      ScaleEffect.to(
        Vector2.all(1.5), // Scale up to 150%
        EffectController(
          duration: 0.5, // Half a second
          reverseDuration: 0.5, // And then reverse
        ),
      )..onComplete =
          () => removeFromParent(), // Optionally remove after completion
    );
  }
}

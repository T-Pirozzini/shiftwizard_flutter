import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:shift_wizard_flutter/shiftwizard_game.dart';

class HUD extends World
    with HasGameReference<ShiftWizardGame>, TapCallbacks, DoubleTapCallbacks {
  late SpriteComponent player;
  @override
  Future<void> onLoad() async {
    final playerSprite = await game.loadSprite('actors/player.png');
    final visibleSize = game.camera.visibleWorldRect.toVector2();
    // add(player = SpriteComponent(sprite: playerSprite, anchor: Anchor.center));
    addAll([
      SpriteComponent(
        sprite: playerSprite,
        anchor: Anchor.center,
        position: -visibleSize / 4,
        size: Vector2(80, 120),
      ),
      SpriteComponent(
        sprite: playerSprite,
        anchor: Anchor.center,
        position: (visibleSize / 4)..multiply(Vector2(1, -1)),
        size: Vector2(80, 120),
      ),
    ]);
  }
}

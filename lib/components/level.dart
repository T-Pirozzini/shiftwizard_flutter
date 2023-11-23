import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:shift_wizard_flutter/components/player.dart';

class Level extends World {
  final Player player;

  Level({required this.player});

  @override
  Future<void> onLoad() async {
    player.position = Vector2(0, 0);
    add(player);
    // Optional: Animate the player entering the scene
    final entryEffect = MoveToEffect(
      Vector2(100,
          100), // Target position for the player to move to upon entering the scene
      EffectController(duration: 2.0),
    );
    player.add(entryEffect);
    super.onLoad();
  }
}

import 'package:flame/components.dart';
import 'package:shift_wizard_flutter/components/player.dart';

class Level extends World {
  final Player player;

  Level({required this.player});

  @override
  Future<void> onLoad() async {
    player.position = Vector2(100, 100);
    add(player);
    super.onLoad();
  }
}

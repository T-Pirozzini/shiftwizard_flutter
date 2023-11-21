import 'package:flame/components.dart';
import 'package:shift_wizard_flutter/actors/player.dart';

class Level extends World {

  
  @override
  Future<void> onLoad() async {
    final player = Player(position: Vector2(100, 100));
    add(player);
    super.onLoad();
  }
}

import 'dart:async';

import 'package:flame/components.dart';
import 'package:shift_wizard_flutter/actors/player.dart';
// import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  // late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    // level = await TiledComponent.load(fileName, Vector2.all(16));

    // add(level);
    add(
      Player(character: 'Soulo', position: Vector2(100, 100)),
    );

    return super.onLoad();
  }
}

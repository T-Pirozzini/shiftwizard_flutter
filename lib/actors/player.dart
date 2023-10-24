import 'dart:async';

import 'package:flame/components.dart';
import 'package:shift_wizard_flutter/shift_wizard.dart';

enum PlayerState { idle, walk, jump, hit, dead }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<ShiftWizard> {
  String character;
  Player({position, required this.character}) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation walkAnimation;
  late final SpriteAnimation jumpAnimation;
  late final SpriteAnimation hitAnimation;
  late final SpriteAnimation deadAnimation;
  final double stepTime = 0.1;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  void _loadAllAnimations() {   
    idleAnimation = _spriteAnimation('idle', 8);
    walkAnimation = _spriteAnimation('walk', 6);
    jumpAnimation = _spriteAnimation('jump', 4);
    hitAnimation = _spriteAnimation('hit', 2);
    deadAnimation = _spriteAnimation('dead', 25);

    // List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.walk: walkAnimation,
      PlayerState.jump: jumpAnimation,
      PlayerState.hit: hitAnimation,
      PlayerState.dead: deadAnimation,
    };

    // set current animation
    current = PlayerState.walk;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/soulo_$state.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(64),
      ),
    );
  }
}

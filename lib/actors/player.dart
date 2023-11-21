import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:shift_wizard_flutter/shiftwizard_game.dart';

enum PlayerState { idle, down, right, left, up }

enum PlayerDirection { down, right, left, up, none }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<ShiftWizardGame>, TapCallbacks {
  Player({position}) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation upAnimation;
  late final SpriteAnimation rightAnimation;
  late final SpriteAnimation leftAnimation;
  late final SpriteAnimation downAnimation;
  final double stepTime = 0.1;

  PlayerDirection playerDirection = PlayerDirection.none;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();

  // final SpriteAnimation runningAnimation;
  // final SpriteAnimation idleAnimation;
  // final Function(WizardAnimation) onTileTapped;

  // PlayerAnimation({
  //   required this.runningAnimation,
  //   required this.idleAnimation,
  //   required this.onTileTapped,
  // }) : super(size: Vector2(32, 32));

  @override
  Future<void> onLoad() async {
    _loadAllAnimations();

    super.onLoad();
    // Use the provided animations
    // animations = {
    //   WizardState.running: runningAnimation,
    //   WizardState.idle: idleAnimation,
    // };
    // current = WizardState.idle;
    // position = Vector2(120, 120); // Adjust as needed
    // size = Vector2(32, 32); // Adjust as needed
  }

  @override
  void onTapDown(_) {
    current = WizardState.running;
  }

  // @override
  // void onTapCancel() {
  //   current = WizardState.idle;
  // }

  @override
  void onTapUp(_) {
    current = WizardState.idle;
  }

  @override
  Color backgroundColor() => const Color(0xFF222222);

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation(0, 0);
    downAnimation = _spriteAnimation(0, 3);
    rightAnimation = _spriteAnimation(4, 7);
    leftAnimation = _spriteAnimation(8, 11);
    upAnimation = _spriteAnimation(12, 15);

    // list of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.up: upAnimation,
      PlayerState.right: rightAnimation,
      PlayerState.left: leftAnimation,
      PlayerState.down: downAnimation,
    };

    // set current animation
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(start, end) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('main_characters/wizard/wizard.png'),
      SpriteAnimationData.range(
        start: start,
        end: end,
        amount: 16,
        stepTimes: [stepTime, stepTime, stepTime, stepTime],
        textureSize: Vector2.all(32),
      ),
    );
  }
}

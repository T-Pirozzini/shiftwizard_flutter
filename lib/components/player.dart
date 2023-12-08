import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:shift_wizard_flutter/components/tile.dart';
import 'package:shift_wizard_flutter/shiftwizard_game.dart';

enum PlayerState { idle, down, right, left, up }

enum PlayerDirection {
  down,
  downRight,
  downLeft,
  right,
  left,
  up,
  upRight,
  upLeft,
  none
}

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

  List<Tile> storedElements = [];

  @override
  Future<void> onLoad() async {
    _loadAllAnimations();

    super.onLoad();
  }

  @override
  void update(double dt) {
    updatePlayerMovement(dt);

    super.update(dt);
  }

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

  void updatePlayerMovement(double dt) {
    double dirX = 0.0;
    double dirY = 0.0;

    switch (playerDirection) {
      case PlayerDirection.down:
        current = PlayerState.down;
        dirY += moveSpeed;
        break;
      case PlayerDirection.downLeft:
        current = PlayerState.left;
        dirY += moveSpeed * .75;
        dirX -= moveSpeed * .75;
        break;
      case PlayerDirection.downRight:
        current = PlayerState.right;
        dirY += moveSpeed * .75;
        dirX += moveSpeed * .75;
        break;
      case PlayerDirection.right:
        current = PlayerState.right;
        dirX += moveSpeed;
        break;
      case PlayerDirection.left:
        current = PlayerState.left;
        dirX -= moveSpeed;
        break;
      case PlayerDirection.up:
        current = PlayerState.up;
        dirY -= moveSpeed;
        break;
      case PlayerDirection.upLeft:
        current = PlayerState.left;
        dirY -= moveSpeed * .75;
        dirX -= moveSpeed * .75;
        break;
      case PlayerDirection.upRight:
        current = PlayerState.right;
        dirY -= moveSpeed * .75;
        dirX += moveSpeed * .75;
        break;
      default:
        current = PlayerState.idle;
        break;
    }

    velocity = Vector2(dirX, dirY);
    position += velocity * dt;
  }
}

import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:shift_wizard_flutter/shiftwizard_game.dart';

class WizardAnimation extends SpriteAnimationGroupComponent<WizardState>
    with TapCallbacks {
  final SpriteAnimation runningAnimation;
  final SpriteAnimation idleAnimation;
  final Function(WizardAnimation) onTileTapped;

  WizardAnimation({
    required this.runningAnimation,
    required this.idleAnimation,
    required this.onTileTapped,
  }) : super(size: Vector2(32, 32));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Use the provided animations
    animations = {
      WizardState.running: runningAnimation,
      WizardState.idle: idleAnimation,
    };
    current = WizardState.idle;
    position = Vector2(120, 120); // Adjust as needed
    size = Vector2(32, 32); // Adjust as needed
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
}
